//
//  MeasuringWrapper.mm
//  PlatformChannelPerformance
//
//  Created by Markus Reinhold on 31.05.23.
//

#import "MeasuringWrapper.h"


@implementation MeasuringWrapper

+ (void) startMeasuring:(NSString*)name :(NSInteger)identifier {
    const char *utfString = [name UTF8String];
    startMeasuring(utfString, identifier);
}


+ (void) endMeasuring:(NSString*)name :(NSInteger)identifier {
    const char *utfString = [name UTF8String];
    endMeasuring(utfString, identifier);
}

+ (void) logEvent:(NSString*)name :(NSInteger)value {
    const char *utfString = [name UTF8String];
    logEvent(utfString, value);
}

+ (void) printLogs {
    printLogs();
}

@end
