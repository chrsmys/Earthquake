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

-(id)initWithFeatureObject:(NSDictionary *)feature;

-(NSString *)locationName;
-(NSString *)alertLevel;
-(NSString *)getEventID;
-(NSNumber *)getLongitude;
-(NSNumber *)getLatitude;
-(NSDate *)getTimeOfEvent; //Returns the date the event occured
-(double)getMagnitude;
-(NSString *)replaceKeyWithHumanReadableKey:(NSString *)key;

@property (nonatomic, retain) NSMutableDictionary *featureDictionary;

//MKAnnotation
- (id)initWithLocation:(CLLocationCoordinate2D)coord;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;


/*
@property (nonatomic, retain) NSString *magnitudeType; //Measurement that magnitude is in
@property (nonatomic) double magnitude;

@property (nonatomic) double intensity;

@property (nonatomic) double latitude;
@property (nonatomic) double longitude;

@property (nonatomic) long totalStationsReported;

@property (nonatomic, retain) NSString *place;

@property (nonatomic) int signifigance;

@property (nonatomic, retain) NSString *status;

@property (nonatomic) long long time;

@property (nonatomic, retain) NSString *type;

@property (nonatomic, retain) NSURL *url;

@property (nonatomic) int timezone;
 */

@end
