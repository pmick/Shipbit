//
//  SBAFParseAPIClient.m
//  Shipbit
//
//  Created by Patrick Mick on 1/9/13.
//  Copyright (c) 2013 PatrickMick. All rights reserved.
//

#import "SBAFParseAPIClient.h"
#import "AFJSONRequestOperation.h"

static NSString * const kSBFParseAPIBaseURLString = @"https://api.parse.com/1/";

static NSString * const kSBFParseAPIApplicationId = @"HJqzfHjn0qctt7JH5YIkaTdtjNQx46P21tbh9DbD";
static NSString * const kSBFParseAPIKey = @"hsbqPntedrgTmBMlxpkkEOlaxeMvUmWUEsC3WmmU";

@implementation SBAFParseAPIClient

+ (SBAFParseAPIClient *)sharedClient {
    static SBAFParseAPIClient *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[SBAFParseAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kSBFParseAPIBaseURLString]];
    });
    
    return sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [self setParameterEncoding:AFFormURLParameterEncoding];
        [self setDefaultHeader:@"X-Parse-Application-Id" value:kSBFParseAPIApplicationId];
        [self setDefaultHeader:@"X-Parse-REST-API-Key" value:kSBFParseAPIKey];
        [self setDefaultHeader:@"Accept" value:@"application/json"];
    }
    
    return self;
}

- (NSMutableURLRequest *)GETRequestForClass:(NSString *)className parameters:(NSDictionary *)parameters {
    NSMutableURLRequest *request = nil;
    request = [self requestWithMethod:@"GET" path:[NSString stringWithFormat:@"classes/%@", className] parameters:parameters];
    
    return request;
}

- (NSMutableURLRequest *)GETRequestForAllRecordsOfClass:(NSString *)className updateAfterDate:(NSDate *)updatedDate {
    NSMutableURLRequest *request = nil;
    NSDictionary *parameters = nil;
    if (updatedDate) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat: @"yyyy-MM-dd'T'HH:mm:ss.'999Z'"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        
        NSString *jsonString = [NSString stringWithFormat:@"{\"updatedAt\":{\"$gte\":{\"__type\":\"Date\",\"iso\":\"%@\"}}}",[dateFormatter stringFromDate:updatedDate]];
        parameters = [NSDictionary dictionaryWithObject:jsonString forKey:@"where"];
    }
    request = [self GETRequestForClass:className parameters:parameters];
    
    return request;
}
@end
