//
//  AFBBancBoxVerificationAnswer.h
//  Breeze
//
//  Created by Adam Block on 4/29/13.
//  Copyright (c) 2013 Adam Block. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFBBancBoxVerificationAnswer : NSObject

@property (nonatomic, strong) NSString *questionType;
@property (nonatomic, strong) NSString *answer;

- (id)initWithQuestionType:(NSString *)questionType answer:(NSString *)answer;
- (NSDictionary *)dictionary;

@end
