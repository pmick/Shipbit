#import "Game.h"
#import "Platform.h"


@interface Game ()

// Private interface goes here.

@end


@implementation Game


- (NSString *)sectionIdentifier {
    
    // Create and cache the section identifier on demand.
    
    [self willAccessValueForKey:@"sectionIdentifier"];
    NSString *tmp = [self primitiveSectionIdentifier];
    [self didAccessValueForKey:@"sectionIdentifier"];
        
    // No calculations if the sectionIdentifier was cached on demand.
    if (!tmp) {
        /*
         Sections are organized by month and year. Create the section identifier as a string representing the number (year * 1000) + month; this way they will be correctly ordered chronologically regardless of the actual name of the month.
         */
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekCalendarUnit) fromDate:[self releaseDate]];
        NSDateComponents *modificationComponents = [[NSDateComponents alloc] init];
        [modificationComponents setWeek:1];
        // Calculate end of current week

        // End of current week + 1 week
        
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

- (NSString *)platformsString {
    NSMutableString *platformsString = [[NSMutableString alloc] init];
    int count = 0;
    for (Platform *platform in self.platforms) {
        count++;
        if ((unsigned)count >= [self.platforms count]) {
            [platformsString appendString:platform.title];
        } else {
            NSString *platformWithComma = [NSString stringWithFormat:@"%@, ", platform.title];
            [platformsString appendString:platformWithComma];
        }
    }
    
    return platformsString;
}

@end
