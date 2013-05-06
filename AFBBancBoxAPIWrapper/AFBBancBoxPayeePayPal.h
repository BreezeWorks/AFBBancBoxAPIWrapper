//
//  AFBBancBoxPayeePayPal.h
//  Breeze
//
//  Created by Adam Block on 4/27/13.
//  Copyright (c) 2013 Adam Block. All rights reserved.
//

#import "AFBBancBoxPayee.h"

@interface AFBBancBoxPayeePayPal : AFBBancBoxPayee

@property (nonatomic, strong) NSString *id;

- (id)initWithPayeeFromDictionary:(NSDictionary *)dict;
+ (AFBBancBoxPayeePayPal *)payeeFromDictionary:(NSDictionary *)dict;

@end
