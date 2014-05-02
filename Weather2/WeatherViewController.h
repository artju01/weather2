//
//  CoreDataTableViewController.h
//  Weather2
//
//  Created by Kritsakorn on 5/1/14.
//  Copyright (c) 2014 Kritsakorn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherChannel.h"
#import "WeatherFetcher.h"
@interface WeatherViewController : UIViewController<UITableViewDataSource>

@property (strong,nonatomic) WeatherChannel* channel;
@property (nonatomic)BOOL active;
@property (nonatomic)BOOL readyToUpdate;
- (void)updateUI;

@end
