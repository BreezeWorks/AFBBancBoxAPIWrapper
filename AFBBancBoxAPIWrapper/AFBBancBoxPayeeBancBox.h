//
//  AFBBancBoxPayeeBancBox.h
//  Breeze
//
//  Created by Adam Block on 4/27/13.
//  Copyright (c) 2013 Adam Block. All rights reserved.
//

#import "AFBBancBoxPayee.h"

@interface AFBBancBoxPayeeBancBox : AFBBancBoxPayee

@property (nonatomic) NSInteger bancboxPayeeId;

- (id)initWithPayeeFromDictionary:(NSDictionary *)dict;
+ (AFBBancBoxPayeeBancBox *)payeeFromDictionary:(NSDictionary *)dict;

@end
