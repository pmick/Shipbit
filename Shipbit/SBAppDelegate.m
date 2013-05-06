//
//  SBAppDelegate.m
//  Shipbit
//
//  Created by Patrick Mick on 1/19/13.
//  Copyright (c) 2013 PatrickMick. All rights reserved.
//

#import "SBAppDelegate.h"
#import "SBGameTableViewController.h"
#import "SBReleasedViewController.h"
#import "SBSearchTableViewController.h"
#import "SBFavoritesTableViewController.h"
#import "SBSyncEngine.h"
#import "SBCoreDataController.h"
#import "Platform.h"
#import "Game.h"
#import "SBLeftSideNavViewController.h"
#import "DDASLLogger.h"
#import "DDTTYLogger.h"
#import "DDFileLogger.h"
#import "XCodeConsoleLogFormatter.h"

@implementation SBAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    DDTTYLogger *xcodeConsoleLogger = [DDTTYLogger sharedInstance];
    XCodeConsoleLogFormatter *logFormatter = [[XCodeConsoleLogFormatter alloc] init];
    [xcodeConsoleLogger setLogFormatter:logFormatter];
    [DDLog addLogger:xcodeConsoleLogger];
    
    [[SBSyncEngine sharedEngine] registerNSManagedObjectClassToSync:[Platform class]];
    [[SBSyncEngine sharedEngine] registerNSManagedObjectClassToSync:[Game class]];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];
    
    SBLeftSideNavViewController *lsnvc = [[SBLeftSideNavViewController alloc] init];
    
    SBGameTableViewController *gtvc = [[SBGameTableViewController alloc] init];
    SBReleasedViewController *rtvc = [[SBReleasedViewController alloc] init];
    SBSearchTableViewController *stvc = [[SBSearchTableViewController alloc] init];
    SBFavoritesTableViewController *ftvc = [[SBFavoritesTableViewController alloc] init];

    gtvc.entityName = @"Game";

    UINavigationController *gameNav = [[UINavigationController alloc] initWithRootViewController:gtvc];
    UINavigationController *releasedNav = [[UINavigationController alloc] initWithRootViewController:rtvc];
    UINavigationController *searchNav = [[UINavigationController alloc] initWithRootViewController:stvc];
    UINavigationController *favoritesNav = [[UINavigationController alloc] initWithRootViewController:ftvc];
    
    lsnvc.gtvc = gameNav;
    lsnvc.rtvc = releasedNav;
    lsnvc.stvc = searchNav;
    lsnvc.ftvc = favoritesNav;
    
    
    self.viewController = [[JASidePanelController alloc] init];
    self.viewController.leftPanel = lsnvc;
    self.viewController.centerPanel = gameNav;
    
    self.window.rootViewController = _viewController;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[SBSyncEngine sharedEngine] startSync];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
