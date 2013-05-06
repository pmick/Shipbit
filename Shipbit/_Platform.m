// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Platform.m instead.

#import "_Platform.h"

const struct PlatformAttributes PlatformAttributes = {
	.createdAt = @"createdAt",
	.objectId = @"objectId",
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
	

	return keyPaths;
}




@dynamic createdAt;






@dynamic objectId;






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
