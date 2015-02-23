//
//  NSDateFormatter+Constructors.m
//  Earthquake
//
//  Created by Chris Mays on 2/20/15.
//  Copyright (c) 2015 Chris Mays. All rights reserved.
//

#import "NSDateFormatter+Constructors.h"

@implementation NSDateFormatter (Constructors)
/*
  Creates a formatter that will output an ISO8601 date string
 */
+ (NSDateFormatter *)ISO8601Formatter{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
    return formatter;
}
@end
