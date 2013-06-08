//
//  ShipbitTests.m
//  ShipbitTests
//
//  Created by Patrick Mick on 6/7/13.
//  Copyright (c) 2013 PatrickMick. All rights reserved.
//

#import "ShipbitTests.h"
#import "OCMockObject.h"
#import "OCMock.h"
//#import "OCMArg.h"
//#import "OCMConstraint.h"
//#import "OCMockRecorder.h"

@implementation ShipbitTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testExample
{
    id mockUserDefaults = [OCMockObject mockForClass:[NSUserDefaults class]];

    [[[mockUserDefaults stub] andReturn:@"stuff"] objectForKey:@"key"];
    [[[mockUserDefaults stub] andReturn:@"thingy"] objectForKey:@"key2"];
    
    STAssertEqualObjects(@"stuff", [mockUserDefaults objectForKey:@"key"], nil);
    STAssertEqualObjects(@"thingy", [mockUserDefaults objectForKey:@"key2"], nil);
}

@end
