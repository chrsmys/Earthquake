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
@interface MasterViewController ()

//determines whether Master is displayed in compact enviornment
@property (nonatomic) BOOL collapseSecondaryViewOnPrimary;

@end

@implementation MasterViewController

- (void)viewDidLoad {
    self.navigationController.view.tintColor=[UIColor redColor];

    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.navigationController.view setTintColor:[UIColor redColor]];
    self.splitViewController.delegate=self;
    [self setCollapseSecondaryViewOnPrimary:true];

    self.eventList = [NSArray array];
    
    [self subscribeToNotifications];
    [[CAMEventServices sharedInstance] refreshEvents];
    
    [super viewDidLoad];
}

-(void)subscribeToNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleEventListChange) name:@"eventListChanged" object:nil];
}
-(void)unsubscribeToNotifications{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)handleEventListChange{
    self.eventList = [[NSArray alloc] initWithArray:[[CAMEventServices sharedInstance] eventList] copyItems:NO];
    [self.tableView reloadData];
}

#pragma mark - TableView Delegate



#pragma mark - TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.eventList count];
}


- (CGFloat)tableView:(UITableView *)tableView
estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}


 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventCell" forIndexPath:indexPath];
 
     CamEvent *currentEvent = [self.eventList objectAtIndex:indexPath.row];
     cell.textLabel.text=[currentEvent locationName];
     cell.detailTextLabel.text=[currentEvent alertLevel];
     return cell;
 }


#pragma mark - SplitViewController Delegate

-(BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController{
    return self.collapseSecondaryViewOnPrimary;
}

#pragma mark - NAVIGATION
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"MoveToMapDetailView"]) {
        id tempDestination = segue.destinationViewController;
        if([segue.destinationViewController isKindOfClass:[UINavigationController class]]){
            tempDestination = [(UINavigationController *)tempDestination topViewController];
        }
        
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
