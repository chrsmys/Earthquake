//
//  ViewController.h
//  Earthquake
//
//  Created by Chris Mays on 2/20/15.
//  Copyright (c) 2015 Chris Mays. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EmptyMasterViewControllerDataSource;

@interface MasterViewController : UITableViewController<UISplitViewControllerDelegate, UITableViewDelegate, UITableViewDataSource>{
    EmptyMasterViewControllerDataSource *emptyDataSource; //Handles the empty data set
}

@property(nonatomic, retain) NSArray *eventList; //List of events to display in the tableview

@end

