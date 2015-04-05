//
//  SBGameTableViewCell+ConfigureForGame.m
//  Shipbit
//
//  Created by Patrick Mick on 4/5/15.
//  Copyright (c) 2015 PatrickMick. All rights reserved.
//

#import "SBGameTableViewCell+ConfigureForGame.h"
#import "Game.h"
#import "UIImage+Extras.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation SBGameTableViewCell (ConfigureForGame)

- (void)configureForGame:(Game *)game {
    self.titleLabel.text = game.title;
    self.platformsLabel.text = game.platformsString;
    
    __weak typeof(self)weakSelf = self;
    [self.thumbnailImageView
     sd_setImageWithURL:[NSURL URLWithString:game.art]
     placeholderImage:nil
     options:SDWebImageRetryFailed
     completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
         __strong __typeof(weakSelf)strongSelf = weakSelf;
         if (strongSelf) {
             if (cacheType != SDImageCacheTypeNone) {
                 strongSelf.thumbnailImageView.image = [[image imageByScalingAndCroppingForSize:strongSelf.thumbnailImageView.frame.size] circleImage];
                 
             } else {
                 strongSelf.thumbnailImageView.image = [[UIImage imageNamed:@"placeholder"] circleImage];
                 [UIView
                  transitionWithView:strongSelf.thumbnailImageView
                  duration:0.2
                  options:UIViewAnimationOptionTransitionCrossDissolve
                  animations:^{
                      strongSelf.thumbnailImageView.image = [[image imageByScalingAndCroppingForSize:weakSelf.thumbnailImageView.frame.size] circleImage];
                  }
                  completion:nil];
             }
         }
     }];
}

@end
