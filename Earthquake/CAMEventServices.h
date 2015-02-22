//
//  CAMEventServices.h
//  Earthquake
//
//  Created by Chris Mays on 2/20/15.
//  Copyright (c) 2015 Chris Mays. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CAMEventServices : NSObject{
    NSDate *lastRefreshDate;
    BOOL eventListUnordered;
}

-(void)refreshEvents;
-(NSString *)formatEventDate:(NSDate *)date;
+(CAMEventServices *)sharedInstance;

@property (nonatomic, retain) NSMutableArray *eventList;

@end
