//
//  CamEvent.h
//  Earthquake
//
//  Created by Chris Mays on 2/20/15.
//  Copyright (c) 2015 Chris Mays. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface CamEvent : NSObject <MKAnnotation>{
    NSDictionary *humanReadableKeys;
}

- (id)initWithFeatureObject:(NSDictionary *)feature;

- (NSString *)locationName;
- (NSString *)alertLevel;
- (NSString *)getEventID;
- (NSNumber *)getLongitude;
- (NSNumber *)getLatitude; 
- (double)getMagnitude;
- (NSDate *)getTimeOfEvent; //Returns the date the event occured

- (NSString *)replaceKeyWithHumanReadableKey:(NSString *)key; //Replaces api keys with more readble keys

@property (nonatomic, retain) NSMutableDictionary *featureDictionary; //This holds all of the event values

//MKAnnotation Protocol
- (id)initWithLocation:(CLLocationCoordinate2D)coord;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;

@end
