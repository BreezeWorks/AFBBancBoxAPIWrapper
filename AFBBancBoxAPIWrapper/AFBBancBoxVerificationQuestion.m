//
//  AFBBancBoxVerificationQuestion.m
//  Breeze
//
//  Created by Adam Block on 4/29/13.
//  Copyright (c) 2013 Adam Block. All rights reserved.
//

#import "AFBBancBoxVerificationQuestion.h"

@implementation AFBBancBoxVerificationQuestion

- (id)initWithQuestionFromDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.prompt = dict[@"prompt"];
        self.questionType = dict[@"type"];
        self.answers = dict[@"answers"];
    }
    return self;
}

+ (AFBBancBoxVerificationQuestion *)questionFromDictionary:(NSDictionary *)dict
{
    return [[AFBBancBoxVerificationQuestion alloc] initWithQuestionFromDictionary:dict];
}

@end
