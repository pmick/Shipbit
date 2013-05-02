//
//  SBLeftSideNavViewController.h
//  Shipbit
//
//  Created by Patrick Mick on 4/28/13.
//  Copyright (c) 2013 PatrickMick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBGameTableViewController.h"
#import "SBSearchTableViewController.h"
#import "SBFavoritesTableViewController.h"


@interface SBLeftSideNavViewController : UITableViewController

@property (nonatomic, strong) NSArray *views;
@property (nonatomic, strong) UINavigationController *gtvc;
@property (nonatomic, strong) UINavigationController *stvc;
@property (nonatomic, strong) UINavigationController *ftvc;

@end
