//
//  Wind.h
//  Weather2
//
//  Created by Kritsakorn on 5/1/14.
//  Copyright (c) 2014 Kritsakorn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Wind : NSObject
@property (strong, nonatomic) NSString *direction;
@property (nonatomic) NSInteger directionDegree;
@property (nonatomic) NSInteger speed;
@property (strong, nonatomic) NSString *windUnit;
@end
