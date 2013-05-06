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

+ (id)externalAccountFromDictionary:(NSDictionary *)dict
{
    id instance;
    
    NSDictionary *cardAccountDict = dict[@"account"][@"cardAccount"];
    if (cardAccountDict[@"creditCardAccount"]) instance = [AFBBancBoxExternalAccountCardCredit externalAccountFromDictionary:dict];
    if (cardAccountDict[@"debitCardAccount"])  instance = [AFBBancBoxExternalAccountCardDebit externalAccountFromDictionary:dict];
    if (cardAccountDict[@"giftCardAccount"])   instance = [AFBBancBoxExternalAccountCardGift externalAccountFromDictionary:dict];
    
    return instance;
}

- (NSDictionary *)dictionary
{
    return [super dictionary];
}

@end
