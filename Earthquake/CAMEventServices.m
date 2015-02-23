//
//  CAMEventServices.m
//  Earthquake
//
//  Created by Chris Mays on 2/20/15.
//  Copyright (c) 2015 Chris Mays. All rights reserved.
//

#import "CAMEventServices.h"
#import "CAMSettingsServices.h"
#import "NSDateFormatter+Constructors.h"
#import "CamEvent.h"
@implementation CAMEventServices{
    
}
@synthesize eventList=_eventList;

static CAMEventServices *sharedInstance;

 NSString *const apiURL = @"http://comcat.cr.usgs.gov/fdsnws/event/1/query";

-(id)init{
    self=[super init];
    if(self){
        _eventList=[[NSMutableArray alloc] init];
        eventListUnordered = false; //An empty eventlist is ordered
        requiresHardRefresh=false;
        [self subscribeToEvents];
    }
    return self;
}

-(void)subscribeToEvents{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changedMagFilter) name:@"MagnitudeFilterChanged" object:nil];
}
-(void)setEventList:(NSMutableArray *)eventList{
    _eventList=eventList;
}

-(NSArray *)eventList{
    if(eventListUnordered){
        _eventList =[NSMutableArray arrayWithArray:[_eventList sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
            NSDate *firstDate = [(CamEvent*)a getTimeOfEvent];
            NSDate *secondDate = [(CamEvent*)b getTimeOfEvent];
            return [secondDate compare:firstDate];
        }]];
    }
    return _eventList;
}


#pragma mark - CAMEvent Retrieval
-(void)changedMagFilter{
    requiresHardRefresh=true;
    lastRefreshDate=nil; //Clear refresh date because we are getting new data
    [self refreshEvents];
}
/*
    Starts Process of Refreshing the Events List
 
    Note: This will load new events and update current events
 */
-(void)refreshEvents{
    NSString *query;
    NSString *minMagnitude = [NSString stringWithFormat:@"%d", [[CAMSettingsServices sharedInstance] currentMagnitudeFilter]];
    if (!lastRefreshDate){
        //Get initial event load
        query = [self constructQueryWithOptions:@{@"format" : @"geojson", @"limit" : @"20", @"orderby" : @"time", @"eventtype" : @"earthquake", @"minmagnitude" : minMagnitude }];
        lastRefreshDate = [NSDate date];
    }else{
        //Get results for events that happened after lastRefresh
        query = [self constructQueryWithOptions:@{@"format" : @"geojson", @"updatedafter" : [self ISO8601StringFromDate:lastRefreshDate], @"orderby" : @"time", @"eventtype" : @"earthquake", @"minmagnitude" : minMagnitude}];
    }
    
    [self performQuery:query];
}


/* 
    Performs the query and retrieves the results
 */
-(void)performQuery:(NSString *)query{
    NSURL *queryURL = [NSURL URLWithString:query];
    __weak CAMEventServices *weakself = self;
    __weak NSNotificationCenter *weaknotificationCenter = [NSNotificationCenter defaultCenter];
    NSURLSessionDataTask *data = [[NSURLSession sharedSession] dataTaskWithURL:queryURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            if ([dictionary objectForKey:@"features"]) {
                [weakself performSelectorOnMainThread:@selector(processEvents:) withObject:[dictionary objectForKey:@"features"] waitUntilDone:false];
            }
        }
        else{
            [weaknotificationCenter postNotificationName:@"ErrorRetrievingEvents" object:nil];
        }
    }];
    [data resume];
}

-(void)processEvents:(NSArray *)events{
    if(requiresHardRefresh){
        _eventList=[[NSMutableArray alloc] init];
        requiresHardRefresh=false;
    }
    
    BOOL eventListUpdated = false;
    for (NSDictionary *eventData in events) {
        CamEvent *event = [[CamEvent alloc] initWithFeatureObject:eventData];
        if (![_eventList containsObject:event]) {
            //Add the new event to the list 
            [_eventList addObject:event];
            eventListUnordered=true;
        }else{
            //Replace the potentially updated event and place it in
            //The current location
            NSUInteger index = [_eventList indexOfObject:event];
            [_eventList removeObjectAtIndex:index];
            [_eventList insertObject:event atIndex:index];
        }
        eventListUpdated = true;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"eventListChanged" object:nil];
    
}

#pragma mark - Helper Methods

/*
    Constructs a query based on the options given
    and returns the query in the form of a string
 
    For list of query options refer to: 
    http://comcat.cr.usgs.gov/fdsnws/event/1/application.wadl
 */
-(NSString *)constructQueryWithOptions:(NSDictionary *)options{
    NSArray *keys=[options allKeys];
    NSMutableString *query=[NSMutableString stringWithString:apiURL];
    [query appendString:@"?"];
    for (int i=0; i<[options count]; i++) {
        NSString *key = [keys objectAtIndex:i];
        NSString *value = [options objectForKey:key];
        [query appendString:key];
        [query appendString:@"="];
        [query appendString:value];
        
        if(i+1 < [options count]){
            [query appendString:@"&"];
        }
    }
    
    return query;
}

-(NSString *)ISO8601StringFromDate:(NSDate *)date{
    NSDateFormatter *isoFormatter = [NSDateFormatter ISO8601Formatter];
    return [isoFormatter stringFromDate:date];
}

-(NSString *)formatEventDate:(NSDate *)date{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    return [formatter stringFromDate:date];
}
#pragma mark - Shared Instance

+(CAMEventServices *)sharedInstance{
    if(!sharedInstance){
        sharedInstance=[[CAMEventServices alloc] init];
    }
    return sharedInstance;
}

@end
