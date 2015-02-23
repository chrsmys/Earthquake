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
@property (nonatomic) MKMapType mapType;
+(CAMSettingsServices *)sharedInstance;
@end
