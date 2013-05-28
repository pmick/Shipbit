//
//  SBGameDetailHeaderView.m
//  Shipbit
//
//  Created by Patrick Mick on 5/19/13.
//  Copyright (c) 2013 PatrickMick. All rights reserved.
//

#import "SBGameDetailHeaderView.h"
#import "SBSyncEngine.h"
#import "SBCoreDataController.h"
#import "SBGameDetailViewController.h"

@implementation SBGameDetailHeaderView

#pragma mark - View Lifecycle

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setFrame:CGRectMake(0, 0, 320, 200)];
        [self setupSubviews];
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

- (void)setupSubviews {
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 12, 131, 175)]; // 131, 175
    [_imageView setBackgroundColor:[UIColor lightGrayColor]];
    [self addSubview:_imageView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(152, 10, 160, 60)];
    //[_titleLabel setBackgroundColor:[UIColor greenColor]];
    [_titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16]];
    [_titleLabel setTextColor:[UIColor colorWithRed:(81.0f/255.0f) green:(77.0f/255.0f) blue:(74.0f/255.0f) alpha:1]];
    [_titleLabel setNumberOfLines:3];
    [self addSubview:_titleLabel];
    
    _releaseDateImageView = [[UIImageView alloc] init];
    [_releaseDateImageView setImage:[UIImage imageNamed:@"calendarIcon"]];
    [_releaseDateImageView sizeToFit];
    [self addSubview:_releaseDateImageView];
    
    _releaseDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(172.0, _titleLabel.frame.origin.y + _titleLabel.frame.size.height + 3, 139.0, 20.0)];
    //[_releaseDateLabel setBackgroundColor:[UIColor greenColor]];
    [_releaseDateLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:13]];
    [_releaseDateLabel setTextColor:[UIColor colorWithRed:(141.0f/255.0f) green:(136.0f/255.0f) blue:(133.0f/255.0f) alpha:1]];
    [self addSubview:_releaseDateLabel];
    
    _platformsLabel = [[UILabel alloc] initWithFrame:CGRectMake(152, 116, 160, 40)];
    //[_platformsLabel setBackgroundColor:[UIColor greenColor]];
    [_platformsLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:11]];
    [_platformsLabel setTextColor:[UIColor colorWithRed:(141.0f/255.0f) green:(136.0f/255.0f) blue:(133.0f/255.0f) alpha:1]];
    [_platformsLabel setText:@"Platforms, platforms, platforms"];
    [_platformsLabel setNumberOfLines:2];
    [self addSubview:_platformsLabel];
    
    _likeButton = [[UIButton alloc] initWithFrame:CGRectMake(152, 158, 58, 29)];
    [_likeButton setShowsTouchWhenHighlighted:YES];
    [_likeButton setBackgroundImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
    [_likeButton addTarget:self action:@selector(likeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_likeButton];
    
    _watchlistButton = [[UIButton alloc] initWithFrame:CGRectMake(219, 158, 89, 29)];
    [_watchlistButton setShowsTouchWhenHighlighted:YES];
    [_watchlistButton setBackgroundImage:[UIImage imageNamed:@"watch"] forState:UIControlStateNormal];
    [_watchlistButton addTarget:self action:@selector(watchlistButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_watchlistButton];
}

- (void)likeButtonPressed:(id)sender {
    // TODO: keep from liking when you are not connected
    
    if (_game.hasLiked) {
        [[SBSyncEngine sharedEngine] decrementLikesByOneForObjectWithId:_game.objectId];
        
        [_likeButton setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
        _game.hasLiked = NO;
        // Update coredata
        NSError *error;
        if (![[[SBCoreDataController sharedInstance] masterManagedObjectContext] save:&error]) {
            // Handle the error.
            DDLogError(@"Saving changes failed: %@", error);
        }
        
    } else {
        // Increment likes on server
        DDLogInfo(@"Like count will update.");
        [[SBSyncEngine sharedEngine] incrementLikesByOneForObjectWithId:_game.objectId];
        
        // Increment likes locally
        _game.likes = @(_game.likes.integerValue + 1);
        
        // Update label to reflect increment on likes
        
        // Set game as liked
        _game.hasLiked = @YES;
        
        // Update coredata
        NSError *error;
        if (![[[SBCoreDataController sharedInstance] masterManagedObjectContext] save:&error]) {
            // Handle the error.
            DDLogError(@"Saving changes failed: %@", error);
        }
        
        [_likeButton setImage:[UIImage imageNamed:@"liked"] forState:UIControlStateNormal];
    }
    
}

- (void)watchlistButtonPressed:(id)sender {
    if (_game.isFavorite) {
        // Set isFavorite to NO
        _game.isFavorite = NO;
        [_watchlistButton setImage:[UIImage imageNamed:@"watch"] forState:UIControlStateNormal];
        
        // Remove local notification
        UIApplication *app = [UIApplication sharedApplication];
        NSArray *eventArray = [app scheduledLocalNotifications];
        for (int i=0; i<(int)[eventArray count]; i++)
        {
            UILocalNotification* oneEvent = [eventArray objectAtIndex:i];
            NSDictionary *userInfoCurrent = oneEvent.userInfo;
            NSString *uid=[NSString stringWithFormat:@"%@",[userInfoCurrent valueForKey:@"uid"]];
            if ([uid isEqualToString:_game.objectId])
            {
                //Cancelling local notification
                [app cancelLocalNotification:oneEvent];
                DDLogInfo(@"Deleting notification for event: %@", oneEvent.alertBody);
                break;
            }
        }
        
    } else {
        DDLogVerbose(@"Adding favorite for game with id: %@", _game.objectId);
        
        // Update local coredata store
        _game.isFavorite = @YES;
        [_watchlistButton setImage:[UIImage imageNamed:@"watched"] forState:UIControlStateNormal];
        
        // Create a local notification
        UILocalNotification* notifyAlarm = [[UILocalNotification alloc] init];
        if (notifyAlarm) {
            notifyAlarm.fireDate = [_game.releaseDate dateByAddingTimeInterval:-(3600*9)];
            notifyAlarm.timeZone = [NSTimeZone defaultTimeZone];
            notifyAlarm.repeatInterval = 0;
            notifyAlarm.alertBody = [NSString stringWithFormat:@"%@ is released tomorrow!", _game.title];
            NSDictionary *userInfo = @{@"uid": [NSString stringWithFormat:@"%@", _game.objectId]};
            notifyAlarm.userInfo = userInfo;
            [[UIApplication sharedApplication] scheduleLocalNotification:notifyAlarm];
        }
        
        DDLogInfo(@"Created a local notification for %@ at %@", _game.title, [_game.releaseDate dateByAddingTimeInterval:-(3600*9)]);
        
    }
    
    // Save data store
    NSError *error;
    if (![[[SBCoreDataController sharedInstance] masterManagedObjectContext] save:&error]) {
        // Handle the error.
        DDLogError(@"Saving changes failed: %@", error);
    }
    
    //NSString *favoriteButtonText = game.isFavorite ? NSLocalizedString(@"Unwatch", nil) : NSLocalizedString(@"Add to Watchlist", nil);
    // Update button appearance
    //[self.favoriteButton setTitle:favoriteButtonText forState:UIControlStateNormal];
}

- (void)resizeSubviews {
    [_titleLabel setFrame:CGRectMake(152, 10, 160, 60)];
    [_titleLabel sizeToFit];
    
    [_releaseDateImageView setFrame:CGRectMake(152.0, _titleLabel.frame.origin.y + _titleLabel.frame.size.height + 4, 20, 20)];
    [_releaseDateImageView sizeToFit];
    [_releaseDateLabel setFrame:CGRectMake(169.0, _titleLabel.frame.origin.y + _titleLabel.frame.size.height + 1, 139.0, 20.0)];
}

@end
