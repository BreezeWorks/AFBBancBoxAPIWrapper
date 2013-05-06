//
//  AFBBancBoxVerificationQuestion.h
//  Breeze
//
//  Created by Adam Block on 4/29/13.
//  Copyright (c) 2013 Adam Block. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFBBancBoxVerificationQuestion : NSObject

@property (nonatomic, strong) NSString *prompt;
@property (nonatomic, strong) NSString *questionType;
@property (nonatomic, strong) NSArray *answers;

- (id)initWithQuestionFromDictionary:(NSDictionary *)dict;
+ (AFBBancBoxVerificationQuestion *)questionFromDictionary:(NSDictionary *)dict;

@end
