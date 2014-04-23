//
//  Twikee.h
//
//  Version 1.1
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
