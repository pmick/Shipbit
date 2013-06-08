// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Game.h instead.

#import <CoreData/CoreData.h>


extern const struct GameAttributes {
	__unsafe_unretained NSString *art;
	__unsafe_unretained NSString *createdAt;
	__unsafe_unretained NSString *criticScore;
	__unsafe_unretained NSString *developer;
	__unsafe_unretained NSString *esrb;
	__unsafe_unretained NSString *firstLetter;
	__unsafe_unretained NSString *genre;
	__unsafe_unretained NSString *hasLiked;
	__unsafe_unretained NSString *isFavorite;
	__unsafe_unretained NSString *likes;
	__unsafe_unretained NSString *link;
	__unsafe_unretained NSString *objectId;
	__unsafe_unretained NSString *publisher;
	__unsafe_unretained NSString *releaseDate;
	__unsafe_unretained NSString *sectionIdentifier;
	__unsafe_unretained NSString *summary;
	__unsafe_unretained NSString *syncStatus;
	__unsafe_unretained NSString *title;
	__unsafe_unretained NSString *updatedAt;
	__unsafe_unretained NSString *watchSection;
} GameAttributes;

extern const struct GameRelationships {
	__unsafe_unretained NSString *platforms;
} GameRelationships;

extern const struct GameFetchedProperties {
} GameFetchedProperties;

@class Platform;






















@interface GameID : NSManagedObjectID {}
@end

@interface _Game : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (GameID*)objectID;





@property (nonatomic, strong) NSString* art;



//- (BOOL)validateArt:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* createdAt;



//- (BOOL)validateCreatedAt:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* criticScore;



@property int16_t criticScoreValue;
- (int16_t)criticScoreValue;
- (void)setCriticScoreValue:(int16_t)value_;

//- (BOOL)validateCriticScore:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* developer;



//- (BOOL)validateDeveloper:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* esrb;



//- (BOOL)validateEsrb:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* firstLetter;



//- (BOOL)validateFirstLetter:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* genre;



//- (BOOL)validateGenre:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* hasLiked;



@property BOOL hasLikedValue;
- (BOOL)hasLikedValue;
- (void)setHasLikedValue:(BOOL)value_;

//- (BOOL)validateHasLiked:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* isFavorite;



@property BOOL isFavoriteValue;
- (BOOL)isFavoriteValue;
- (void)setIsFavoriteValue:(BOOL)value_;

//- (BOOL)validateIsFavorite:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* likes;



@property int32_t likesValue;
- (int32_t)likesValue;
- (void)setLikesValue:(int32_t)value_;

//- (BOOL)validateLikes:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* link;



//- (BOOL)validateLink:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* objectId;



//- (BOOL)validateObjectId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* publisher;



//- (BOOL)validatePublisher:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* releaseDate;



//- (BOOL)validateReleaseDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* sectionIdentifier;



//- (BOOL)validateSectionIdentifier:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* summary;



//- (BOOL)validateSummary:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* syncStatus;



@property int16_t syncStatusValue;
- (int16_t)syncStatusValue;
- (void)setSyncStatusValue:(int16_t)value_;

//- (BOOL)validateSyncStatus:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* title;



//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* updatedAt;



//- (BOOL)validateUpdatedAt:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* watchSection;



//- (BOOL)validateWatchSection:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *platforms;

- (NSMutableSet*)platformsSet;





@end

@interface _Game (CoreDataGeneratedAccessors)

- (void)addPlatforms:(NSSet*)value_;
- (void)removePlatforms:(NSSet*)value_;
- (void)addPlatformsObject:(Platform*)value_;
- (void)removePlatformsObject:(Platform*)value_;

@end

@interface _Game (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveArt;
- (void)setPrimitiveArt:(NSString*)value;




- (NSDate*)primitiveCreatedAt;
- (void)setPrimitiveCreatedAt:(NSDate*)value;




- (NSNumber*)primitiveCriticScore;
- (void)setPrimitiveCriticScore:(NSNumber*)value;

- (int16_t)primitiveCriticScoreValue;
- (void)setPrimitiveCriticScoreValue:(int16_t)value_;




- (NSString*)primitiveDeveloper;
- (void)setPrimitiveDeveloper:(NSString*)value;




- (NSString*)primitiveEsrb;
- (void)setPrimitiveEsrb:(NSString*)value;




- (NSString*)primitiveFirstLetter;
- (void)setPrimitiveFirstLetter:(NSString*)value;




- (NSString*)primitiveGenre;
- (void)setPrimitiveGenre:(NSString*)value;




- (NSNumber*)primitiveHasLiked;
- (void)setPrimitiveHasLiked:(NSNumber*)value;

- (BOOL)primitiveHasLikedValue;
- (void)setPrimitiveHasLikedValue:(BOOL)value_;




- (NSNumber*)primitiveIsFavorite;
- (void)setPrimitiveIsFavorite:(NSNumber*)value;

- (BOOL)primitiveIsFavoriteValue;
- (void)setPrimitiveIsFavoriteValue:(BOOL)value_;




- (NSNumber*)primitiveLikes;
- (void)setPrimitiveLikes:(NSNumber*)value;

- (int32_t)primitiveLikesValue;
- (void)setPrimitiveLikesValue:(int32_t)value_;




- (NSString*)primitiveLink;
- (void)setPrimitiveLink:(NSString*)value;




- (NSString*)primitiveObjectId;
- (void)setPrimitiveObjectId:(NSString*)value;




- (NSString*)primitivePublisher;
- (void)setPrimitivePublisher:(NSString*)value;




- (NSDate*)primitiveReleaseDate;
- (void)setPrimitiveReleaseDate:(NSDate*)value;




- (NSString*)primitiveSectionIdentifier;
- (void)setPrimitiveSectionIdentifier:(NSString*)value;




- (NSString*)primitiveSummary;
- (void)setPrimitiveSummary:(NSString*)value;




- (NSNumber*)primitiveSyncStatus;
- (void)setPrimitiveSyncStatus:(NSNumber*)value;

- (int16_t)primitiveSyncStatusValue;
- (void)setPrimitiveSyncStatusValue:(int16_t)value_;




- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;




- (NSDate*)primitiveUpdatedAt;
- (void)setPrimitiveUpdatedAt:(NSDate*)value;




- (NSString*)primitiveWatchSection;
- (void)setPrimitiveWatchSection:(NSString*)value;





- (NSMutableSet*)primitivePlatforms;
- (void)setPrimitivePlatforms:(NSMutableSet*)value;


@end
