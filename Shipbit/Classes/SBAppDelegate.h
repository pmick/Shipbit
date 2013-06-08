//
//  SBAppDelegate.h
//  Shipbit
//
//  Created by Patrick Mick on 1/19/13.
//  Copyright (c) 2013 PatrickMick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JASidePanelController.h"

@interface SBAppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) JASidePanelController *viewController;

@end
