//
//  CAMMapViewController.h
//  Earthquake
//
//  Created by Chris Mays on 2/20/15.
//  Copyright (c) 2015 Chris Mays. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "CamEvent.h"
@interface CAMMapViewController : UIViewController <MKMapViewDelegate>{
    __weak CamEvent *recentlySelectedEvent;
}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *settingsButton; //The button displayed in the navigation bar
@property (weak, nonatomic) IBOutlet MKMapView *eventMapView; // Map that displays the event annotations
@property (nonatomic, strong) NSArray *eventList; //The list of events that should be displayed in the map
@end
