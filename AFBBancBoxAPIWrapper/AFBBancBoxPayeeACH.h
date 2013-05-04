//
//  AFBBancBoxPayeeACH.h
//  Breeze
//
//  Created by Adam Block on 4/27/13.
//  Copyright (c) 2013 Adam Block. All rights reserved.
//

#import "AFBBancBoxPayee.h"

@interface AFBBancBoxPayeeACH : AFBBancBoxPayee

@property (nonatomic, strong) NSString *routingNumber;
@property (nonatomic, strong) NSString *accountNumber;
@property (nonatomic, strong) NSString *holderName;
@property (nonatomic, strong) NSString *bankAccountType;

- (id)initWithPayeeFromDictionary:(NSDictionary *)dict;
- (id)initFactoryWithPayeeFromDictionary:(NSDictionary *)dict;

@end
