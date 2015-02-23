//
//  NSDictionary+Constructors.m
//  Earthquake
//
//  Created by Chris Mays on 2/21/15.
//  Copyright (c) 2015 Chris Mays. All rights reserved.
//

#import "NSDictionary+Constructors.h"

@implementation NSDictionary (Constructors)
/*
    Returns a copy of self with all instance of nsnull removed
 */
- (NSDictionary *)dictionaryByReplacingNSNullWithString{
    id nul = [NSNull null];
    NSMutableDictionary *final = [NSMutableDictionary dictionaryWithDictionary:self];
    NSArray *keys = [final allKeys];
    for (int i=0; i<[keys count]; i++) {
        if ([final objectForKey:[keys objectAtIndex:i]]==nul) {
            [final removeObjectForKey:[keys objectAtIndex:i]];
        }
    }
    return final;
}
@end
