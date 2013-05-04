//
//  AFBBancBoxExternalAccountCardGift.h
//  Breeze
//
//  Created by Adam Block on 4/29/13.
//  Copyright (c) 2013 Adam Block. All rights reserved.
//

#import "AFBBancBoxExternalAccountCard.h"

@interface AFBBancBoxExternalAccountCardGift : AFBBancBoxExternalAccountCard

@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSString *pin;

- (id)initWithNumber:(NSString *)number pin:(NSString *)pin;

@end
