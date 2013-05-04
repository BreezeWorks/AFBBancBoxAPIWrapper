//
//  AFBBancBoxLinkedExternalAccount.h
//  Breeze
//
//  Created by Adam Block on 4/30/13.
//  Copyright (c) 2013 Adam Block. All rights reserved.
//

#import "AFBBancBoxAccount.h"

@interface AFBBancBoxLinkedExternalAccount : AFBBancBoxAccount

@property (nonatomic, strong) NSDictionary *dictionary;
@property (nonatomic) NSInteger bancBoxId;
@property (nonatomic, strong) NSString *subscriberReferenceId;

- (id)initWithAccountFromDictionary:(NSDictionary *)dict;

@end
