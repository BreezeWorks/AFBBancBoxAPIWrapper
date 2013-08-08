//
//  AFBBancBoxPerson.m
//  AFBBancBoxAPIWrapper
//
//  Created by Adam Block on 6/19/13.
//  Copyright (c) 2013 Adam Block. All rights reserved.
//

#import "AFBBancBoxPerson.h"

@implementation AFBBancBoxPerson

- (NSDictionary *)dictionary
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (self.firstName) dict[@"firstName"] = self.firstName;
    if (self.lastName) dict[@"lastName"] = self.lastName;
    if (self.middleInitial) dict[@"middleInitial"] = self.middleInitial;
    if (self.ssn) dict[@"ssn"] = self.ssn;
    if (self.dob) dict[@"dob"] = [[AFBBancBoxPerson birthdateDateFormatter] stringFromDate:self.dob];
    if (self.email) dict[@"email"] = self.email;
    
    NSMutableDictionary *address = [NSMutableDictionary dictionary];
    if (self.addressLine1) address[@"line1"] = self.addressLine1;
    if (self.addressLine2) address[@"line2"] = self.addressLine2;
    if (self.addressCity) address[@"city"] = self.addressCity;
    if (self.addressState) address[@"state"] = self.addressState;
    if (self.addressZipCode) address[@"zipcode"] = self.addressZipCode;
    if ([address count] > 0) dict[@"address"] = address;
    
    return dict;
}

+ (NSDateFormatter *)birthdateDateFormatter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return dateFormatter;
}

@end
