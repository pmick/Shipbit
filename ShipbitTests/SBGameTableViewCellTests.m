//
//  SBGameTableViewCellTests.m
//  Shipbit
//
//  Created by Patrick Mick on 4/5/15.
//  Copyright (c) 2015 PatrickMick. All rights reserved.
//

#import "SBGameTableViewCell+ConfigureForGame.h"

#import <XCTest/XCTest.h>
#import <FBSnapshotTestCase/FBSnapshotTestCase.h>
#import <Expecta/Expecta.h>
#import <Expecta_Snapshots/EXPMatchers+FBSnapshotTest.h>

@interface SBGameTableViewCellTests : FBSnapshotTestCase

@end

@implementation SBGameTableViewCellTests

- (void)setUp {
    [super setUp];
    
    self.recordMode = YES;
}

- (SBGameTableViewCell *)cellForTesting {
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([SBGameTableViewCell class])
                                bundle:[NSBundle bundleForClass:[SBGameTableViewCell class]]];
    SBGameTableViewCell *cell = [[nib instantiateWithOwner:self options:nil] firstObject];
    return cell;
}

- (void)testDefaultCell {
    SBGameTableViewCell *cell = [self cellForTesting];
    cell.backgroundColor = [UIColor greenColor];
    expect(cell).toNot.beNil();
    expect(cell).to.beKindOf([SBGameTableViewCell class]);
    FBSnapshotVerifyLayer(cell.layer, @"should have default label values");
}

- (void)testCellWithVeryLongTitle {
    SBGameTableViewCell *cell = [self cellForTesting];
    cell.titleLabel.text = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc sit amet elit sed turpis volutpat laoreet. Integer ac tempor libero. Nulla blandit est sit amet mi elementum, eget tempus libero semper.";
    cell.dateLabel.text = @"Thingy";
    cell.platformsLabel.text = @"Thingy";
    cell.backgroundColor = [UIColor greenColor];
    FBSnapshotVerifyLayer(cell.layer, @"should wrap the text");
}

@end
