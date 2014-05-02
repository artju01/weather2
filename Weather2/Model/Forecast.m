//
//  WeatherForcast.m
//  Weather2
//
//  Created by Kritsakorn on 5/1/14.
//  Copyright (c) 2014 Kritsakorn. All rights reserved.
//

#import "Forecast.h"

@implementation Forecast

+ (NSArray *)validDayOfWeek
{
    return @[@"",@"Sunday",@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday"];
}

+ (NSString *)getDayOfTheWeek:(NSDate *)date
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"e"];
    NSInteger weekdayNumber = (NSInteger)[[dateFormatter stringFromDate:date] integerValue];
    
    return [[Forecast validDayOfWeek] objectAtIndex:weekdayNumber];
}


+ (NSDate *) convertNSStringToNSDate:(NSString *)dateData
{
    NSDate *date = nil;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    date = [dateFormatter dateFromString:dateData ];

    return date;
}


- (NSInteger)getMaxTemperature
{
    return self.dayWeather.temp;
}

- (NSInteger)getMinTemperature
{
    return self.nightWeather.temp;
}


@end
