//
//  CamEvent.h
//  Earthquake
//
//  Created by Chris Mays on 2/20/15.
//  Copyright (c) 2015 Chris Mays. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CamEvent : NSObject

-(id)initWithFeatureObject:(NSDictionary *)feature;
-(NSNumber *)getLongitude;
-(NSNumber *)getLatitude;

@property (nonatomic, retain) NSMutableDictionary *featureDictionary;


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
