//
//  Game.h
//  Shipbit
//
//  Created by Patrick Mick on 1/31/13.
//  Copyright (c) 2013 PatrickMick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Game : NSManagedObject

@property (nonatomic, strong) NSString * art;
@property (nonatomic, strong) NSDate * createdAt;
@property (nonatomic, strong) NSNumber * criticScore;
@property (nonatomic, strong) NSString * developer;
@property (nonatomic, strong) NSString * esrb;
@property (nonatomic, strong) NSString * genre;
@property (nonatomic, strong) NSString * link;
@property (nonatomic, strong) NSString * objectId;
@property (nonatomic, strong) id platforms;
@property (nonatomic, strong) NSString * publisher;
@property (nonatomic, strong) NSDate * releaseDate;
@property (nonatomic, strong) NSDate * primitiveReleaseDate;
@property (nonatomic, strong) NSString * summary;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSDate * updatedAt;

@property (nonatomic, strong) NSString * sectionIdentifier;
@property (nonatomic, strong) NSString * primitiveSectionIdentifier;



@end
