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
#import "NSDate+Utilities.h"
#import "Platform.h"



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

- (void)testWatchSectionWithYesterdayDate
{
    Game *game = [Game MR_createEntity];
    game.releaseDate = [NSDate dateYesterday];
    NSString *expectedVal = @"Shipped";
    STAssertTrue([[game watchSection] isEqualToString:expectedVal], @"Expected game that released yesterday to be shipped.");
}

- (void)testWatchSectionWithTomorrowDate
{
    Game *game = [Game MR_createEntity];
    game.releaseDate = [NSDate dateTomorrow];
    NSString *expectedVal = @"Upcoming";
    STAssertTrue([[game watchSection] isEqualToString:expectedVal], @"Expected game that releases tomorrow to be upcoming.");
}

- (void)testWatchSectionWithTodaysDate
{
    Game *game = [Game MR_createEntity];
    game.releaseDate = [NSDate date];
    NSString *expectedVal = @"Shipped";
    STAssertTrue([[game watchSection] isEqualToString:expectedVal], @"Expected game that releases today to be shipped.");
}

- (void)testSectionIdentifierWithDate
{
    Game *game = [Game MR_createEntity];
    
    NSString *str = @"3/15/2012 9:15 PM";
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM/dd/yyyy HH:mm a"];
    NSDate *date = [formatter dateFromString:str];
    
    game.releaseDate = date;
    
    NSString *expectedVal = @"2012003";
    STAssertTrue([[game sectionIdentifier] isEqualToString:expectedVal], @"Expected game with 3/15/2012 release date to have 2012003 section identifier");
}

- (void)testPlatformsStringWithOnePlatform
{
    Game *game = [Game MR_createEntity];
    Platform *platform = [Platform MR_createEntity];
    
    platform.title = @"Wii";
    
    [game addPlatformsObject:platform];
    
    NSString *expectedVal = @"Wii";
    
    STAssertTrue([[game platformsString] isEqualToString:expectedVal], @"Expected game with 1 Platform titled 'Wii' to have a correct platformsString");
}

- (void)testPlatformsStringWithTwoPlatforms
{
    Game *game = [Game MR_createEntity];
    Platform *platform1 = [Platform MR_createEntity];
    Platform *platform2 = [Platform MR_createEntity];
    
    platform1.title = @"Wii";
    platform2.title = @"PS3";
    
    NSArray *platforms = @[ platform1, platform2 ];
    
    [game addPlatforms:[NSSet setWithArray:platforms]];
    
    NSString *expectedVal = @"Wii, PS3";
    NSString *expectedVal2 = @"PS3, Wii";
    
    STAssertTrue(([[game platformsString] isEqualToString:expectedVal] || [[game platformsString] isEqualToString:expectedVal2]), @"Expected game with 2 Platforms to have the correct platformString");
}

@end
