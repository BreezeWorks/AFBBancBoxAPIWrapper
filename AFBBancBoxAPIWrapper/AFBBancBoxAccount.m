//
//  AFBBancBoxAccount.m
//  Breeze
//
//  Created by Adam Block on 4/30/13.
//  Copyright (c) 2013 Adam Block. All rights reserved.
//

#import "AFBBancBoxAccount.h"

NSString * const BancBoxAccountTypeGeneral =    @"GENERAL";
NSString * const BancBoxAccountTypeSpecial =    @"SPECIAL";
NSString * const BancBoxAccountStatusOpen =     @"OPEN";
NSString * const BancBoxAccountStatusClosed =   @"CLOSED";

@implementation AFBBancBoxAccount

- (NSString *)description
{
    return self.dictionary.description;
}

- (NSDictionary *)dictionary
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (self.bancBoxId) dict[@"bancBoxId"] = self.bancBoxId;
    if (self.subscriberReferenceId) dict[@"subscriberReferenceId"] = self.subscriberReferenceId;
    
    return dict;
}

@end
