//
//  AFBBancBoxExternalAccountCardDebit.h
//  Breeze
//
//  Created by Adam Block on 4/29/13.
//  Copyright (c) 2013 Adam Block. All rights reserved.
//

#import "AFBBancBoxExternalAccountCard.h"

@interface AFBBancBoxExternalAccountCardDebit : AFBBancBoxExternalAccountCard

@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSString *debitCardType;
@property (nonatomic, strong) NSString *pin;

- (id)initWithNumber:(NSString *)number debitCardType:(NSString *)debitCardType pin:(NSString *)pin;
+ (AFBBancBoxExternalAccountCardDebit *)externalAccountFromDictionary:(NSDictionary *)dict;

@end
