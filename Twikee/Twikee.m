//
//  Twikee.m
//  TwikeeBasicTest
//
//  Created by Yaman JAIOUCH on 02/04/2014.
//  Copyright (c) 2014 Yaman JAIOUCH. All rights reserved.
//

#import "Twikee.h"

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
    [[[UIAlertView alloc] initWithTitle:title
                                message:tweetMessage
                               delegate:self
                      cancelButtonTitle:@"Cancel"
                      otherButtonTitles:@"Send", nil]
     show];
}

@end
