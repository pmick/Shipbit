//
//  GameTests.m
//  Shipbit
//
//  Created by Patrick Mick on 6/14/13.
//  Copyright (c) 2013 PatrickMick. All rights reserved.
//

#import "ShipbitTestCase.h"
#import "Game.h"
#import "MagicalRecord+Setup.h"
#import "NSManagedObject+MagicalRecord.h"



@interface GameTests : ShipbitTestCase

@end



@implementation GameTests

- (void)setUp
{
    [MagicalRecord setDefaultModelFromClass:[Game class]];
    [MagicalRecord setupCoreDataStackWithInMemoryStore];
}

- (void)tearDown
{
    [MagicalRecord cleanUp];
}

- (void)testFirstLetterWithTitleThatHasACapitolFirstCharacter
{
    Game *game = [Game MR_createEntity];
    game.title = @"TheGame";
    NSString *expectedVal = @"T";
    STAssertTrue([[game firstLetter] isEqualToString:expectedVal], @"Expected correct first letter %@ != %@", [game firstLetter], expectedVal);
}

- (void)testFirstLetterWithTitleThatHasANumberFirstCharacter
{
    Game *game = [Game MR_createEntity];
    game.title = @"1Game";
    NSString *expectedVal = @"#";
    STAssertTrue([[game firstLetter] isEqualToString:expectedVal], @"Expected correct first letter %@ != %@", [game firstLetter], expectedVal);
}

- (void)testFirstLetterWithTitleThatIsAnEmptyString
{
    Game *game = [Game MR_createEntity];
    game.title = nil;
    STAssertNil([game firstLetter], @"Expected nil first letter for %@", [game firstLetter]);
}

@end
