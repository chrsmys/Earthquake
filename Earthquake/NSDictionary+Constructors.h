//
//  NSDictionary+Constructors.h
//  Earthquake
//
//  Created by Chris Mays on 2/21/15.
//  Copyright (c) 2015 Chris Mays. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Constructors)
- (NSDictionary *)dictionaryByReplacingNSNullWithString; //Returns a copy of self with all instance of nsnull removed
@end
