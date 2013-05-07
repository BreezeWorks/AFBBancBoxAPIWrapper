//
//  AFBBancBoxInternalAccount.h
//  Breeze
//
//  Created by Adam Block on 4/26/13.
//  Copyright (c) 2013 Adam Block. All rights reserved.
//

#import "AFBBancBoxAccount.h"

@interface AFBBancBoxInternalAccount : AFBBancBoxAccount

@property (nonatomic) BOOL routableForCredits;
@property (nonatomic) BOOL routableForDebits;
@property (nonatomic, strong) NSString *routingNumber;
@property (nonatomic, strong) NSString *accountStatus;
@property (nonatomic, strong) NSString *accountType;
@property (nonatomic, strong) NSString *title;
@property (nonatomic) double currentBalance;
@property (nonatomic) double pendingBalance;

- (id)initWithAccountFromDictionary:(NSDictionary *)dict;
+ (AFBBancBoxInternalAccount *)accountFromDictionary:(NSDictionary *)dict;
- (NSDictionary *)idDictionary;

@end
