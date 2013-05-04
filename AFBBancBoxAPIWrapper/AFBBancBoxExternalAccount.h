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

@property (nonatomic, strong) NSDictionary *dictionary;
@property (nonatomic) NSInteger bancBoxId;
@property (nonatomic, strong) NSString *subscriberReferenceId;
@property (nonatomic, strong) NSString *externalAccountStatus;

- (id)initWithExternalAccountFromDictionary:(NSDictionary *)dict;
- (id)initFactoryWithExternalAccountFromDictionary:(NSDictionary *)dict;
- (NSDictionary *)accountDetailsDictionary;

@end
