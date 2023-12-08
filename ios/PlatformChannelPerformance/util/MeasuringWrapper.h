//
//  MeasuringWrapper.h
//  PlatformChannelPerformance
//
//  Created by Markus Reinhold on 31.05.23.
//

#import <Foundation/Foundation.h>
#import "measuring.hpp"

@interface MeasuringWrapper : NSObject
+ (void) startMeasuring:(NSString*)name :(NSInteger)identifier;
+ (void) endMeasuring:(NSString*)name :(NSInteger)identifier;
+ (void) logEvent:(NSString*)name :(NSInteger)value;
+ (void) printLogs;
@end
