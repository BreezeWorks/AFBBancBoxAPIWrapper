//
//  AFBBancBoxLinkedExternalAccount.h
//  Breeze
//
//  Created by Adam Block on 4/30/13.
//  Copyright (c) 2013 Adam Block. All rights reserved.
//

#import "AFBBancBoxAccount.h"

@interface AFBBancBoxLinkedExternalAccount : AFBBancBoxAccount

- (id)initWithAccountFromDictionary:(NSDictionary *)dict;
+ (AFBBancBoxLinkedExternalAccount *)accountFromDictionary:(NSDictionary *)dict;

@end
