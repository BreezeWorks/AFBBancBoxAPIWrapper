//
//  AFBBancBoxExternalAccountPaypal.h
//  Breeze
//
//  Created by Adam Block on 4/29/13.
//  Copyright (c) 2013 Adam Block. All rights reserved.
//

#import "AFBBancBoxExternalAccount.h"

@interface AFBBancBoxExternalAccountPaypal : AFBBancBoxExternalAccount

@property (nonatomic, strong) NSString *paypalId;

- (id)initWithId:(NSString *)paypalId;

@end
