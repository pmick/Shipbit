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
    //Alter the message to your liking
    NSString *msg = [logMessage->logMsg stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
    
    NSString *logLevel;
    switch (logMessage->logFlag)
    {
        case LOG_FLAG_ERROR : logLevel = @"E"; break;
        case LOG_FLAG_WARN  : logLevel = @"W"; break;
        case LOG_FLAG_INFO  : logLevel = @"I"; break;
        default             : logLevel = @"V"; break;
    }
    
    //Also display the file the logging occurred in to ease later debugging
    NSString *file = [[[NSString stringWithUTF8String:logMessage->file] lastPathComponent] stringByDeletingPathExtension];
    
    //Format the message for the server-side log file parser
    return [NSString stringWithFormat:@"%@ %x %@ \"%@\" | [%@@%s@%i]", logMessage->timestamp, logMessage->machThreadID, logLevel, msg, file, logMessage->function, logMessage->lineNumber];
}

@end
