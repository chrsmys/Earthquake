//
//  CAMSettingsServices.m
//  Earthquake
//
//  Created by Chris Mays on 2/20/15.
//  Copyright (c) 2015 Chris Mays. All rights reserved.
//

#import "CAMSettingsServices.h"

@implementation CAMSettingsServices
static CAMSettingsServices *sharedInstance;

#pragma mark - Shared Instance

+(CAMSettingsServices *)sharedInstance{
    if(!sharedInstance){
        sharedInstance=[[CAMSettingsServices alloc] init];
    }
    return sharedInstance;
}

@end
