//
//  AFBBancBoxExternalAccountCardCredit.h
//  Breeze
//
//  Created by Adam Block on 4/29/13.
//  Copyright (c) 2013 Adam Block. All rights reserved.
//

#import "AFBBancBoxExternalAccountCard.h"

@interface AFBBancBoxExternalAccountCardCredit : AFBBancBoxExternalAccountCard

@property (nonatomic, strong) NSString *tokenizedId;
@property (nonatomic, strong) NSString *cardNumber;
@property (nonatomic, strong) NSString *expiryDate;
@property (nonatomic, strong) NSString *creditCardType;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *cvv;
@property (nonatomic, strong) NSString *addressLine1;
@property (nonatomic, strong) NSString *addressLine2;
@property (nonatomic, strong) NSString *addressCity;
@property (nonatomic, strong) NSString *addressState;
@property (nonatomic, strong) NSString *addressZipcode;

+ (AFBBancBoxExternalAccountCardCredit *)externalAccountFromDictionary:(NSDictionary *)dict;

@end
