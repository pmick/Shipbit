// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Platform.h instead.

#import <CoreData/CoreData.h>


extern const struct PlatformAttributes {
	__unsafe_unretained NSString *createdAt;
	__unsafe_unretained NSString *objectId;
	__unsafe_unretained NSString *title;
	__unsafe_unretained NSString *updatedAt;
} PlatformAttributes;

extern const struct PlatformRelationships {
	__unsafe_unretained NSString *games;
} PlatformRelationships;

extern const struct PlatformFetchedProperties {
} PlatformFetchedProperties;

@class Game;






@interface PlatformID : NSManagedObjectID {}
@end

@interface _Platform : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (PlatformID*)objectID;





@property (nonatomic, strong) NSDate* createdAt;



//- (BOOL)validateCreatedAt:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* objectId;



//- (BOOL)validateObjectId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* title;



//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* updatedAt;



//- (BOOL)validateUpdatedAt:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *games;

- (NSMutableSet*)gamesSet;





@end

@interface _Platform (CoreDataGeneratedAccessors)

- (void)addGames:(NSSet*)value_;
- (void)removeGames:(NSSet*)value_;
- (void)addGamesObject:(Game*)value_;
- (void)removeGamesObject:(Game*)value_;

@end

@interface _Platform (CoreDataGeneratedPrimitiveAccessors)


- (NSDate*)primitiveCreatedAt;
- (void)setPrimitiveCreatedAt:(NSDate*)value;




- (NSString*)primitiveObjectId;
- (void)setPrimitiveObjectId:(NSString*)value;




- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;




- (NSDate*)primitiveUpdatedAt;
- (void)setPrimitiveUpdatedAt:(NSDate*)value;





- (NSMutableSet*)primitiveGames;
- (void)setPrimitiveGames:(NSMutableSet*)value;


@end
