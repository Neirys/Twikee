//
//  TwikeeBasicTestTests.m
//  TwikeeBasicTestTests
//
//  Created by Yaman JAIOUCH on 02/04/2014.
//  Copyright (c) 2014 Yaman JAIOUCH. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "Twikee.h"

@interface TwikeeBasicTestTests : XCTestCase
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

@end
