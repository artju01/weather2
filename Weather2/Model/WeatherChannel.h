//
//  WeatherChanel.h
//  Weather2
//
//  Created by Kritsakorn on 5/1/14.
//  Copyright (c) 2014 Kritsakorn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Forecast.h"

@interface WeatherChannel : NSObject

@property (strong,nonatomic) NSString *zipCode;
@property (strong,nonatomic) Weather *currentWeather;
@property (strong,nonatomic) NSMutableArray *forcastWeather;


@end
