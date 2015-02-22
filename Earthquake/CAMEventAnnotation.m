//
//  CAMEventAnnotation.m
//  Earthquake
//
//  Created by Chris Mays on 2/21/15.
//  Copyright (c) 2015 Chris Mays. All rights reserved.
//

#import "CAMEventAnnotation.h"
#import "CamEvent.h"
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
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake((CLLocationDegrees)[[event getLatitude] doubleValue], (CLLocationDegrees)[[event getLongitude] doubleValue]);
        _title=[event locationName]?: @"";
        _subtitle =[event alertLevel];
        [self commonInit:coord];
    }
    return self;

}

- (void)commonInit:(CLLocationCoordinate2D)coord{
    _coordinate=coord;
}

@end
