//
//  CAMEventServices.m
//  Earthquake
//
//  Created by Chris Mays on 2/20/15.
//  Copyright (c) 2015 Chris Mays. All rights reserved.
//

#import "CAMEventServices.h"

@implementation CAMEventServices
@synthesize eventList=_eventList;
@synthesize sharedInstance=_sharedInstance;

-(id)init{
    self=[super init];
    if(self){
        _eventList=[[NSMutableArray alloc] init];
    }
    return self;
}

-(void)setEventList:(NSMutableArray *)eventList{
    _eventList=eventList;
}

-(NSArray *)eventList{
    return _eventList;
}

#pragma mark - Shared Instance

-(CAMEventServices *)sharedInstance{
    if(!_sharedInstance){
        _sharedInstance=[[CAMEventServices alloc] init];
    }
    return _sharedInstance;
}

@end
