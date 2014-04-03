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
    
//    ACAccountStore *store = [[ACAccountStore alloc] init];
//    ACAccountType *accountType = [store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
//    NSArray *accounts = [store accountsWithAccountType:accountType];
//    ACAccount *twitterAccount = accounts[0];
//    
//    NSURL *URL = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/update.json"];
//    NSDictionary *parameters = @{@"status": @"test twikee"};
//    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
//                                            requestMethod:SLRequestMethodPOST
//                                                      URL:URL
//                                               parameters:parameters];
//    request.account = twitterAccount;
//    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
//        NSLog(@"response date : %@", [[NSString alloc] initWithData:responseData
//                                                           encoding:NSUTF8StringEncoding]);
//        NSLog(@"response URL : %@", urlResponse);
//        NSLog(@"error : %@", error);
//    }];
    
    
//    ACAccountType *accountType = [store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
//    [store requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
//        NSLog(@"%@", @(granted));
//        NSLog(@"%@", error);
//        
//        NSLog(@"%@", store.accounts);
//        
//        NSURL *URL = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/update.json"];
//        NSDictionary *parameters = @{@"status": @"test twikee"};
//        SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
//                                                requestMethod:SLRequestMethodPOST
//                                                          URL:URL
//                                                   parameters:parameters];
//        [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
//            NSLog(@"response date : %@", [[NSString alloc] initWithData:responseData
//                                                               encoding:NSUTF8StringEncoding]);
//            NSLog(@"response URL : %@", urlResponse);
//            NSLog(@"error : %@", error);
//        }];
//    }];
    
    [[Twikee sharedInstance] setDelegate:self];
    [[Twikee sharedInstance] setPlaceholder:@"Preview : "];
    [[Twikee sharedInstance] showWithTitle:@"Would you like to send a promoted tweet to unlock a life ?"
                              tweetMessage:@"test"];
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
