//
//  Twikee.m
//  TwikeeBasicTest
//
//  Created by Yaman JAIOUCH on 02/04/2014.
//  Copyright (c) 2014 Yaman JAIOUCH. All rights reserved.
//

@import Accounts;
@import Social;

#import "Twikee.h"

static NSString * const kTwikeeErrorDomain   =   @"TwikeeErrorDomain";

static NSString * const kTwikeeTwitterAPIPostTweetURL   =   @"https://api.twitter.com/1.1/statuses/update.json";
static NSString * const kTwikeeTwitterAPIPostTweetParameterTweet    =   @"status";

@interface Twikee () <UIAlertViewDelegate>
{
    NSArray *_twitterAccounts;
    NSString *_tweet;
}

@end

@implementation Twikee

#pragma mark - Life cycle

- (id)init
{
    self = [super init];
    if (self)
    {
        ACAccountStore *store = [[ACAccountStore alloc] init];
        ACAccountType *accountType = [store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        _twitterAccounts = [store accountsWithAccountType:accountType];
    }
    return self;
}

+ (instancetype)sharedInstance
{
    static Twikee *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

#pragma mark - Instance methods

- (BOOL)canSendTweet
{
    return _twitterAccounts.count > 0;
}

- (void)showWithTitle:(NSString *)title tweetMessage:(NSString *)tweetMessage
{
    NSAssert(tweetMessage.length <= 140, @"A tweet should not be up to 140 characters");
    
    if ([self.delegate respondsToSelector:@selector(twikeeShouldDisplay)])
    {
        BOOL shouldDisplay = [self.delegate twikeeShouldDisplay];
        if (!shouldDisplay) return;
    }
    
    if ([self.delegate respondsToSelector:@selector(twikeeWillDisplay)])
    {
        [self.delegate twikeeWillDisplay];
    }
    
    _tweet = [tweetMessage copy];
    if (_messagePrefix && ![_messagePrefix isEqualToString:@""])
    {
        tweetMessage = [_messagePrefix stringByAppendingString:tweetMessage];
    }
    
    [[[UIAlertView alloc] initWithTitle:title
                                message:tweetMessage
                               delegate:self
                      cancelButtonTitle:@"Cancel"
                      otherButtonTitles:@"Send", nil] show];
    
    if ([self.delegate respondsToSelector:@selector(twikeeDidDisplay)])
    {
        [self.delegate twikeeDidDisplay];
    }
}

#pragma mark - Helper methods

- (void)reset
{
    _tweet = nil;
}

- (void)sendTweet:(NSString *)tweet
{
    if (tweet == nil || [tweet isEqualToString:@""])
    {
        if ([self.delegate respondsToSelector:@selector(twikeeDidFailWithError:)])
        {
            NSError *error = [self errorForCode:TwikeeErrorCodeEmptyTweet];
            [self.delegate twikeeDidFailWithError:error];
        }
        
        [self reset];
        return;
    }
    
    if (_twitterAccounts == nil || _twitterAccounts.count <= 0)
    {
        if ([self.delegate respondsToSelector:@selector(twikeeDidFailWithError:)])
        {
            NSError *error = [self errorForCode:TwikeeErrorCodeTwitterUnavailable];
            [self.delegate twikeeDidFailWithError:error];
        }
        
        [self reset];
        return;
    }
    
    NSURL *URL = [NSURL URLWithString:kTwikeeTwitterAPIPostTweetURL];
    NSDictionary *parameters = @{kTwikeeTwitterAPIPostTweetParameterTweet : tweet};
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                            requestMethod:SLRequestMethodPOST
                                                      URL:URL
                                               parameters:parameters];
    request.account = _twitterAccounts[0];
    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        
        if (urlResponse.statusCode >= 200 && urlResponse.statusCode < 300)
        {
            if ([self.delegate respondsToSelector:@selector(twikeeDidSendTweet:)])
            {
                [self.delegate twikeeDidSendTweet:tweet];
            }
        }
        else
        {
            if ([self.delegate respondsToSelector:@selector(twikeeDidFailWithError:)])
            {
                NSError *error = [self errorForCode:TwikeeErrorCodeFailedTweeting];
                [self.delegate twikeeDidFailWithError:error];
            }
        }
    }];
}

- (NSError *)errorForCode:(TwikeeErrorCode)code
{
    switch (code) {
        case TwikeeErrorCodeTwitterUnavailable:
        {
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey : @"Operation failed",
                                       NSLocalizedFailureReasonErrorKey : @"There is no Twitter account authentified"
                                       };
            return [NSError errorWithDomain:kTwikeeErrorDomain
                                       code:TwikeeErrorCodeTwitterUnavailable
                                   userInfo:userInfo];

        }
        case TwikeeErrorCodeEmptyTweet:
        {
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey : @"Operation failed",
                                       NSLocalizedFailureReasonErrorKey : @"Tweet message should not be nil or empty"
                                       };
            return [NSError errorWithDomain:kTwikeeErrorDomain
                                       code:TwikeeErrorCodeEmptyTweet
                                   userInfo:userInfo];
        }
        case TwikeeErrorCodeFailedTweeting:
        {
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey : @"Operation failed",
                                       NSLocalizedFailureReasonErrorKey : @"Failed tweeting"
                                       };
            return [NSError errorWithDomain:kTwikeeErrorDomain
                                       code:TwikeeErrorCodeFailedTweeting
                                   userInfo:userInfo];
        }
    }
}

#pragma mark - UIAlertView delegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.cancelButtonIndex)
    {
        if ([self.delegate respondsToSelector:@selector(twikeeDidCancel)])
        {
            [self.delegate twikeeDidCancel];
        }
    }
    else if (buttonIndex == 1)
    {
        [self sendTweet:_tweet];
    }
}

@end
