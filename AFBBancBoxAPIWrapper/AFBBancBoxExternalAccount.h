//
//  AFBBancBoxExternalAccount.h
//  Breeze
//
//  Created by Adam Block on 4/26/13.
//  Copyright (c) 2013 Adam Block. All rights reserved.
//

// Abstract factory class for creating external linked accounts

#import "AFBBancBoxAccount.h"

@interface AFBBancBoxExternalAccount : AFBBancBoxAccount

@property (nonatomic, strong) NSString *externalAccountStatus;

- (id)initWithExternalAccountFromDictionary:(NSDictionary *)dict;
+ (id)externalAccountFromDictionary:(NSDictionary *)dict;
- (NSDictionary *)accountDetailsDictionary;

@end
