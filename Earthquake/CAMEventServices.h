//
//  CAMEventServices.h
//  Earthquake
//
//  Created by Chris Mays on 2/20/15.
//  Copyright (c) 2015 Chris Mays. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CAMEventServices : NSObject{
    NSDate *lastRefreshDate; //Specifies when the data was last refreshed
    BOOL eventListUnordered; //Specifies if the event list is unordered
    BOOL requiresHardRefresh; //True will clear old events data instead of merging new data into old data
}

- (void)refreshEvents;                          //Refreshes the list of events
- (NSString *)formatEventDate:(NSDate *)date;   //Formats the date given to a short human readable string
+ (CAMEventServices *)sharedInstance;

@property (nonatomic, retain) NSMutableArray *eventList; //List of events from the most recent query Note: Could be merged with previous queries if there was a refresh

@end
