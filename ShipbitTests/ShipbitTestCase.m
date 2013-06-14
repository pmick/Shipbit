//
//  ShipbitTests.m
//  ShipbitTests
//
//  Created by Patrick Mick on 6/7/13.
//  Copyright (c) 2013 PatrickMick. All rights reserved.
//

#import "ShipbitTestCase.h"



@interface ShipbitTestCase ()

@property (nonatomic, strong) NSMutableArray *mocksToVerify;

@end



@implementation ShipbitTestCase

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    for (id mock in self.mocksToVerify) {
        [mock verify];
    }
    self.mocksToVerify = nil;
    [super tearDown];
}

- (NSURL *)URLForResource:(NSString *)name withExtension:(NSString *)extension
{
    NSBundle *bundle = [NSBundle bundleForClass:[ShipbitTestCase class]];
    return [bundle URLForResource:name withExtension:extension];
}

- (id)autoVerifiedMockForClass:(Class)aClass
{
    id mock = [OCMockObject mockForClass:aClass];
    [self verifyDuringTearDown:mock];
    return mock;
}

- (id)autoVerifiedPartialMockForObject:(id)object
{
    id mock = [OCMockObject partialMockForObject:object];
    [self verifyDuringTearDown:mock];
    return mock;
}

- (void)verifyDuringTearDown:(id)mock
{
    if (self.mocksToVerify == nil) {
        self.mocksToVerify = [NSMutableArray array];
    }
    [self.mocksToVerify addObject:mock];
}
@end
