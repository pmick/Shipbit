//
//  SBSyncEngine.h
//  Shipbit
//
//  Created by Patrick Mick on 1/9/13.
//  Copyright (c) 2013 PatrickMick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SBSyncEngine : NSObject

@property (atomic, readonly) BOOL syncInProgress;

+ (SBSyncEngine *)sharedEngine;

- (void)registerNSManagedObjectClassToSync:(Class)aClass;
- (void)startSync;
- (void)incrementLikesByOneForObjectWithId:(NSString *)objectId;

typedef enum {
    SBObjectSynced = 0,
    SBObjectCreated,
    SBObjectDeleted,
} SBOBjectSyncStatus;

@end
