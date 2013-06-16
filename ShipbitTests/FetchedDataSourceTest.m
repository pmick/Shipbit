//
//  FetchedDataSourceTest.m
//  Shipbit
//
//  Created by Patrick Mick on 6/14/13.
//  Copyright (c) 2013 PatrickMick. All rights reserved.
//


#import "ShipbitTestCase.h"
#import "FetchedDataSource.h"


@interface FetchedDataSourceTest : ShipbitTestCase
@end



@implementation FetchedDataSourceTest

- (void)testInit
{
    STAssertNil([[FetchedDataSource alloc] init], @"Should not be allowed.");
}

- (void)testInitWithFetchRequestSectionNameKeyPathCellIdentifierConfigureBlock
{
    NSFetchRequest *request;
    STAssertNotNil([[FetchedDataSource alloc] initWithFetchRequest:request sectionNameKeyPath:@"section" cellIdentifier:@"Cell" configureCellBlock:^(UITableViewCell *a, id b){}], @"");
}

- (void)testCellConfiguration
{
//    NSFetchRequest *request = nil;
//    __block UITableViewCell *configuredCell = nil;
//    __block id configuredObject = nil;
//    TableViewCellConfigureBlock block = ^(UITableViewCell *a, id b) {
//        configuredCell = a;
//        configuredObject = b;
//    };
//    FetchedDataSource *dataSource = [[FetchedDataSource alloc] initWithFetchRequest:request sectionNameKeyPath:nil cellIdentifier:@"Cell" configureCellBlock:block];
}

@end
