// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Game.m instead.

#import "_Game.h"

const struct GameAttributes GameAttributes = {
	.art = @"art",
	.createdAt = @"createdAt",
	.criticScore = @"criticScore",
	.developer = @"developer",
	.esrb = @"esrb",
	.genre = @"genre",
	.link = @"link",
	.objectId = @"objectId",
	.publisher = @"publisher",
	.releaseDate = @"releaseDate",
	.sectionIdentifier = @"sectionIdentifier",
	.summary = @"summary",
	.title = @"title",
	.updatedAt = @"updatedAt",
};

const struct GameRelationships GameRelationships = {
	.platforms = @"platforms",
};

const struct GameFetchedProperties GameFetchedProperties = {
};

@implementation GameID
@end

@implementation _Game

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Game" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Game";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Game" inManagedObjectContext:moc_];
}

- (GameID*)objectID {
	return (GameID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"criticScoreValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"criticScore"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic art;






@dynamic createdAt;






@dynamic criticScore;



- (int16_t)criticScoreValue {
	NSNumber *result = [self criticScore];
	return [result shortValue];
}

- (void)setCriticScoreValue:(int16_t)value_ {
	[self setCriticScore:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveCriticScoreValue {
	NSNumber *result = [self primitiveCriticScore];
	return [result shortValue];
}

- (void)setPrimitiveCriticScoreValue:(int16_t)value_ {
	[self setPrimitiveCriticScore:[NSNumber numberWithShort:value_]];
}





@dynamic developer;






@dynamic esrb;






@dynamic genre;






@dynamic link;






@dynamic objectId;






@dynamic publisher;






@dynamic releaseDate;






@dynamic sectionIdentifier;






@dynamic summary;






@dynamic title;






@dynamic updatedAt;






@dynamic platforms;

	
- (NSMutableSet*)platformsSet {
	[self willAccessValueForKey:@"platforms"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"platforms"];
  
	[self didAccessValueForKey:@"platforms"];
	return result;
}
	






@end
