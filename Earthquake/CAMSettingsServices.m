//
//  CAMSettingsServices.m
//  Earthquake
//
//  Created by Chris Mays on 2/20/15.
//  Copyright (c) 2015 Chris Mays. All rights reserved.
//

#import "CAMSettingsServices.h"

@implementation CAMSettingsServices
@synthesize mapType=_mapType;
static CAMSettingsServices *sharedInstance;

/**
    Sets and saves the current maptype
 */
- (void)setMapType:(MKMapType)mapType{
    [[self standardDefaults] setObject:[NSNumber numberWithInt:mapType] forKey:@"MapType"];
    [[self standardDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MapTypeChanged" object:nil];
}

- (MKMapType)mapType{
    if([[self standardDefaults] objectForKey:@"MapType"]){
        return [[[self standardDefaults] objectForKey:@"MapType"] intValue];
    }else{
        return MKMapTypeStandard;
    }
}


- (int)currentMagnitudeFilter{
    if([[self standardDefaults] objectForKey:@"MagnitudeFilter"]){
        return [[[self standardDefaults] objectForKey:@"MagnitudeFilter"] intValue];
    }else{
        return 0;
    }
}

/**
    Sets and saves the current magnitude filter
 */
- (void)setCurrentMagnitudeFilter:(int)currentMagnitudeFilter{
    //keep it within bounds
    int magnitude = MIN(9, MAX(currentMagnitudeFilter, 0));
    
    [[self standardDefaults] setObject:[NSNumber numberWithInt:magnitude] forKey:@"MagnitudeFilter"];
    [[self standardDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MagnitudeFilterChanged" object:nil];
}

#pragma mark - helper methods

- (NSUserDefaults *)standardDefaults{
    return [NSUserDefaults standardUserDefaults];
}

#pragma mark - Shared Instance

+ (CAMSettingsServices *)sharedInstance{
    if(!sharedInstance){
        sharedInstance=[[CAMSettingsServices alloc] init];
    }
    return sharedInstance;
}

@end
