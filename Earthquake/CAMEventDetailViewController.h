//
//  CAMEventDetailViewController.h
//  Earthquake
//
//  Created by Chris Mays on 2/20/15.
//  Copyright (c) 2015 Chris Mays. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CamEvent.h"
@class CAMSeismograph;

@interface CAMEventDetailViewController : UITableViewController{
    NSArray *keyDisplayOrder; //The order in which the values are displayed
}

@property (weak, nonatomic) IBOutlet UILabel *eventName;
@property (strong, nonatomic) CamEvent *currentEvent;
@property (weak, nonatomic) IBOutlet CAMSeismograph *seismometer;
- (IBAction)doneButtonPressed:(id)sender;

@end
