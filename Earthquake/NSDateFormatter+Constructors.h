//
//  NSDateFormatter+Constructors.h
//  Earthquake
//
//  Created by Chris Mays on 2/20/15.
//  Copyright (c) 2015 Chris Mays. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDateFormatter (Constructors)
+ (NSDateFormatter *)ISO8601Formatter; //Creates a formatter that will output an ISO8601 date string
@end
