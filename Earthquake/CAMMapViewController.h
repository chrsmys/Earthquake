//
//  CAMMapViewController.h
//  Earthquake
//
//  Created by Chris Mays on 2/20/15.
//  Copyright (c) 2015 Chris Mays. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface CAMMapViewController : UIViewController
@property (weak, nonatomic) IBOutlet MKMapView *eventMapView;

@end
