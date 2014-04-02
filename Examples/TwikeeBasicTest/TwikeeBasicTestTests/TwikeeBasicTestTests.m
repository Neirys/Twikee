//
//  TwikeeBasicTestTests.m
//  TwikeeBasicTestTests
//
//  Created by Yaman JAIOUCH on 02/04/2014.
//  Copyright (c) 2014 Yaman JAIOUCH. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "Twikee.h"

@interface TwikeeBasicTestTests : XCTestCase <TwikeeDelegate>
{
    Twikee *_twikee;
}

@end

@implementation TwikeeBasicTestTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    _twikee = [Twikee sharedInstance];
    _twikee.delegate = self;
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSharedInstance
{
    XCTAssertNotNil(_twikee, @"");
}

- (void)testShow
{
    NSString *title = @"test";
    NSString *message = @"test";
    
    [[Twikee sharedInstance] showWithTitle:title tweetMessage:message];
}

- (void)testShouldNotDisplayDelegate
{
    id<TwikeeDelegate> delegate = [Twikee sharedInstance].delegate;
    XCTAssertNotNil(delegate, @"");
    BOOL shouldDisplay = [delegate twikeeShouldDisplay];
    XCTAssertFalse(!shouldDisplay, @"");
}

- (void)testShouldDisplayDelegate
{
    id<TwikeeDelegate> delegate = [Twikee sharedInstance].delegate;
    XCTAssertNotNil(delegate, @"");
    BOOL shouldDisplay = [delegate twikeeShouldDisplay];
    XCTAssertTrue(shouldDisplay, @"");
}

#pragma mark - Twikee delegate

- (BOOL)twikeeShouldDisplay
{
    return YES;
}

@end
