//
//  SBGameCell+ConfigureForGame.m
//  Shipbit
//
//  Created by Patrick Mick on 6/8/13.
//  Copyright (c) 2013 PatrickMick. All rights reserved.
//

#import "SBGameCell+ConfigureForGame.h"
#import "NSDate+Utilities.h"
#import "UIImage+Extras.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation SBGameCell (ConfigureForGame)

- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter = nil;
    
    if (!dateFormatter) {
        DDLogInfo(@"Creating 1 date formatter to configure cells");

        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        [dateFormatter setDateFormat:@"MMM dd"];
    }
    
    return dateFormatter;
}

- (void)configureForGame:(Game *)game
{
    self.titleLabel.text = game.title;
    
    if ([game.releaseDate isToday]) {
        self.releaseDateImage.image = [UIImage imageNamed:@"stopwatchImage"];
        self.releaseDateImage.highlightedImage = [UIImage imageNamed:@"stopwatchImageWhite"];
        self.releaseDateLabel.text = [NSString stringWithFormat:@"%@:",[self.dateFormatter stringFromDate:game.releaseDate]];
        self.urgentLabel.text = @"Out Today";
        
    } else if ([game.releaseDate isTomorrow]) {
        self.releaseDateImage.image = [UIImage imageNamed:@"stopwatchImage"];
        self.releaseDateImage.highlightedImage = [UIImage imageNamed:@"stopwatchImageWhite"];
        self.releaseDateLabel.text = [NSString stringWithFormat:@"%@:",[self.dateFormatter stringFromDate:game.releaseDate]];
        self.urgentLabel.text = @"Out Tomorrow";
        
    } else if ([game.releaseDate isThisWeek]) {
        self.releaseDateImage.image = [UIImage imageNamed:@"calendarIcon"];
        self.releaseDateImage.highlightedImage = [UIImage imageNamed:@"calendarIcon_highlight"];
        self.releaseDateLabel.text = [NSString stringWithFormat:@"%@:",[self.dateFormatter stringFromDate:game.releaseDate]];
        self.urgentLabel.text = @"Out This Week";
        
    } else {
        self.releaseDateImage.image = [UIImage imageNamed:@"calendarIcon"];
        self.releaseDateImage.highlightedImage = [UIImage imageNamed:@"calendarIcon_highlight"];
        self.releaseDateLabel.text = [self.dateFormatter stringFromDate:game.releaseDate];
        self.urgentLabel.text = @"";
        
    }
    
    self.platformsLabel.text = game.platformsString;
    self.thumbnailView.image = [[UIImage imageNamed:@"placeholder"] circleImage];
    
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];    
    [manager downloadWithURL:[NSURL URLWithString:game.art]
                     options:0
                    progress:nil
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                       if (image) {
                           self.thumbnailView.image = [[image imageByScalingAndCroppingForSize:self.thumbnailView.frame.size] circleImage];
                       } else {
                           self.thumbnailView.image = [[UIImage imageNamed:@"placeholder"] circleImage];
                       }
                   }];
    
    [self resizeSubviews];
}

@end
