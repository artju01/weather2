//
//  WeatherForcast.h
//  Weather2
//
//  Created by Kritsakorn on 5/1/14.
//  Copyright (c) 2014 Kritsakorn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Weather.h"
@interface Forecast : NSObject

@property (strong, nonatomic)NSDate *date;
@property (strong,nonatomic)Weather *dayWeather;
@property (strong,nonatomic)Weather *nightWeather;

+ (NSString *)getDayOfTheWeek:(NSDate *)date;
+ (NSDate *) convertNSStringToNSDate:(NSString *)dateData;

- (NSInteger)getMaxTemperature;
- (NSInteger)getMinTemperature;


@end
