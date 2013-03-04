//
//  Game.m
//  Shipbit
//
//  Created by Patrick Mick on 1/31/13.
//  Copyright (c) 2013 PatrickMick. All rights reserved.
//

#import "Game.h"


@implementation Game

@dynamic art;
@dynamic createdAt;
@dynamic criticScore;
@dynamic developer;
@dynamic esrb;
@dynamic genre;
@dynamic link;
@dynamic objectId;
@dynamic platforms;
@dynamic publisher;
@dynamic releaseDate;
@dynamic primitiveReleaseDate;
@dynamic summary;
@dynamic title;
@dynamic updatedAt;
@dynamic sectionIdentifier;
@dynamic primitiveSectionIdentifier;

- (NSString *)sectionIdentifier {
    
    // Create and cache the section identifier on demand.
    
    [self willAccessValueForKey:@"sectionIdentifier"];
    NSString *tmp = [self primitiveSectionIdentifier];
    [self didAccessValueForKey:@"sectionIdentifier"];
    
    if (!tmp) {
        /*
         Sections are organized by month and year. Create the section identifier as a string representing the number (year * 1000) + month; this way they will be correctly ordered chronologically regardless of the actual name of the month.
         */
        NSCalendar *calendar = [NSCalendar currentCalendar];
        
        NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit) fromDate:[self releaseDate]];
        tmp = [NSString stringWithFormat:@"%d", ([components year] * 1000) + [components month]];
        [self setPrimitiveSectionIdentifier:tmp];
    }
    return tmp;
}

- (void)setReleaseDate:(NSDate *)newDate {
    
    // If the time stamp changes, the section identifier become invalid.
    [self willChangeValueForKey:@"releaseDate"];
    [self setPrimitiveReleaseDate:newDate];
    [self didChangeValueForKey:@"releaseDate"];
    
    [self setPrimitiveSectionIdentifier:nil];
}



@end
