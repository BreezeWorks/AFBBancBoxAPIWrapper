//
//  AFBBancBoxVerificationAnswer.m
//  Breeze
//
//  Created by Adam Block on 4/29/13.
//  Copyright (c) 2013 Adam Block. All rights reserved.
//

#import "AFBBancBoxVerificationAnswer.h"

@implementation AFBBancBoxVerificationAnswer

- (id)initWithQuestionType:(NSString *)questionType answer:(NSString *)answer
{
    self = [super init];
    if (self) {
        self.questionType = questionType;
        self.answer = answer;
    }
    return self;
}

- (NSDictionary *)dictionary
{
    NSDictionary *dictionary = @{ @"type": self.questionType, @"answer": self.answer };
    return dictionary;
}

@end
