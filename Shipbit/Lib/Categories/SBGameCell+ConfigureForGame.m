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
    
    SBGameCell *wCell = self;
    
    [self.thumbnailView sd_setImageWithURL:[NSURL URLWithString:game.art]
                       placeholderImage:[[UIImage imageNamed:@"placeholder"] circleImage]
                                options:SDWebImageRetryFailed
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                    if (cacheType != SDImageCacheTypeNone) {
                                        wCell.thumbnailView.image = [[image imageByScalingAndCroppingForSize:wCell.thumbnailView.frame.size] circleImage];
                                        
                                    } else {
                                        wCell.thumbnailView.image = [[UIImage imageNamed:@"placeholder"] circleImage];
                                        [UIView transitionWithView:wCell.thumbnailView
                                                          duration:0.3
                                                           options:UIViewAnimationOptionTransitionCrossDissolve
                                                        animations:^{
                                                            wCell.thumbnailView.image = [[image imageByScalingAndCroppingForSize:wCell.thumbnailView.frame.size] circleImage];
                                                        }
                                                        completion:nil];
                                    }
    }];
    
    [self resizeSubviews];
}

@end
