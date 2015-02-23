//
//  CAMSettingsTableViewController.m
//  Earthquake
//
//  Created by Chris Mays on 2/20/15.
//  Copyright (c) 2015 Chris Mays. All rights reserved.
//

#import "CAMSettingsTableViewController.h"
#import "CAMSettingsServices.h"

@interface CAMSettingsTableViewController ()

@end

@implementation CAMSettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
    switch ([[CAMSettingsServices sharedInstance] mapType]) {
        case MKMapTypeStandard:
            self.mapTypeSegmentedControl.selectedSegmentIndex=0;
            break;
        case MKMapTypeHybrid:
            self.mapTypeSegmentedControl.selectedSegmentIndex=1;
            break;
        case MKMapTypeSatellite:
            self.mapTypeSegmentedControl.selectedSegmentIndex=2;
            break;
        default:
            break;
    }
}

#pragma mark - Actions

- (IBAction)doneButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//Sets the current maptype in settings based on senders selected index
- (IBAction)mapTypeChanged:(UISegmentedControl *)sender {
    MKMapType mapType;
    switch (sender.selectedSegmentIndex) {
        case 1:
            mapType = MKMapTypeHybrid;
            break;
        case 2:
            mapType = MKMapTypeSatellite;
            break;
        default:
            mapType = MKMapTypeStandard;
            break;
    }
    [[CAMSettingsServices sharedInstance] setMapType:mapType];
}

#pragma MARK - TableView DataSource
- (CGFloat)tableView:(UITableView *)tableView
estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
