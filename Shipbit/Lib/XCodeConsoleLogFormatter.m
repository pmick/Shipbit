//
//  XCodeConsoleLogFormatter.m
//  Shipbit
//
//  Created by Patrick Mick on 5/2/13.
//  Copyright (c) 2013 PatrickMick. All rights reserved.
//

#import "XCodeConsoleLogFormatter.h"

@implementation XCodeConsoleLogFormatter

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage
{
    NSString *logLevel;
    switch (logMessage.flag)
    {
        case LOG_FLAG_ERROR : logLevel = @"E"; break;
        case LOG_FLAG_WARN  : logLevel = @"W"; break;
        case LOG_FLAG_INFO  : logLevel = @"I"; break;
        default             : logLevel = @"V"; break;
    }
    
    static NSDateFormatter *formatter = nil;
    if (!formatter) {
        formatter = [NSDateFormatter new];
        formatter.dateFormat = @"HH:mm:ss.SSS";
    }
    
    NSString *dateString = [formatter stringFromDate:logMessage.timestamp];
    
    //Format the message
    NSString *output;
    output = [NSString stringWithFormat:@"%@ %@ %@ >> %@", dateString,
              logMessage.threadID, logLevel, logMessage.message];
    
    return output;
}

@end
