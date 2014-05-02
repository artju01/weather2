//
//  weatherDetailViewController.h
//  Weather2
//
//  Created by Kritsakorn on 5/2/14.
//  Copyright (c) 2014 Kritsakorn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Forecast.h"

@interface weatherDetailViewController : UITableViewController
@property (strong, nonatomic) Forecast* detailItem;
@end
