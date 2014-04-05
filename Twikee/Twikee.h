//
//  Twikee.h
//  TwikeeBasicTest
//
//  Created by Yaman JAIOUCH on 02/04/2014.
//  Copyright (c) 2014 Yaman JAIOUCH. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TwikeeErrorCode)
{
    TwikeeErrorCodeTwitterUnavailable,
    TwikeeErrorCodeEmptyTweet,
    TwikeeErrorCodeFailedTweeting,
};

@protocol TwikeeDelegate <NSObject>

@optional
- (BOOL)twikeeShouldDisplay;
- (void)twikeeWillDisplay;
- (void)twikeeDidDisplay;
- (void)twikeeDidCancel;
- (void)twikeeDidSendTweet:(NSString *)tweet;
- (void)twikeeDidFailWithError:(NSError *)error;

@end

@interface Twikee : NSObject

// delegate for implementing custom behavior
@property (weak, nonatomic) id<TwikeeDelegate> delegate;

// get singleton object
+ (instancetype)sharedInstance;

// return NO if there's no Twitter account binded on the device
- (BOOL)canSendTweet;

// call showWithTitle:tweetMessage:prefixMessage with prefixMessage set to nil
- (void)showWithTitle:(NSString *)title tweetMessage:(NSString *)tweetMessage;

// display an UIAlertView that prompt a user to send an advertising tweet
// prefixMessage parameter is just an informative message an will not be sent with the tweet
// warning : this method will throw an exception if tweetMessage characters count > 140
- (void)showWithTitle:(NSString *)title tweetMessage:(NSString *)tweetMessage prefixMessage:(NSString *)prefixMessage;

@end
