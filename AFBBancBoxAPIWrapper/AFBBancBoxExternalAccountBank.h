//
//  AFBBancBoxExternalAccountBank.h
//  Breeze
//
//  Created by Adam Block on 4/29/13.
//  Copyright (c) 2013 Adam Block. All rights reserved.
//

#import "AFBBancBoxExternalAccount.h"

extern NSString * const BancBoxExternalAccountBankTypeSaving;
extern NSString * const BancBoxExternalAccountBankTypeChecking;

@interface AFBBancBoxExternalAccountBank : AFBBancBoxExternalAccount

@property (nonatomic, strong) NSString *routingNumber;
@property (nonatomic, strong) NSString *accountNumber;
@property (nonatomic, strong) NSString *holderName;
@property (nonatomic, strong) NSString *bankAccountType;

- (id)initWithRoutingNumber:(NSString *)routingNumber accountNumber:(NSString *)accountNumber holderName:(NSString *)holderName bankAccountType:(NSString *)bankAccountType;
+ (AFBBancBoxExternalAccountBank *)externalAccountFromDictionary:(NSDictionary *)dict;

@end
