//
//  Twikee.h
//  TwikeeBasicTest
//
//  Created by Yaman JAIOUCH on 02/04/2014.
//  Copyright (c) 2014 Yaman JAIOUCH. All rights reserved.
//

#import <Foundation/Foundation.h>

// Error codes
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


@property (copy, nonatomic) NSString *messagePrefix;

+ (instancetype)sharedInstance;

- (BOOL)canSendTweet;
- (void)showWithTitle:(NSString *)title tweetMessage:(NSString *)tweetMessage;

@end
