//
//  CAMEventServices.m
//  Earthquake
//
//  Created by Chris Mays on 2/20/15.
//  Copyright (c) 2015 Chris Mays. All rights reserved.
//

#import "CAMEventServices.h"
#import "NSDateFormatter+Constructors.h"

@implementation CAMEventServices{
    
}
@synthesize eventList=_eventList;
@synthesize sharedInstance=_sharedInstance;

 NSString *const apiURL = @"http://comcat.cr.usgs.gov/fdsnws/event/1/query";

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

/*
    Starts Process of Refreshing the Events List
 
    Note: This will load new events and update current events
 */
-(void)refreshEvents{
    NSString *query;
    
    if (!lastRefreshDate){
        //Get initial event load
        query = [self constructQueryWithOptions:@{@"format" : @"geojson", @"limit" : @"20", @"orderby" : @"time"}];
        lastRefreshDate = [NSDate date];
    }else{
        //Get results for events that happened after lastRefresh
        query = [self constructQueryWithOptions:@{@"format" : @"geojson", @"updatedafter" : [self ISO8601StringFromDate:lastRefreshDate] }];
    }
    
    [self performQuery:query];
}

/* 
    Performs the query and retrieves the results
 */
-(void)performQuery:(NSString *)query{
    NSURL *queryURL = [NSURL URLWithString:query];
    
    NSURLSessionDataTask *data = [[NSURLSession sharedSession] dataTaskWithURL:queryURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        }
        else{
            
        }
    }];
    [data resume];
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

#pragma mark - Shared Instance

-(CAMEventServices *)sharedInstance{
    if(!_sharedInstance){
        _sharedInstance=[[CAMEventServices alloc] init];
    }
    return _sharedInstance;
}

@end
