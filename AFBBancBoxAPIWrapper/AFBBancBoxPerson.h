//
//  AFBBancBoxPerson.h
//  AFBBancBoxAPIWrapper
//
//  Created by Adam Block on 6/19/13.
//  Copyright (c) 2013 Adam Block. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFBBancBoxPerson : NSObject

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *middleInitial;
@property (nonatomic, strong) NSString *ssn;
@property (nonatomic, strong) NSDate *dob;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *addressLine1;
@property (nonatomic, strong) NSString *addressLine2;
@property (nonatomic, strong) NSString *addressCity;
@property (nonatomic, strong) NSString *addressState;
@property (nonatomic, strong) NSString *addressZipCode;

- (NSDictionary *)dictionary;
+ (NSDateFormatter *)birthdateDateFormatter;

@end
