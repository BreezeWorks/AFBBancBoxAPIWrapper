//
//  AFBBancBoxPayee.h
//  Breeze
//
//  Created by Adam Block on 4/26/13.
//  Copyright (c) 2013 Adam Block. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFBBancBoxPayee : NSObject

@property (nonatomic, strong) NSDictionary *dictionary;
@property (nonatomic, strong) NSString *payeeType;
@property (nonatomic) NSInteger payeeIdBancBoxId;
@property (nonatomic, strong) NSString *payeeIdSubscriberReferenceId;
@property (nonatomic, strong) NSString *payeeAccountNumber;
@property (nonatomic, strong) NSString *payeeName;
@property (nonatomic, strong) NSString *memo;

- (id)initWithPayeeFromDictionary:(NSDictionary *)dict;
- (id)initFactoryWithPayeeFromDictionary:(NSDictionary *)dict;

@end
