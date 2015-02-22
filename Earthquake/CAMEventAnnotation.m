//
//  CAMEventAnnotation.m
//  Earthquake
//
//  Created by Chris Mays on 2/21/15.
//  Copyright (c) 2015 Chris Mays. All rights reserved.
//

#import "CAMEventAnnotation.h"
#import "CamEvent.h"
#import "CAMEventServices.h"
@implementation CAMEventAnnotation
- (id)initWithLocation:(CLLocationCoordinate2D)coord{
    self =[super init];
    if (self) {
        _coordinate=coord;
    }
    return self;
}

- (id)initWithCamEvent:(CamEvent *)event{
    
    self =[super init];
    if (self) {
        NSDate *eventDate = [event getTimeOfEvent];
        NSString *dateString = [[CAMEventServices sharedInstance] formatEventDate:eventDate];
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake((CLLocationDegrees)[[event getLatitude] doubleValue], (CLLocationDegrees)[[event getLongitude] doubleValue]);
        _title=[event locationName]?: @"";
        _subtitle =dateString;
        [self commonInit:coord];
    }
    return self;

}

- (void)commonInit:(CLLocationCoordinate2D)coord{
    _coordinate=coord;
}

@end
