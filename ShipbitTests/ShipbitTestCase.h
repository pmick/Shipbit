//
//  ShipbitTests.h
//  ShipbitTests
//
//  Created by Patrick Mick on 6/7/13.
//  Copyright (c) 2013 PatrickMick. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <OCMock/OCMock.h>

@interface ShipbitTestCase : SenTestCase

- (void)setUp;
- (void)tearDown;

/// Returns the URL for a resource that's been added to the test target.
- (NSURL *)URLForResource:(NSString *)name withExtension:(NSString *)extension;

/// Calls +[OCMockObject mockForClass:] and adds the mock and call -verify on it during -tearDown
- (id)autoVerifiedMockForClass:(Class)aClass;
/// C.f. -autoVerifiedMockForClass:
- (id)autoVerifiedPartialMockForObject:(id)object;

/// Calls -verify on the mock during -tearDown
- (void)verifyDuringTearDown:(id)mock;


@end
