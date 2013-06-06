// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Platform.m instead.

#import "_Platform.h"

const struct PlatformAttributes PlatformAttributes = {
	.createdAt = @"createdAt",
	.objectId = @"objectId",
	.syncStatus = @"syncStatus",
	.title = @"title",
	.updatedAt = @"updatedAt",
};

const struct PlatformRelationships PlatformRelationships = {
	.games = @"games",
};

const struct PlatformFetchedProperties PlatformFetchedProperties = {
};

@implementation PlatformID
@end

@implementation _Platform

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Platform" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Platform";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Platform" inManagedObjectContext:moc_];
}

- (PlatformID*)objectID {
	return (PlatformID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"syncStatusValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"syncStatus"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic createdAt;






@dynamic objectId;






@dynamic syncStatus;



- (int16_t)syncStatusValue {
	NSNumber *result = [self syncStatus];
	return [result shortValue];
}

- (void)setSyncStatusValue:(int16_t)value_ {
	[self setSyncStatus:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveSyncStatusValue {
	NSNumber *result = [self primitiveSyncStatus];
	return [result shortValue];
}

- (void)setPrimitiveSyncStatusValue:(int16_t)value_ {
	[self setPrimitiveSyncStatus:[NSNumber numberWithShort:value_]];
}





@dynamic title;






@dynamic updatedAt;






@dynamic games;

	
- (NSMutableSet*)gamesSet {
	[self willAccessValueForKey:@"games"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"games"];
  
	[self didAccessValueForKey:@"games"];
	return result;
}
	






@end
