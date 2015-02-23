//
//  CAMSettingsServices.h
//  Earthquake
//
//  Created by Chris Mays on 2/20/15.
//  Copyright (c) 2015 Chris Mays. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface CAMSettingsServices : NSObject
@property (nonatomic) MKMapType mapType; //The current type of the map saved in settings
@property (nonatomic) int currentMagnitudeFilter; //All magnitudes should be greater than this number
+ (CAMSettingsServices *)sharedInstance;
@end
