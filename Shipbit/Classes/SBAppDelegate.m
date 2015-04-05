//
//  SBAppDelegate.m
//  Shipbit
//
//  Created by Patrick Mick on 1/19/13.
//  Copyright (c) 2013 PatrickMick. All rights reserved.
//

#import "SBAppDelegate.h"
#import "SBSyncEngine.h"
#import "SBCoreDataController.h"
#import "Platform.h"
#import "Game.h"
#import "DDTTYLogger.h"
#import "XCodeConsoleLogFormatter.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "Flurry.h"

@interface SBAppDelegate ()

@end

@implementation SBAppDelegate

#pragma mark - Application Lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [Flurry startSession:@"YRHYBXSV727TWSBDZGQM"];
    [self _setupLogging];
    [self _setupSyncEngine];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [self _saveCoreData];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self _saveCoreData];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[SBSyncEngine sharedEngine] startSync];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [self _saveCoreData];
}

#pragma mark - Custom

- (void)_saveCoreData {
    [[SBCoreDataController sharedInstance] saveMasterContext];
    [[SBCoreDataController sharedInstance] saveBackgroundContext];
}

- (void)_setupLogging {
    DDTTYLogger *xcodeConsoleLogger = [DDTTYLogger sharedInstance];
    XCodeConsoleLogFormatter *logFormatter = [[XCodeConsoleLogFormatter alloc] init];
    [xcodeConsoleLogger setLogFormatter:logFormatter];
    [DDLog addLogger:xcodeConsoleLogger];
}

- (void)_setupSyncEngine {
    [[SBSyncEngine sharedEngine] registerNSManagedObjectClassToSync:[Platform class]];
    [[SBSyncEngine sharedEngine] registerNSManagedObjectClassToSync:[Game class]];
}

@end
