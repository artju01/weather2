//
//  WeatherFetcher.m
//  Weather2
//
//  Created by Kritsakorn on 5/1/14.
//  Copyright (c) 2014 Kritsakorn. All rights reserved.
//

#import "WeatherFetcher.h"
#import "Wind.h"

@interface WeatherFetcher()

+ (NSDictionary *) FetchData:(NSString *)zipCode;
+ (Wind *) extractWind:(NSDictionary *)windDict;
+ (Weather *) extractWeather:(NSDictionary *)data;
+ (NSMutableArray *) extractForcastWeather:(NSArray *)forcastArray;

@end


@implementation WeatherFetcher

//Fecth weather data from given URL
+ (NSDictionary *) FetchData:(NSString *)zipCode
{
    NSDictionary *weatherDict = nil;
    
    NSURL *hostURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.myweather2.com/developer/forecast.ashx?uac=KDrRbvwbAt&output=json&query=%@&temp_unit=f&ws_unit=mph",zipCode]];
    
    //load JSON from URL
    NSData *allData = [[NSData alloc] initWithContentsOfURL:
                       hostURL];
    NSError *error;
    if (allData != nil) {
        weatherDict = [NSJSONSerialization JSONObjectWithData:allData
                                                   options:NSJSONReadingMutableContainers
                                                     error:&error];
    }
    
    if( error )
    {
        NSLog(@"%@", [error localizedDescription]);
    }
    else {
        
    }

    return weatherDict;
}



+ (WeatherChannel *) CreateWeatherChannel:(NSString *)zipCode {
    WeatherChannel *channel = nil;
    
    //load JSON from URL
    NSDictionary *weatherDict = [WeatherFetcher FetchData:zipCode];
    if (weatherDict) {
        channel = [[WeatherChannel alloc] init];
        channel.zipCode = zipCode;
        channel.currentWeather = [WeatherFetcher extractWeather:[weatherDict[@"weather"][@"curren_weather"] firstObject]];
        
        channel.forcastWeather = [WeatherFetcher extractForcastWeather:weatherDict[@"weather"][@"forecast"]];
    }
    return channel;
}


//extract data from given Dictionary to wind object
+ (Wind *) extractWind:(NSDictionary *)windDict {
    Wind *wind = [[Wind alloc] init];
    wind.direction = [NSString stringWithFormat:@"%@",[windDict objectForKey: @"dir"]];
    wind.directionDegree = [[windDict objectForKey: @"dir_degree"]  integerValue];
    wind.speed = [[windDict objectForKey: @"speed"]  integerValue];
    wind.windUnit = [NSString stringWithFormat:@"%@",[windDict objectForKey: @"wind_unit"]];
    return wind;
}

//extract data from given Dictionary to weather object
+ (Weather *) extractWeather:(NSDictionary *)data
{
    Weather *weather = [[Weather alloc] init];
    weather.humidity =  [[data objectForKey: @"humidity"]  integerValue];
    weather.pressure =  [[data objectForKey: @"pressure"]  integerValue];
    weather.temp =  [[data objectForKey: @"temp"]  integerValue];
    weather.tempUnit =  [NSString stringWithFormat:@"%@",[data objectForKey: @"temp_unit"]];
    weather.weatherCode =  [[data objectForKey: @"weather_code"]  integerValue];
    weather.weatherType =  [NSString stringWithFormat:@"%@",[data objectForKey: @"weather_text"]];
    weather.wind = [WeatherFetcher extractWind:[data[@"wind"] firstObject]];
    return weather;
}

//extract data from given array to forecast array
+ (NSMutableArray *) extractForcastWeather:(NSArray *)forcastArray;
{
    NSMutableArray *forcastWeather = nil;
    
    if ([forcastArray count]) {
        forcastWeather = [[NSMutableArray alloc] init];
        for (id object in forcastArray) {
            Forecast *forcast = [[Forecast alloc] init];
            
            forcast.date  = [Forecast convertNSStringToNSDate:[NSString stringWithFormat:@"%@",[object objectForKey: @"date"]]];
            forcast.dayWeather = [WeatherFetcher extractWeather:[[object objectForKey: @"day"] firstObject]];
            forcast.dayWeather.temp =[[object objectForKey: @"day_max_temp"]  integerValue];
            forcast.dayWeather.tempUnit =[NSString stringWithFormat:@"%@",[object objectForKey: @"temp_unit"]];
            forcast.nightWeather = [WeatherFetcher extractWeather:[[object objectForKey: @"night"] firstObject]];
            forcast.nightWeather.temp =[[object objectForKey: @"night_min_temp"]  integerValue];
            forcast.nightWeather.tempUnit =[NSString stringWithFormat:@"%@",[object objectForKey: @"temp_unit"]];
            
            [forcastWeather addObject:forcast];
        }
    }
    
    
    return forcastWeather;
}


@end
