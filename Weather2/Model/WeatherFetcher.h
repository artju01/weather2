//
//  WeatherFetcher.h
//  Weather2
//
//  Created by Kritsakorn on 5/1/14.
//  Copyright (c) 2014 Kritsakorn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherChannel.h"
@interface WeatherFetcher : NSObject


+ (WeatherChannel *) CreateWeatherChannel:(NSString *)zipCode;

@end
