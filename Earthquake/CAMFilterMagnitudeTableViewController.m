//
//  CAMFilterMagnitudeTableViewController.m
//  Earthquake
//
//  Created by Chris Mays on 2/23/15.
//  Copyright (c) 2015 Chris Mays. All rights reserved.
//

#import "CAMFilterMagnitudeTableViewController.h"
#import "CAMSettingsServices.h"
@interface CAMFilterMagnitudeTableViewController ()

@end

@implementation CAMFilterMagnitudeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[CAMSettingsServices sharedInstance] currentMagnitudeFilter]==indexPath.row) {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //Set the magnitude filter and reload data to display proper selection
    [[CAMSettingsServices sharedInstance] setCurrentMagnitudeFilter:(int)indexPath.row];
    [self.tableView reloadData];
}

@end
