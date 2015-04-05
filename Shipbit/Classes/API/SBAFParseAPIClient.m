//
//  SBAFParseAPIClient.m
//  Shipbit
//
//  Created by Patrick Mick on 1/9/13.
//  Copyright (c) 2013 PatrickMick. All rights reserved.
//

#import "SBAFParseAPIClient.h"
#import "AFJSONRequestOperation.h"
#import "SBConstants.h"

static NSString * const kSBFParseAPIBaseURLString = @"https://api.parse.com/1/";

static NSString * const kSBFParseAPIApplicationId = API_APPLICATION_ID;
static NSString * const kSBFParseAPIKey = API_KEY;

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
        // Previously AFFormURLParameterEncoding
        // Now AFJSONParameterEncoding
        [self setParameterEncoding:AFJSONParameterEncoding];
        [self setDefaultHeader:@"X-Parse-Application-Id" value:kSBFParseAPIApplicationId];
        [self setDefaultHeader:@"X-Parse-REST-API-Key" value:kSBFParseAPIKey];
        [self setDefaultHeader:@"Accept" value:@"application/json"];
        [self setDefaultHeader:@"content-type" value:@"application/json"];
        [self setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            if (status == AFNetworkReachabilityStatusNotReachable) {
                DDLogVerbose(@"Not reachable");
                UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Network Problem"
                                                                  message:@"You lost connection to the internet, some parts of Shipbit might not work."
                                                                 delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles:nil];
                [message show];
            } else {
                DDLogVerbose(@"Reachable");
            }
        }];
    }
    
    return self;
}

- (NSMutableURLRequest *)GETRequestForClass:(NSString *)className parameters:(NSDictionary *)parameters {
    NSMutableURLRequest *request = nil;
    request = [self requestWithMethod:@"GET"
                                 path:[NSString stringWithFormat:@"classes/%@", className]
                           parameters:parameters];
    
    return request;
}

- (NSMutableURLRequest *)GETRequestForAllRecordsOfClass:(NSString *)className updatedAfterDate:(NSDate *)updatedDate {
    NSMutableURLRequest *request = nil;
    NSDictionary *parameters = nil;
    NSString *jsonString = @"";
    if (updatedDate) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.'999Z'"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        
        jsonString = [NSString stringWithFormat:@"{\"updatedAt\":{\"$gte\":{\"__type\":\"Date\",\"iso\":\"%@\"}}}",
                      [dateFormatter stringFromDate:updatedDate]];
        
    }
    
    // Parse added a default limit value of 100, takes values between 1-1000
    NSString *jsonLimit = @"1000";
    
    if (jsonString.length > 0) {
        parameters = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects: jsonString, jsonLimit, nil]
                                                 forKeys:[NSArray arrayWithObjects: @"where", @"limit", nil]];
    } else {
        parameters = [NSDictionary dictionaryWithObject:jsonLimit
                                                 forKey:@"limit"];
    }
    
    request = [self GETRequestForClass:className parameters:parameters];
    return request;
}

- (NSMutableURLRequest *)GETRequestForSomeRecordsOfClass:(NSString *)className releasedAfterDate:(NSDate *)releaseDate {
    NSMutableURLRequest *request = nil;
    NSDictionary *parameters = nil;
    NSString *jsonString = @"";
    if (releaseDate) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.'999Z'"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        
        jsonString = [NSString stringWithFormat:@"{\"releaseDateLong\":{\"$gte\":{\"__type\":\"Date\",\"iso\":\"%@\"}}}",
                      [dateFormatter stringFromDate:releaseDate]];
        
    }
    
    // Parse added a default limit value of 100, takes values between 1-1000
    NSString *jsonLimit = @"100";
    
    if (jsonString.length > 0) {
        parameters = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects: jsonString, jsonLimit, nil]
                                                 forKeys:[NSArray arrayWithObjects: @"where", @"limit", nil]];
    } else {
        parameters = [NSDictionary dictionaryWithObject:jsonLimit
                                                 forKey:@"limit"];
    }
    
    request = [self GETRequestForClass:className parameters:parameters];
    return request;
}

- (NSMutableURLRequest *)PUTRequestForClass:(NSString *)className
                            forObjectWithId:(NSString *)objectId
                                 parameters:(NSDictionary *)parameters {
    NSMutableURLRequest *request = [self requestWithMethod:@"PUT"
                                                      path:[NSString stringWithFormat:@"classes/%@/%@", className, objectId]
                                                parameters:parameters];
    return request;
}

@end
