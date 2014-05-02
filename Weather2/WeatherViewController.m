//
//  CoreDataTableViewController.m
//  Weather2
//
//  Created by Kritsakorn on 5/1/14.
//  Copyright (c) 2014 Kritsakorn. All rights reserved.
//

#import "WeatherViewController.h"
#import "weatherDetailViewController.h"
#import "IconLoader.h"

@interface WeatherViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

//Back UILabel
@property (weak, nonatomic) IBOutlet UILabel *humidityLabel;
@property (weak, nonatomic) IBOutlet UILabel *pressureLabel;
@property (weak, nonatomic) IBOutlet UILabel *windLabel;
- (IBAction)swapDetailButton:(UIButton *)sender;

//Front UILabel
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;

@end


@implementation WeatherViewController

- (WeatherChannel *)channel
{
    if(!_channel) {
        _channel = [WeatherFetcher CreateWeatherChannel:@"97006"];
        [self updateUI];
    }
    return _channel;
}

#define UPDATE_WEATHER_TIME_COUNT 1800

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super init];
    if (self) {
        //do init
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    //remove the gap between the first cell in table view and table view title
    self.tableView.contentInset = UIEdgeInsetsMake(-50, 0, 0, 0);
    
    //set default text for search box
    self.searchBar.placeholder = @"Enter zip code";
    
    self.active = YES;
    self.readyToUpdate = NO;
    
    
    // update weather every 30 minutes
    [NSTimer scheduledTimerWithTimeInterval:UPDATE_WEATHER_TIME_COUNT
                                     target:self
                                   selector:@selector(timeEnd)
                                   userInfo:nil
                                    repeats:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(handleEnterForeground:)
                                                 name: @"UIApplicationWillEnterForegroundNotification"
                                               object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(handleEnterBackground:)
                                                 name: @"UIApplicationWillEnterBackgroundNotification"
                                               object: nil];
    
}



#pragma mark - updateUI

- (void)updateUI
{
    [self updateDetailUI];
    [self updateFrontUI];
    [self.tableView reloadData];
}

//This update UI for temperature and location;
- (void) updateFrontUI
{
    self.locationLabel.text = [NSString stringWithFormat:@"Location: %@",self.channel.zipCode];
    self.descriptionLabel.text = self.channel.currentWeather.weatherType;
    self.tempLabel.text= [NSString stringWithFormat:@" %ld°",(long)self.channel.currentWeather.temp];
}


//This update the UI in the back. Including humidity, wind and direction
- (void)updateDetailUI
{
    NSString *temp = [[NSString stringWithFormat:@"Humidity"] stringByPaddingToLength:20
                                                                           withString:@" "
                                                                      startingAtIndex:0];
    self.humidityLabel.text = [NSString stringWithFormat:@"%@%ld",temp,(long)self.channel.currentWeather.humidity];
    
    
    temp = [[NSString stringWithFormat:@"Pressure"] stringByPaddingToLength:20
                                                                 withString:@" "
                                                            startingAtIndex:0];
    self.pressureLabel.text = [NSString stringWithFormat:@"%@%ld",temp,(long)self.channel.currentWeather.pressure];
    
    
    temp = [[NSString stringWithFormat:@"Wind %@",self.channel.currentWeather.wind.direction]
            stringByPaddingToLength:20
            withString:@" "
            startingAtIndex:0];
    
    self.windLabel.text = [NSString stringWithFormat:@"%@%ld %@",temp,
                           (long)self.channel.currentWeather.wind.speed,
                           self.channel.currentWeather.wind.windUnit];

}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.channel.forcastWeather count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    Forecast *forcast = self.channel.forcastWeather[indexPath.row];
    cell.textLabel.text =  [Forecast getDayOfTheWeek:forcast.date];
    
    UILabel *maxTempLabel = (UILabel *)[cell viewWithTag:100];
    maxTempLabel.text = [NSString stringWithFormat:@"%ld°",(long)[forcast getMaxTemperature]];
    UILabel *minTempLabel = (UILabel *)[cell viewWithTag:101];
    minTempLabel.text = [NSString stringWithFormat:@"%ld°",(long)[forcast getMinTemperature]];
    
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:99];
    imageView.image = [[IconLoader sharedInstance] LoadDayIcon:forcast.dayWeather.weatherCode];

    imageView.animationRepeatCount = 5;
    [imageView startAnimating];
    
    [[cell contentView] addSubview:imageView];
    [[cell contentView] addSubview:maxTempLabel];
    [[cell contentView] addSubview:minTempLabel];
    
    
    return cell;
}


#pragma mark - searchBar delegate and filltering method
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Search Clicked");
  
    
    if (self.channel.zipCode != searchBar.text) {
        WeatherChannel *newChannel = [WeatherFetcher CreateWeatherChannel:searchBar.text];
        if (newChannel) {
            // create new weather channel
            self.channel = newChannel;
            [self updateUI];
        }
        else {
            //Can't find a new location
            //Show alert box
            NSString *alertText = [NSString stringWithFormat:@"There is no location: %@",searchBar.text];
            UIAlertView * alert  = [[UIAlertView alloc] initWithTitle:@"Location not found"
                                                              message:alertText
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil ];
            [alert show];
        }
    }
    
    //dissmiss keyboard
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Cancel clicked");
    
    //dissmiss keyboard
    [searchBar resignFirstResponder];
}


 #pragma mark - Navigation
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
     //send forecast detail to detailView
     if ([[segue identifier] isEqualToString:@"forecastDetail"]) {
         NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
         [[segue destinationViewController] setDetailItem:self.channel.forcastWeather[indexPath.row]];
     }

 }


#pragma mark - Check update for weather
- (void)handleEnterBackground:id
{
    NSLog(@"Goodbye");
    self.active = NO;
    [self checkUpdate];
}

- (void)handleEnterForeground:id
{
    NSLog(@"Hello");
    self.active = YES;
}

-(void)timeEnd {
    self.readyToUpdate = YES;
    [self checkUpdate];
}

- (void) checkUpdate
{
    if (self.readyToUpdate && self.active) {
        WeatherChannel *newChannel = [WeatherFetcher CreateWeatherChannel:self.channel.zipCode];
        if(newChannel) {
            NSLog(@"update wather");
            self.channel = newChannel;
            [self updateUI];
        }
    }
}



//Swap UI between current temperature and current detail
- (IBAction)swapDetailButton:(UIButton *)sender {
    [self changeUIState];
}

//swap UI between Current temperature and others (humidity, wind, direction)
- (void)changeUIState
{
    //front UI
    self.locationLabel.hidden = !self.locationLabel.hidden;
    self.descriptionLabel.hidden = !self.descriptionLabel.hidden;
    self.tempLabel.hidden = !self.tempLabel.hidden;
    
    //back UI
    self.humidityLabel.hidden = !self.humidityLabel.hidden;
    self.pressureLabel.hidden = !self.pressureLabel.hidden;
    self.windLabel.hidden = !self.windLabel.hidden;
}
@end
