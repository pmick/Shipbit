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
#import "SBAFParseAPIClient.h"
#import "SBGameDetailViewController.h"
#import "UIColor+Extras.h"
#import "NSDate+Utilities.h"

@implementation SBGameDetailHeaderView {
    BOOL _pressed;
}

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
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 12, 88, 88)]; // 131, 175
    [_imageView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:_imageView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(112, 10, 230, 60)];
    //[_titleLabel setBackgroundColor:[UIColor greenColor]];
    [_titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18]];
    [_titleLabel setTextColor:[UIColor colorWithHexValue:@"3e434d"]];
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
    
    _platformsLabel = [[UILabel alloc] initWithFrame:CGRectMake(112, 116, 160, 40)];
    //[_platformsLabel setBackgroundColor:[UIColor greenColor]];
    [_platformsLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:11]];
    [_platformsLabel setTextColor:[UIColor colorWithRed:(141.0f/255.0f) green:(136.0f/255.0f) blue:(133.0f/255.0f) alpha:1]];
    [_platformsLabel setNumberOfLines:2];
    [self addSubview:_platformsLabel];
    
    _likeButton = [[UIButton alloc] initWithFrame:CGRectMake(112, 158, 58, 29)];
    [_likeButton setShowsTouchWhenHighlighted:YES];
    [_likeButton setBackgroundImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
    [_likeButton addTarget:self action:@selector(likeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_likeButton sizeToFit];
    [self addSubview:_likeButton];
    
    _watchlistButton = [[UIButton alloc] initWithFrame:CGRectMake(214, 158, 89, 29)];
    [_watchlistButton setShowsTouchWhenHighlighted:YES];
    [_watchlistButton setBackgroundImage:[UIImage imageNamed:@"watch"] forState:UIControlStateNormal];
    [_watchlistButton addTarget:self action:@selector(watchlistButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_watchlistButton sizeToFit];
    [self addSubview:_watchlistButton];
    
    UIImageView *borderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(7.0, 7.0, 96.0, 96.0)];
    borderImageView.image = [UIImage imageNamed:@"circle_border_light"];
    borderImageView.highlightedImage = [UIImage imageNamed:@"highlight_circle"];
    [self addSubview:borderImageView];
}

// TODO: View controller should take care of all this crap.
- (void)likeButtonPressed:(id)sender {
    if (!_pressed) {
        _pressed = YES;
        if (_game.hasLiked) {
            [[SBSyncEngine sharedEngine] decrementLikesByOneForObjectWithId:_game.objectId completionBlock:^(bool success) {
                if (success) {
                    _game.likes = @(_game.likes.integerValue - 1);
                    
                    _game.hasLiked = NO;
                    // Update coredata
                    NSError *error;
                    if (![[[SBCoreDataController sharedInstance] masterManagedObjectContext] save:&error]) {
                        // Handle the error.
                        DDLogError(@"Saving changes failed: %@", error);
                    }
                    
                    [_likeButton setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
                    
                    // Update likes label
                    [((SBGameDetailViewController *)[self viewController]) populateWithDataFromGame:_game];
                } else {
                    DDLogInfo(@"Could not dislike");
                    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Network Problem"
                                                                      message:@"You need an internet connection to be able to unlike a game."
                                                                     delegate:nil
                                                            cancelButtonTitle:@"OK"
                                                            otherButtonTitles:nil];
                    [message show];
                }
                _pressed = NO;
            }];
            
            
        } else {
            // Increment likes on server
            [[SBSyncEngine sharedEngine] incrementLikesByOneForObjectWithId:_game.objectId completionBlock:^(bool success) {
                if (success) {
                    DDLogInfo(@"Like count will update.");
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
                    
                    // Update likes label
                    [((SBGameDetailViewController *)[self viewController]) populateWithDataFromGame:_game];
                } else {
                    DDLogInfo(@"Could not like");
                    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Network Problem"
                                                                      message:@"You need an internet connection to be able to like a game."
                                                                     delegate:nil
                                                            cancelButtonTitle:@"OK"
                                                            otherButtonTitles:nil];
                    [message show];
                }
                _pressed = NO;
            }];
            
            
        }
    }
    // Update likes label
    [((SBGameDetailViewController *)[self viewController]) populateWithDataFromGame:_game];
    
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
        if ([_game.releaseDate isInFuture]) {
            UILocalNotification* notifyAlarm = [[UILocalNotification alloc] init];
            notifyAlarm.fireDate = [_game.releaseDate dateByAddingTimeInterval:-(3600*9)];
            notifyAlarm.timeZone = [NSTimeZone systemTimeZone];
            notifyAlarm.repeatInterval = 0;
            notifyAlarm.alertBody = [NSString stringWithFormat:@"%@ is released tomorrow!", _game.title];
            NSDictionary *userInfo = @{@"uid": [NSString stringWithFormat:@"%@", _game.objectId]};
            notifyAlarm.userInfo = userInfo;
            [[UIApplication sharedApplication] scheduleLocalNotification:notifyAlarm];
            
            DDLogInfo(@"Created a local notification for %@ at %@", _game.title, [_game.releaseDate dateByAddingTimeInterval:-(3600*9)]);
        }
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

- (UIViewController*)viewController
{
    for (UIView* next = [self superview]; next; next = next.superview)
    {
        UIResponder* nextResponder = [next nextResponder];
        
        if ([nextResponder isKindOfClass:[UIViewController class]])
        {
            return (UIViewController*)nextResponder;
        }
    }
    
    return nil;
}

- (void)resizeSubviews {
    [_titleLabel setFrame:CGRectMake(112, 10, 200, 60)];
    [_titleLabel sizeToFit];
    
    [_releaseDateImageView setFrame:CGRectMake(112.0, _titleLabel.frame.origin.y + _titleLabel.frame.size.height + 4, 20, 20)];
    [_releaseDateImageView sizeToFit];
    [_releaseDateLabel setFrame:CGRectMake(129.0, _titleLabel.frame.origin.y + _titleLabel.frame.size.height + 1, 139.0, 20.0)];
}

@end
