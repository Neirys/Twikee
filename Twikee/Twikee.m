//
//  Twikee.m
//
//  Version 1.0
//
//  https://github.com/Neirys/Twikee
//
//  Created by Yaman JAIOUCH on 02/04/2014.
//
//  Copyright (c) 2014 Yaman JAIOUCH
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

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
    [self showWithTitle:title tweetMessage:tweetMessage prefixMessage:nil];
}

- (void)showWithTitle:(NSString *)title tweetMessage:(NSString *)tweetMessage prefixMessage:(NSString *)prefixMessage
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
    if (prefixMessage && ![prefixMessage isEqualToString:@""])
    {
        tweetMessage = [prefixMessage stringByAppendingString:tweetMessage];
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
