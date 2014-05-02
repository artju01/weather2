//
//  ImageLoader.m
//  Weather2
//
//  Created by Kritsakorn on 5/1/14.
//  Copyright (c) 2014 Kritsakorn. All rights reserved.
//

#import "IconLoader.h"

@interface IconLoader()
@property(strong, nonatomic) NSDictionary* imageDict;
@end

@implementation IconLoader

static BOOL useinside = NO;
static id _sharedObject = nil;


+(id) alloc {
    if (!useinside) {
        @throw [NSException exceptionWithName:@"Singleton Vialotaion" reason:@"You are violating the singleton class usage. Please call +sharedInstance method" userInfo:nil];
    }
    else {
        return [super alloc];
    }
}

+(id)sharedInstance
{
    static dispatch_once_t p = 0;
    
    dispatch_once(&p, ^{
        useinside = YES;
        _sharedObject = [[IconLoader alloc] init];
        
        useinside = NO;
    });
    
    // returns the same object each time
    return _sharedObject;
}


- (NSDictionary *)imageDict
{
    if(!_imageDict) {
        NSArray* rootPath = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
        
        //get document path
        NSString* documentPath = [rootPath objectAtIndex:0];
        
        //actual plist file
        NSString* plistPath = [documentPath stringByAppendingString:@"WebService_WeatherCondition"];
        
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
            //ask the app bundle for a path to player plist
            plistPath = [[NSBundle mainBundle] pathForResource:@"WebService_WeatherCondition" ofType:@"plist"];
        }
        
        _imageDict = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    }
    return _imageDict;
}

- (UIImage *)createIcon:(NSString *)imageName;
{
    return [UIImage imageNamed:imageName];
}


- (UIImage *)LoadDayIcon:(NSInteger)iconCode {
    return [self createIcon:self.imageDict[[NSString stringWithFormat:@"%ld",(long)iconCode]][@"DayIcon"]];
}

- (UIImage *)LoadNightIcon:(NSInteger)iconCode {
    return [self createIcon:self.imageDict[[NSString stringWithFormat:@"%ld",(long)iconCode]][@"NightIcon"]];
}


@end
