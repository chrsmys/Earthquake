//
//  CAMEventAnnotation.h
//  Earthquake
//
//  Created by Chris Mays on 2/21/15.
//  Copyright (c) 2015 Chris Mays. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@class CamEvent;

@interface CAMEventAnnotation : NSObject<MKAnnotation>

- (id)initWithLocation:(CLLocationCoordinate2D)coord;
- (id)initWithCamEvent:(CamEvent *)event;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;
@end
