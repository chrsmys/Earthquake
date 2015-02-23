//
//  CAMEventDetailViewController.m
//  Earthquake
//
//  Created by Chris Mays on 2/20/15.
//  Copyright (c) 2015 Chris Mays. All rights reserved.
//

#import "CAMEventDetailViewController.h"
#import "CAMEventServices.h"
#import "Earthquake-Swift.h"
@interface CAMEventDetailViewController ()

@end

@implementation CAMEventDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    keyDisplayOrder = @[@"type", @"mag", @"magType", @"sig", @"status"];
}

- (void)viewWillAppear:(BOOL)animated{
    //Display the Location and Date
    self.eventName.text=[NSString stringWithFormat:@"%@ \n %@",[_currentEvent locationName],[[CAMEventServices sharedInstance] formatEventDate:[_currentEvent getTimeOfEvent]]];
}

- (void)viewDidAppear:(BOOL)animated{
    self.seismometer.magnitude=[_currentEvent getMagnitude];
   
    [self.seismometer drawPath:true];
}

- (IBAction)doneButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setCurrentEvent:(CamEvent *)currentEvent{
    _currentEvent=currentEvent;
    self.seismometer.magnitude=[currentEvent getMagnitude];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [keyDisplayOrder count];;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"EventDetailCell"];
    
    //Displays Key : Value
    cell.textLabel.text=[NSString stringWithFormat:@"%@: %@",[[_currentEvent replaceKeyWithHumanReadableKey:[keyDisplayOrder objectAtIndex:indexPath.row]] capitalizedString], [[_currentEvent featureDictionary] objectForKey:[keyDisplayOrder objectAtIndex:indexPath.row]]];
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
