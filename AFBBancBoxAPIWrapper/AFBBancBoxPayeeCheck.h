//
//  AFBBancBoxPayeeCheck.h
//  Breeze
//
//  Created by Adam Block on 4/27/13.
//  Copyright (c) 2013 Adam Block. All rights reserved.
//

#import "AFBBancBoxPayee.h"

@interface AFBBancBoxPayeeCheck : AFBBancBoxPayee

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *addressLine1;
@property (nonatomic, strong) NSString *addressLine2;
@property (nonatomic, strong) NSString *addressCity;
@property (nonatomic, strong) NSString *addressState;
@property (nonatomic, strong) NSString *addressZipCode;

- (id)initWithPayeeFromDictionary:(NSDictionary *)dict;
+ (AFBBancBoxPayeeCheck *)payeeFromDictionary:(NSDictionary *)dict;

@end
