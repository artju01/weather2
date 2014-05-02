//
//  Weather.h
//  Weather2
//
//  Created by Kritsakorn on 5/1/14.
//  Copyright (c) 2014 Kritsakorn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Wind.h"

@interface Weather : NSObject

@property (nonatomic) NSInteger weatherCode;
@property (strong, nonatomic) NSString *weatherType;
@property (strong, nonatomic) Wind *wind;

@property (nonatomic) NSInteger humidity;
@property (nonatomic) NSInteger pressure;
@property (nonatomic) NSInteger temp;
@property (strong, nonatomic) NSString *tempUnit;

@end
