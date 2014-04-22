//
//  ViewController.m
//  TwikeeBasicTest
//
//  Created by Yaman JAIOUCH on 02/04/2014.
//  Copyright (c) 2014 Yaman JAIOUCH. All rights reserved.
//

@import Social;
@import Accounts;

#import "ViewController.h"

#import "Twikee.h"

@interface ViewController () <TwikeeDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [[Twikee sharedInstance] setDelegate:self];
    [[Twikee sharedInstance] showWithTitle:@"Send a promoted tweet to unlock a life ?"
                              tweetMessage:@"Checkout the new Death Fire game @deathfire bit.ly/XXXXX"
                             prefixMessage:nil];
}

- (BOOL)twikeeShouldDisplay
{
    return YES;
}

- (void)twikeeWillDisplay
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)twikeeDidDisplay
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)twikeeDidCancel
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)twikeeDidSendTweet:(NSString *)tweet
{
    NSLog(@"%@", tweet);
}

- (void)twikeeDidFailWithError:(NSError *)error
{
    NSLog(@"%@", error);
}

@end
