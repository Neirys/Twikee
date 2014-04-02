//
//  Twikee.m
//  TwikeeBasicTest
//
//  Created by Yaman JAIOUCH on 02/04/2014.
//  Copyright (c) 2014 Yaman JAIOUCH. All rights reserved.
//

#import "Twikee.h"

@interface Twikee () <UIAlertViewDelegate>

@end

@implementation Twikee

+ (instancetype)sharedInstance
{
    static Twikee *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)showWithTitle:(NSString *)title tweetMessage:(NSString *)tweetMessage
{
    if ([self.delegate respondsToSelector:@selector(twikeeShouldDisplay)])
    {
        BOOL shouldDisplay = [self.delegate twikeeShouldDisplay];
        if (!shouldDisplay) return;
    }
    
    if ([self.delegate respondsToSelector:@selector(twikeeWillDisplay)])
    {
        [self.delegate twikeeWillDisplay];
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
}

@end
