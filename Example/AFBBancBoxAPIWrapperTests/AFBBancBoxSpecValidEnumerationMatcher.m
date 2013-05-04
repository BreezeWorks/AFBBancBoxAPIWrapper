//
//  AFBBancBoxSpecValidEnumerationMatcher.m
//  AFBBancBoxAPIWrapper
//
//  Created by Adam Block on 5/3/13.
//  Copyright (c) 2013 Adam Block. All rights reserved.
//

#include "AFBBancBoxSpecValidEnumerationMatcher.h"
#include <Kiwi.h>

@interface AFBBancBoxSpecValidEnumerationMatcher()

@property (nonatomic, strong) NSArray *validObjects;

@end

@implementation AFBBancBoxSpecValidEnumerationMatcher : KWMatcher

#pragma mark - Getting Matcher Strings
+ (NSArray *)matcherStrings
{
    return @[@"beValidCipStatus", @"beValidClientStatus"];
}

#pragma mark - Matching
- (BOOL)evaluate
{
    return [self.validObjects containsObject:self.subject];
}

#pragma mark - Getting Failure Messages
- (NSString *)failureMessageForShould {
    return [NSString stringWithFormat:@"expected subject to be one of [%@], got %@", self.validObjects, self.subject];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"be one of [%@]", self.validObjects];
}

#pragma mark - Configuring Matchers
- (void)beValidCipStatus
{
    self.validObjects = @[@"VERIFIED", @"REJECTED", @"IGNORED", @"UNVERIFIED"];
}

- (void)beValidClientStatus
{
    self.validObjects = @[@"ACTIVE", @"INACTIVE", @"CANCELLED", @"SUSPENDED", @"DELETED"];
}

@end