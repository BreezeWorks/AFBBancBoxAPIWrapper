//
//  AFBBancBoxExternalAccountCard.m
//  Breeze
//
//  Created by Adam Block on 4/29/13.
//  Copyright (c) 2013 Adam Block. All rights reserved.
//

#import "AFBBancBoxExternalAccountCard.h"
#import "AFBBancBoxExternalAccountCardCredit.h"
#import "AFBBancBoxExternalAccountCardDebit.h"
#import "AFBBancBoxExternalAccountCardGift.h"

@implementation AFBBancBoxExternalAccountCard

- (id)initWithExternalAccountFromDictionary:(NSDictionary *)dict
{
    return [super initWithExternalAccountFromDictionary:dict];
}

- (id)initFactoryWithExternalAccountFromDictionary:(NSDictionary *)dict
{
    id instance = nil;
    
    if (dict[@"cardAccount"][@"creditCardAccount"]) instance = [[AFBBancBoxExternalAccountCardCredit alloc] initFactoryWithExternalAccountFromDictionary:dict];
    if (dict[@"cardAccount"][@"debitCardAccount"])  instance = [[AFBBancBoxExternalAccountCardDebit alloc] initFactoryWithExternalAccountFromDictionary:dict];
    if (dict[@"cardAccount"][@"giftCardAccount"])   instance = [[AFBBancBoxExternalAccountCardGift alloc] initFactoryWithExternalAccountFromDictionary:dict];
    
    return instance;
}

- (NSDictionary *)dictionary
{
    return [super dictionary];
}

@end
