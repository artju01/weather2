//
//  weatherDetailViewController.m
//  Weather2
//
//  Created by Kritsakorn on 5/2/14.
//  Copyright (c) 2014 Kritsakorn. All rights reserved.
//

#import "weatherDetailViewController.h"
#import "IconLoader.h"

@interface weatherDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *weatherDetailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherDetailIcon;
@property (weak, nonatomic) IBOutlet UILabel *minTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *windSpeedLabel;
@property (weak, nonatomic) IBOutlet UILabel *windDirectionLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation weatherDetailViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Managing the detail item
- (void)setDetailItem:(Forecast *)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    self.navigationItem.title =  [NSString stringWithFormat:@"Date: %@",[dateFormatter stringFromDate:self.detailItem.date]];
    
    self.weatherDetailIcon.image = [[IconLoader sharedInstance] LoadDayIcon:self.detailItem.dayWeather.weatherCode];
    self.weatherDetailLabel.text = self.detailItem.dayWeather.weatherType;
    self.minTempLabel.text =  [NSString stringWithFormat:@"%ld°",(long)[self.detailItem getMinTemperature]];
    self.maxTempLabel.text =  [NSString stringWithFormat:@"%ld°",(long)[self.detailItem getMaxTemperature]];
    self.windSpeedLabel.text = [NSString stringWithFormat:@"%ld %@",
                                (long)self.detailItem.dayWeather.wind.speed,
                                self.detailItem.dayWeather.wind.windUnit];
    self.windDirectionLabel.text = [NSString stringWithFormat:@"%@  %ld°",
                                    self.detailItem.dayWeather.wind.direction,
                                    (long)self.detailItem.dayWeather.wind.directionDegree];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return 2;
    }
    return 3;
}



@end
