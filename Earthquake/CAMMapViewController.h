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
@property (weak, nonatomic) IBOutlet UIBarButtonItem *settingsButton;
@property (weak, nonatomic) IBOutlet MKMapView *eventMapView;
@property (nonatomic, strong) NSArray *eventList;
@end
