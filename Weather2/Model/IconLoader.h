//
//  ImageLoader.h
//  Weather2
//
//  Created by Kritsakorn on 5/1/14.
//  Copyright (c) 2014 Kritsakorn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IconLoader : NSObject

+(id)sharedInstance;

-(UIImage *)LoadDayIcon:(NSInteger)iconCode;
-(UIImage *)LoadNightIcon:(NSInteger)iconCode;

@end
