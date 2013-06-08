//
//  SBAFParseAPIClient.h
//  Shipbit
//
//  Created by Patrick Mick on 1/9/13.
//  Copyright (c) 2013 PatrickMick. All rights reserved.
//

#import "AFHTTPClient.h"

@interface SBAFParseAPIClient : AFHTTPClient

+ (SBAFParseAPIClient *)sharedClient;

- (NSMutableURLRequest *)GETRequestForClass:(NSString *)className parameters:(NSDictionary *)parameters;
- (NSMutableURLRequest *)GETRequestForAllRecordsOfClass:(NSString *)className updatedAfterDate:(NSDate *)updatedDate;
- (NSMutableURLRequest *)GETRequestForSomeRecordsOfClass:(NSString *)className releasedAfterDate:(NSDate *)releaseDate;
- (NSMutableURLRequest *)PUTRequestForClass:(NSString *)className forObjectWithId:(NSString *)objectId parameters:(NSDictionary *)parameters;

@end
