//
//  SBSyncEngine.m
//  Shipbit
//
//  Created by Patrick Mick on 1/9/13.
//  Copyright (c) 2013 PatrickMick. All rights reserved.
//

#import "SBSyncEngine.h"
#import "SBCoreDataController.h"
#import "SBAFParseAPIClient.h"
#import "Platform.h"
#import "Game.h"
#import "AFJSONRequestOperation.h"

#import <CoreData/CoreData.h>

@interface SBSyncEngine ()

@property (nonatomic, strong) NSMutableArray *registeredClassesToSync;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation SBSyncEngine

NSString * const kSDSyncEngineInitialCompleteKey = @"SBSyncEngineInitialSyncCompleted";
NSString * const kSDSyncEngineSyncCompletedNotificationName = @"SBSyncEngineSyncCompleted";

#pragma mark - Engine Creation and Object Registration

+ (SBSyncEngine *)sharedEngine {
    static SBSyncEngine *sharedEngine = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedEngine = [[SBSyncEngine alloc] init];
    });
    
    return sharedEngine;
}

- (void)registerNSManagedObjectClassToSync:(Class)aClass {
    if (!self.registeredClassesToSync) {
        self.registeredClassesToSync = [NSMutableArray array];
    }
    
    if ([aClass isSubclassOfClass:[NSManagedObject class]]) {
        if (![self.registeredClassesToSync containsObject:NSStringFromClass(aClass)]) {
            [self.registeredClassesToSync addObject:NSStringFromClass(aClass)];
        } else {
            DDLogError(@"Unable to register %@ as it is already registered", NSStringFromClass(aClass));
        }
    } else {
        DDLogError(@"Unable to register %@ as it is not a subclass of NSManageObject", NSStringFromClass(aClass));
    }
}

#pragma mark - Sync Execution

- (NSDate *)mostRecentUpdatedAtDateForEntityWithName:(NSString *)entityName {
    __block NSDate *date = nil;
    
    //Create a new fetch request for the specified entity
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    
    //Set the sort descriptors on the request to sort by updatedAt in descending order
    [request setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"updatedAt" ascending:NO]]];
    
    //Only interested in 1 result so limited to 1
    [request setFetchLimit:1];
    [[[SBCoreDataController sharedInstance] backgroundManagedObjectContext] performBlockAndWait:^{
        NSError *error = nil;
        NSArray *results = [[[SBCoreDataController sharedInstance] backgroundManagedObjectContext] executeFetchRequest:request error:&error];
        if ([results lastObject]) {
            //Set date to the fetched result
            date = [[results lastObject] valueForKey:@"updatedAt"];
        }
    }];
    
    return date;
}

- (void)downloadDataForRegisteredObjects:(BOOL)useUpdatedAtDate toDeleteLocalRecords:(BOOL)toDelete {
    NSMutableArray *requestOperations = [NSMutableArray array];
    
    for (NSString *className in self.registeredClassesToSync) {
        NSDate *mostRecentUpdatedDate = nil;
        if (useUpdatedAtDate) {
            mostRecentUpdatedDate = [self mostRecentUpdatedAtDateForEntityWithName:className];
        }
        NSMutableURLRequest * request = [[SBAFParseAPIClient sharedClient] GETRequestForAllRecordsOfClass:className updateAfterDate:mostRecentUpdatedDate];
        
        AFHTTPRequestOperation *requestOperation = [[SBAFParseAPIClient sharedClient] HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                [self writeJSONReponse:responseObject toDiskForClassWithName:className];
                //NSLog(@"JSON RESPONSE: %@", responseObject);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            DDLogError(@"Request for class %@ failed with error: %@", className, error);
        }];
        
        [requestOperations addObject:requestOperation];
    }
        
    [[SBAFParseAPIClient sharedClient] enqueueBatchOfHTTPRequestOperations:requestOperations progressBlock:^(NSUInteger numberOfCompletedOperations, NSUInteger totalNumberOfOperations) {
        
    } completionBlock:^(NSArray *operations) {
        if (!toDelete) {
            [self processJSONDataRecordsIntoCoreData];
        } else {
            [self processJSONDataRecordsForDeletion];
        }
    }];
}

- (void)startSync {
    if (!self.syncInProgress) {
        DDLogInfo(@"Sync started...");
        [self willChangeValueForKey:@"syncInProgress"];
        _syncInProgress = YES;
        [self didChangeValueForKey:@"syncInProgress"];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [self downloadDataForRegisteredObjects:YES toDeleteLocalRecords:NO];
        });
    }
}

#pragma mark - File Management
- (NSURL *)applicationCacheDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSURL *)JSONDataRecordsDirectory {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *url = [NSURL URLWithString:@"JSONRecords/" relativeToURL:[self applicationCacheDirectory]];
    NSError *error = nil;
    if (![fileManager fileExistsAtPath:[url path]]) {
        [fileManager createDirectoryAtPath:[url path] withIntermediateDirectories:YES attributes:nil error:&error];
    }
    
    return url;
}

- (void)writeJSONReponse:(id)response toDiskForClassWithName:(NSString *)className {
    DDLogInfo(@"Writing JSON response to disk for class %@.", className);
    NSURL *fileURL = [NSURL URLWithString:className relativeToURL:[self JSONDataRecordsDirectory]];
    if (![(NSDictionary *)response writeToFile:[fileURL path] atomically:YES]) {
        DDLogWarn(@"Error saving response to disk, removing nulls.");
        NSArray *records = [(NSDictionary *)response objectForKey:@"results"];
        NSMutableArray *nullFreeRecords = [NSMutableArray array];
        for (NSDictionary *record in records) {
            NSMutableDictionary *nullFreeRecord = [NSMutableDictionary dictionaryWithDictionary:record];
            [record enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                if ([obj isKindOfClass:[NSNull class]]) {
                    [nullFreeRecord setValue:nil forKey:key];
                }
            }];
            [nullFreeRecords addObject:nullFreeRecord];
        }
        
        NSDictionary *nullFreeDictionary = [NSDictionary dictionaryWithObject:nullFreeRecords forKey:@"results"];
        if (![nullFreeDictionary writeToFile:[fileURL path] atomically:YES]) {
            DDLogError(@"Failed all attempts to save response to disk: %@", response);
        }
    }
}

#pragma mark - Sync Management

- (BOOL)initialSyncComplete {
    return [[[NSUserDefaults standardUserDefaults] valueForKey:kSDSyncEngineInitialCompleteKey] boolValue];
}

- (void)setInitialSyncCompleted {
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:YES] forKey:kSDSyncEngineInitialCompleteKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)executeSyncCompletedOperations {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setInitialSyncCompleted];
        [[NSNotificationCenter defaultCenter] postNotificationName:kSDSyncEngineSyncCompletedNotificationName object:nil];
        [self willChangeValueForKey:@"syncInProgress"];
        _syncInProgress = NO;
        [self didChangeValueForKey:@"syncInProgress"];
        DDLogInfo(@"Sync completed.");
    });
}

#pragma mark - Remote Data Processing

- (NSDictionary *)JSONDictionaryForClassWithName:(NSString *)className {
    NSURL *fileURL = [NSURL URLWithString:className relativeToURL:[self JSONDataRecordsDirectory]];
    return [NSDictionary dictionaryWithContentsOfURL:fileURL];
}

// Returns an array of all of the records in the response.
- (NSArray *)JSONDataRecordsForClass:(NSString *)className sortByKey:(NSString *)key {
    NSDictionary *JSONDictionary = [self JSONDictionaryForClassWithName:className];
    NSArray *records = [JSONDictionary objectForKey:@"results"];
    return [records sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:key ascending:YES]]];
}

// No reason to keep the JSON response saved to the disk once they are put in core data.
- (void)deleteJSONDataRecordsForClassWithName:(NSString *)className {
    NSURL *url = [NSURL URLWithString:className relativeToURL:[self JSONDataRecordsDirectory]];
    NSError *error;
    BOOL deleted = [[NSFileManager defaultManager] removeItemAtURL:url error:&error];
    if (!deleted) {
        DDLogError(@"Unable to delete JSON Records at %@, reason: %@", url, error);
    }
}

#pragma mark - Date Formatting

- (void)initializeDateFormatter {
    if (!self.dateFormatter) {
        self.dateFormatter = [[NSDateFormatter alloc] init];
        [self.dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
        [self.dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    }
}

- (NSDate *)dateUsingStringFromAPI:(NSString *)dateString {
    [self initializeDateFormatter];
    
    /* 
     * Parse provides dates in the following format:
     * {
     *      "__type": "Date",
     *      "iso": "2011-08-21T18:02:52.249Z"
     * }
     * NSDateFormatter does not like ISO 8601 (well defined method for respesenting dates between countries) so stripping to milliseconds and timezone
     */
    
    dateString = [dateString substringWithRange:NSMakeRange(0, [dateString length]-5)];
    return [self.dateFormatter dateFromString:dateString];
}

- (NSString *)dateStringForAPIUsingDate:(NSDate *)date {
    [self initializeDateFormatter];
    NSString *dateString = [self.dateFormatter stringFromDate:date];
    // remove Z
    dateString = [dateString substringWithRange:NSMakeRange(0, [dateString length]-1)];
    // add milliseconds and put Z back on
    dateString = [dateString stringByAppendingFormat:@".000z"];
    
    return dateString;
}

- (NSDate *)dateUsingReleaseDateStringFromAPI:(NSString *)dateString {
    NSDate *date;
    [self initializeDateFormatter];
    [self.dateFormatter setDateFormat:@"MMM dd, yyyy"];
    date = [self.dateFormatter dateFromString:dateString];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    return date;
}

#pragma mark - Creating and Updating Managed Objects

- (void)newManagedObjectWithClassName:(NSString *)className forRecord:(NSDictionary *)record {
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:className inManagedObjectContext:[[SBCoreDataController sharedInstance] backgroundManagedObjectContext]];
    [record enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [self setValue:obj forKey:key forManagedObject:newManagedObject];
    }];
    [record setValue:[NSNumber numberWithInt:SBObjectSynced] forKey:@"syncStatus"];
}

- (void)updateManagedObject:(NSManagedObject *)managedObject withRecord:(NSDictionary *)record {
    [record enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [self setValue:obj forKey:key forManagedObject:managedObject];
    }];
}

- (void)setValue:(id)value forKey:(NSString *)key forManagedObject:(NSManagedObject *)managedObject {
    if ([key isEqualToString:@"createdAt"] || [key isEqualToString:@"updatedAt"]) {
        NSDate *date = [self dateUsingStringFromAPI:value];
        [managedObject setValue:date forKey:key];
    } else if ([key isEqualToString:@"releaseDate"]) {
        NSDate *date = [self dateUsingReleaseDateStringFromAPI:value];
        [managedObject setValue:date forKey:key];
    } else if ([key isEqualToString:@"platforms"]) {
        // query sql for each platform
        NSManagedObjectContext *context = [[SBCoreDataController sharedInstance] backgroundManagedObjectContext];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Platform"
                                                  inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        
        NSError *error;
        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
        if (fetchedObjects == nil) {
            DDLogError(@"Failed to fetch platforms from manageObjectContext");
        } else {
            for (NSString *platform in value) {
                for (Platform *existingPlatform in fetchedObjects) {
                    if ([existingPlatform.title isEqualToString:platform]) {
                        [(Game *)managedObject addPlatformsObject:existingPlatform];
                    }
                }
            }
        }
        
    } else if ([value isKindOfClass:[NSDictionary class]]) {
        if ([(NSDictionary *)value objectForKey:@"__type"]) {
            NSString *dataType = [(NSDictionary *)value objectForKey:@"__type"];
            if ([dataType isEqualToString:@"Date"]) {
                NSString *dateString = [(NSDictionary *)value objectForKey:@"iso"];
                NSDate *date = [self dateUsingStringFromAPI:dateString];
                [managedObject setValue:date forKey:key];
            } else if ([dataType isEqualToString:@"File"]) {
                NSString *urlString = [(NSDictionary *)value objectForKey:@"url"];
                NSURL *url = [NSURL URLWithString:urlString];
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                NSURLResponse *response = nil;
                NSError *error = nil;
                NSData *dataReponse = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
                [managedObject setValue:dataReponse forKey:key];
            } else {
                DDLogError(@"Unknown Data Type Received");
                [managedObject setValue:nil forKey:key];
            }
        }
    } else if ([value isKindOfClass:[NSArray class]]) {
        NSData *serializedValue = [NSKeyedArchiver archivedDataWithRootObject:value];
        [managedObject setValue:serializedValue forKey:key];
    } else {
        [managedObject setValue:value forKey:key];
    }
}

- (NSArray *)managedObjectsForClass:(NSString *)className withSyncStatus:(SBOBjectSyncStatus)syncStatus {
    __block NSArray *results = nil;
    NSManagedObjectContext *managedObjectContext = [[SBCoreDataController sharedInstance] backgroundManagedObjectContext];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:className];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"syncStatus = %d", syncStatus];
    [fetchRequest setPredicate:predicate];
    [managedObjectContext performBlockAndWait:^{
        NSError *error = nil;
        results = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    }];
    
    return results;
}

- (NSArray *)managedObjectForClass:(NSString *)className sortedByKey:(NSString *)key usingArrayOfIds:(NSArray *)idArray inArrayOfIds:(BOOL)inIds {
    __block NSArray *results = nil;
    NSManagedObjectContext *managedObjectContext = [[SBCoreDataController sharedInstance] backgroundManagedObjectContext];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:className];
    NSPredicate *predicate;
    if (inIds) {
        predicate = [NSPredicate predicateWithFormat:@"objectId IN %@", idArray];
    } else {
        predicate = [NSPredicate predicateWithFormat:@"NOT (objectId IN %@)", idArray];
    }
    [fetchRequest setPredicate:predicate];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"objectId" ascending:YES]]];
    [managedObjectContext performBlockAndWait:^{
        NSError *error = nil;
        results = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    }];
    
    return results;
}

- (void)processJSONDataRecordsIntoCoreData {
    NSManagedObjectContext *managedObjectContext = [[SBCoreDataController sharedInstance] backgroundManagedObjectContext];
    // Iterate over all classes registered to object context
    for (NSString *className in self.registeredClassesToSync) {
        if (![self initialSyncComplete]) {
            NSDictionary *JSONDictionary = [self JSONDictionaryForClassWithName:className];
            NSArray *records = [JSONDictionary objectForKey:@"results"];
            for (NSDictionary *record in records) {
                [self newManagedObjectWithClassName:className forRecord:record];
            }
        } else {
            NSArray *downloadedRecords = [self JSONDataRecordsForClass:className sortByKey:@"objectId"];
            if ([downloadedRecords lastObject]) {
                NSArray *storedRecords = [self managedObjectForClass:className sortedByKey:@"objectId" usingArrayOfIds:[downloadedRecords valueForKey:@"objectId"] inArrayOfIds:YES];
                int currentIndex = 0;
                
                for (NSDictionary *record in downloadedRecords) {
                    NSManagedObject *storedManagedObject = nil;
                    if ([storedRecords count] > (unsigned)currentIndex) {
                        storedManagedObject = [storedRecords objectAtIndex:currentIndex];
                    }
                    
                    if ([[storedManagedObject valueForKey:@"objectId"] isEqualToString:[record valueForKey:@"objectId"]]) {
                        DDLogVerbose(@"Updating Object with name: %@", [storedManagedObject valueForKey:@"title"]);
                        [self updateManagedObject:[storedRecords objectAtIndex:currentIndex] withRecord:record];
                    } else {
                        DDLogVerbose(@"Creating new managed object for game with name: %@, because %@ =/= %@", [record valueForKey:@"title"], [record valueForKey:@"objectId"], [storedManagedObject valueForKey:@"objectId"]);
                        [self newManagedObjectWithClassName:className forRecord:record];
                    }
                    currentIndex++;
                }
            }
        }
        
        [managedObjectContext performBlockAndWait:^{
            NSError *error = nil;
            if (![managedObjectContext save:&error]) {
                DDLogError(@"Unable to save context for class %@", className);
            }
        }];
        
        [self deleteJSONDataRecordsForClassWithName:className];
        
    }
    
    [self downloadDataForRegisteredObjects:NO toDeleteLocalRecords:YES];
}

- (void)processJSONDataRecordsForDeletion {
    NSManagedObjectContext *managedObjectContext = [[SBCoreDataController sharedInstance] backgroundManagedObjectContext];
    
    //Iterate over all of the registered classes
    for (NSString *className in self.registeredClassesToSync) {
        //Get JSON response records off of the disk
        NSArray *JSONRecords = [self JSONDataRecordsForClass:className sortByKey:@"objectId"];
        if ([JSONRecords count] > 0) {
            // If there are any records fetch all locally stored records that are NOT in the list of downloaded records
            NSArray *storedRecords = [self managedObjectForClass:className sortedByKey:@"objectId" usingArrayOfIds:[JSONRecords valueForKey:@"objectId"] inArrayOfIds:NO];
            //Schedule ManagedObjects for deletion and save context
            [managedObjectContext performBlockAndWait:^{
                for (NSManagedObject *managedObject in storedRecords) {
                    [managedObjectContext deleteObject:managedObject];
                }
                NSError *error = nil;
                BOOL saved = [managedObjectContext save:&error];
                if (!saved) {
                    DDLogError(@"Unable to save context after deleting records for class %@ because %@", className, error);
                }
            }];
        }
        //Delete all JSON Record response files
        [self deleteJSONDataRecordsForClassWithName:className];
    }
    
    // Execute the sync completion operations as this is now the final step of the sync process
    [self executeSyncCompletedOperations];
}

#pragma mark - Update Execution

- (void)incrementLikesByOneForObjectWithId:(NSString *)objectId {
    NSMutableArray *requestOperations = [NSMutableArray array];
    
    // create parameter array based off object id and increment like count
    NSDictionary *params = @{@"likes": @{@"__op":@"Increment", @"amount":@(1)}};
    NSMutableURLRequest * request = [[SBAFParseAPIClient sharedClient] PUTRequestForClass:@"Game"
                                                                          forObjectWithId:objectId
                                                                               parameters:params];
    AFHTTPRequestOperation *requestOperation = [[SBAFParseAPIClient sharedClient] HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            //[self writeJSONReponse:responseObject toDiskForClassWithName:className];
            DDLogVerbose(@"JSON RESPONSE: %@", responseObject);
            DDLogInfo(@"Like count on server succesfully updated.");
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DDLogError(@"PUTRequest for class Game failed with error: %@", error);
    }];
    
    [requestOperations addObject:requestOperation];
    [[SBAFParseAPIClient sharedClient] enqueueBatchOfHTTPRequestOperations:requestOperations progressBlock:^(NSUInteger numberOfCompletedOperations, NSUInteger totalNumberOfOperations) {
        
    } completionBlock:^(NSArray *operations) {
        
    }];
}

@end
