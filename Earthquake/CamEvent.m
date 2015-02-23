//
//  CamEvent.m
//  Earthquake
//
//  Created by Chris Mays on 2/20/15.
//  Copyright (c) 2015 Chris Mays. All rights reserved.
//

#import "CamEvent.h"
#import "NSDictionary+Constructors.h"
#import "CAMEventServices.h"
@implementation CamEvent
- (id)initWithFeatureObject:(NSDictionary *)feature{
    self = [super init];
    
    //Create a list of human readble keys key= api key value = human readbale keys
    humanReadableKeys = @{@"mag" : @"Magnitude", @"sig" : @"Significance", @"magType" : @"Magnitude Type"};
    
    if (self){

        //Validate Object
        if (![feature objectForKey:@"type"] || ![[feature objectForKey:@"type"] isEqualToString:@"Feature"] || ![feature objectForKey:@"properties"] || ! [feature objectForKey:@"id"]) {
            return nil;
        }
        
        //Insert Properties into featureDictionary
        self.featureDictionary = [[NSMutableDictionary alloc] initWithDictionary:[feature objectForKey:@"properties"]];
        
        //Add The ID
        [self.featureDictionary  setObject:[feature objectForKey:@"id"] forKey:@"id"];
        
        //Extract the Latitude, Longitude, and Depth and insert it into the feature dictionary
        NSDictionary *geometryDictionary = [feature objectForKey:@"geometry"];
        if([[geometryDictionary objectForKey:@"type"] isEqualToString:@"Point"]){
            NSArray *coordinatesArray = [geometryDictionary objectForKey:@"coordinates"];
            if([coordinatesArray count]>2){
                NSNumber *longitude = [coordinatesArray objectAtIndex:0];
                NSNumber *latitude = [coordinatesArray objectAtIndex:1];
                NSNumber *depth = [coordinatesArray objectAtIndex:2];
                [self.featureDictionary setObject:latitude forKey:@"latitude"];
                [self.featureDictionary setObject:longitude forKey:@"longitude"];
                [self.featureDictionary setObject:depth forKey:@"depth"];
            }
        }
        
        //Remove all instances of NSNull from list
        self.featureDictionary = [[NSMutableDictionary alloc] initWithDictionary:[self.featureDictionary dictionaryByReplacingNSNullWithString]];
        
    }
    return self;
}

- (NSNumber *)getLongitude{
    return [self.featureDictionary objectForKey:@"longitude"];
}

- (NSNumber *)getLatitude{
    return [self.featureDictionary objectForKey:@"latitude"];
}

- (NSDate *)getTimeOfEvent{
    
    if(![self.featureDictionary objectForKey:@"time"]){
        return nil;
    }
   
    NSNumber *time = [self.featureDictionary objectForKey:@"time"];
    
    //Must convert time to seconds
    long long timeInterval = [time longLongValue] / 1000;
    
    return [NSDate dateWithTimeIntervalSince1970:timeInterval];
}

- (NSString *)getEventID{
    return [self.featureDictionary objectForKey:@"id"] ?: @"Undefined";
}

- (NSString *)locationName{
    return [self.featureDictionary objectForKey:@"place"] ?: @"Undefined";
}

- (NSString *)alertLevel{
    return [self.featureDictionary objectForKey:@"alert"] ?: @"Undefined";
}

- (double)getMagnitude{
    return [[self.featureDictionary objectForKey:@"mag"] doubleValue];
}

#pragma mark - Equal Overides

- (BOOL)isEqual:(id)object{
    if (![object isKindOfClass:[self class]]) {
        return false;
    }
    CamEvent *other =(CamEvent *)object;
    
    return [[other getEventID] isEqualToString:[self getEventID]];
}

- (NSUInteger)hash{
    return [[self getEventID] hash];
}

#pragma mark - MKAnnotation Protocol

- (NSString *)title{
    return [self locationName];
}

- (NSString *)subtitle{
    NSDate *eventDate = [self getTimeOfEvent];
    NSString *dateString = [[CAMEventServices sharedInstance] formatEventDate:eventDate];

    return dateString;
}

- (CLLocationCoordinate2D)coordinate{
    return  CLLocationCoordinate2DMake((CLLocationDegrees)[[self getLatitude] doubleValue], (CLLocationDegrees)[[self getLongitude] doubleValue]);
}

#pragma mark - Helper Methods

- (NSString *)replaceKeyWithHumanReadableKey:(NSString *)key{
    if ([humanReadableKeys objectForKey:key]) {
        return [humanReadableKeys objectForKey:key];
    }
    return key;
}

@end
