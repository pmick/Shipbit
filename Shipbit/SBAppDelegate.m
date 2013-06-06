//
//  SBAppDelegate.m
//  Shipbit
//
//  Created by Patrick Mick on 1/19/13.
//  Copyright (c) 2013 PatrickMick. All rights reserved.
//

#import "SBAppDelegate.h"
#import "SBUpcomingViewController.h"
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
#import "AFNetworkActivityIndicatorManager.h"

@interface SBAppDelegate ()

@end

@implementation SBAppDelegate

- (void)customizeAppearance {
    // Navbar background
    UIImage *navbarBackgroundImage = [UIImage imageNamed:@"navbar-background"];
    [[UINavigationBar appearance] setBackgroundImage:navbarBackgroundImage
                                       forBarMetrics:UIBarMetricsDefault];
    
    UIBarButtonItem *searchBarButton = [UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil];
    [searchBarButton setBackgroundImage:[UIImage imageNamed:@"searchCancelButton"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [searchBarButton setBackgroundImage:[UIImage imageNamed:@"searchCancelButtonPressed"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    [searchBarButton setBackgroundImage:[UIImage imageNamed:@"searchCancelButtonPressed"] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    
    //[searchBarButton setImage:[UIImage imageNamed:@"cancelButton"]];
    //[searchBarButton setBackgroundImage:[UIImage imageNamed:@"cancelButton"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    //[searchBarButton setTitleTextAttributes:barButtonTitleTextAttributesNormal forState:UIControlStateNormal];
    //[searchBarButton setTitleTextAttributes:barButtonTitleTextAttributesHighlighted forState:UIControlStateHighlighted];
    
    UIBarButtonItem *sharingButton = [UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil];
    [sharingButton setBackgroundImage:[UIImage imageNamed:@"navButtonBack"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [sharingButton setBackgroundImage:[UIImage imageNamed:@"navButtonBackSelected"] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    [sharingButton setBackgroundImage:[UIImage imageNamed:@"navButtonBackSelected"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    [sharingButton setBackgroundImage:[UIImage imageNamed:@"doneButtonBackgroundImage"] forState:UIControlStateNormal style:UIBarButtonItemStyleDone barMetrics:UIBarMetricsDefault];
    [sharingButton setBackgroundImage:[UIImage imageNamed:@"doneButtonBackgroundImagePressed"] forState:UIControlStateSelected style:UIBarButtonItemStyleDone barMetrics:UIBarMetricsDefault];
    [sharingButton setBackgroundImage:[UIImage imageNamed:@"doneButtonBackgroundImagePressed"] forState:UIControlStateHighlighted style:UIBarButtonItemStyleDone barMetrics:UIBarMetricsDefault];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    [TestFlight takeOff:@"8a468878-2f6f-4b89-91d4-dfb85475e88b"];
    
    DDTTYLogger *xcodeConsoleLogger = [DDTTYLogger sharedInstance];
    XCodeConsoleLogFormatter *logFormatter = [[XCodeConsoleLogFormatter alloc] init];
    [xcodeConsoleLogger setLogFormatter:logFormatter];
    [DDLog addLogger:xcodeConsoleLogger];
    
    [[SBSyncEngine sharedEngine] registerNSManagedObjectClassToSync:[Platform class]];
    [[SBSyncEngine sharedEngine] registerNSManagedObjectClassToSync:[Game class]];
    
    [self customizeAppearance];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];
    
    SBLeftSideNavViewController *lsnvc = [[SBLeftSideNavViewController alloc] init];
    
    // Create all of the view controllers for the sidenav.
    SBUpcomingViewController *utvc = [[SBUpcomingViewController alloc] init];
    SBReleasedViewController *rtvc = [[SBReleasedViewController alloc] init];
    SBSearchTableViewController *stvc = [[SBSearchTableViewController alloc] init];
    SBFavoritesTableViewController *ftvc = [[SBFavoritesTableViewController alloc] init];
    
    // Create new platforms view controller.
    SBPlatformsTableViewController *ptvc = [[SBPlatformsTableViewController alloc] init];
    
    // Assign new platforms view controller to both views that use it.
    [utvc setPtvc:ptvc];
    [rtvc setPtvc:ptvc];
    
    // Create a navigation controller for each view controller listed in the sidenav.
    UINavigationController *upcomingNav = [[UINavigationController alloc] initWithRootViewController:utvc];
    UINavigationController *releasedNav = [[UINavigationController alloc] initWithRootViewController:rtvc];
    UINavigationController *searchNav = [[UINavigationController alloc] initWithRootViewController:stvc];
    UINavigationController *favoritesNav = [[UINavigationController alloc] initWithRootViewController:ftvc];
    
    //[upcomingNav.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar-background"] forBarMetrics:UIBarMetricsDefault];
    
    // Set side nav views to the newly created views
    lsnvc.utvc = upcomingNav;
    lsnvc.rtvc = releasedNav;
    lsnvc.stvc = searchNav;
    lsnvc.ftvc = favoritesNav;
        
    self.viewController = [[JASidePanelController alloc] init];
    self.viewController.leftPanel = lsnvc;
    self.viewController.centerPanel = upcomingNav;
    
    // Disable swiping so you can delete games from favorites with a right to left swipe
    self.viewController.allowLeftSwipe = NO;
    
    self.window.rootViewController = _viewController;
    
    [[UINavigationBar appearance]setShadowImage:[[UIImage alloc] init]];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [[SBCoreDataController sharedInstance] saveMasterContext];
    [[SBCoreDataController sharedInstance] saveBackgroundContext];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[SBCoreDataController sharedInstance] saveMasterContext];
    [[SBCoreDataController sharedInstance] saveBackgroundContext];
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
    [[SBCoreDataController sharedInstance] saveMasterContext];
    [[SBCoreDataController sharedInstance] saveBackgroundContext];
}

@end
