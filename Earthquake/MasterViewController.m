//
//  ViewController.m
//  Earthquake
//
//  Created by Chris Mays on 2/20/15.
//  Copyright (c) 2015 Chris Mays. All rights reserved.
//

#import "MasterViewController.h"
#import "CAMEventServices.h"
#import "CamEvent.h"
#import "CAMMapViewController.h"
#import "Earthquake-Swift.h"
@interface MasterViewController ()

//determines whether Master is displayed in compact enviornment
@property (nonatomic) BOOL collapseSecondaryViewOnPrimary;

@end

@implementation MasterViewController

- (void)viewDidLoad {
    self.navigationController.view.tintColor=[UIColor redColor];

    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.splitViewController.delegate=self;
    [self setCollapseSecondaryViewOnPrimary:true];
    self.clearsSelectionOnViewWillAppear=NO;
    self.eventList = [NSArray array];
    
    [self subscribeToNotifications];
    [[CAMEventServices sharedInstance] refreshEvents];
    
    emptyDataSource = [[EmptyMasterViewControllerDataSource alloc] init];
    
    [super viewDidLoad];
}

#pragma mark - Notification subsctiptions

/*
    Subscribe to all notifications that self would should be aware of
 */
- (void)subscribeToNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleEventListChange) name:@"eventListChanged" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNetworkError) name:@"ErrorRetrievingEvents" object:nil];
    
}

/*
 Subscribe to all notifications that self would should be aware of
 */
- (void)unsubscribeToNotifications{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - EventServices Notifications

/*
    Handles cleanup when event list changes
 */
-(void)handleEventListChange{
    self.eventList = [[NSArray alloc] initWithArray:[[CAMEventServices sharedInstance] eventList] copyItems:NO];
   
    if ([self.eventList count]>0) {
        //Replace delegate with self
        self.tableView.dataSource=self;
        self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    }else{
        //Replace delegate with one that will display empty results
        self.tableView.dataSource=emptyDataSource;
        self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    }
    
    [self.tableView reloadData];
}

/*
    Notifies user when there is a network error
 */
-(void)handleNetworkError{
    UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Error Retrieving Events" message:@"Please verify you are connected to the internet" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

#pragma mark - TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.eventList count];
}


- (CGFloat)tableView:(UITableView *)tableView
estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView.dataSource isEqual:emptyDataSource]) {
        return 400;
    }
    return 64;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView.dataSource isEqual:emptyDataSource]) {
        return 400;
    }
    return 64;
}


 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
     //Create custom cell inside of Main.storyboard
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventCell" forIndexPath:indexPath];
 
     CamEvent *currentEvent = [self.eventList objectAtIndex:indexPath.row];
     
     //Create a selection view that conforms to tint color
     UIView *backgroundColorView = [[UIView alloc] init];
     backgroundColorView.backgroundColor=self.view.window.tintColor;
     cell.selectedBackgroundView=backgroundColorView;
     
     //Retrieve labels from custom cell
     UILabel *textLabel=(UILabel *)[cell viewWithTag:1];
     UILabel *detailLabel=(UILabel *)[cell viewWithTag:2];
     UILabel *rightDetailLabel=(UILabel *)[cell viewWithTag:3];
     
     //Set text labels accordingly
     textLabel.text=[currentEvent locationName];
     rightDetailLabel.text=[NSString stringWithFormat:@"Magnitude: %.2f",[currentEvent getMagnitude]];
     detailLabel.text=[[CAMEventServices sharedInstance] formatEventDate:[currentEvent getTimeOfEvent]];
     
     return cell;
 }


#pragma mark - SplitViewController Delegate

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController{
    
    //If there is a selection then the splitview controller should
    //show the detail view
    if ([self.tableView indexPathForSelectedRow]!=nil) {
        return !self.collapseSecondaryViewOnPrimary;
    }
    
    //Else show the master
    return self.collapseSecondaryViewOnPrimary;
}

#pragma mark - NAVIGATION
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"MoveToMapDetailView"]) {
        id tempDestination = segue.destinationViewController;
        
        //Handle the case where MapViewController could be in a navigation controller
        if([segue.destinationViewController isKindOfClass:[UINavigationController class]]){
            tempDestination = [(UINavigationController *)tempDestination topViewController];
        }
        
        //Insert the selected event into the eventlist
        CAMMapViewController *destination = tempDestination;
        CamEvent *selectedEvent = [_eventList objectAtIndex:[self.tableView indexPathForSelectedRow].row];
        [destination setEventList:@[selectedEvent]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
