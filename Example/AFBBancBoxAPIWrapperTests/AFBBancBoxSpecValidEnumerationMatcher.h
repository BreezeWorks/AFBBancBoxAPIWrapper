//
//  AFBBancBoxSpecValidEnumerationMatchers.h
//  AFBBancBoxAPIWrapper
//
//  Created by Adam Block on 5/3/13.
//  Copyright (c) 2013 Adam Block. All rights reserved.
//

#import <Kiwi.h>

@interface AFBBancBoxSpecValidEnumerationMatcher : KWMatcher

- (void)beValidCipStatus;
- (void)beValidClientStatus;

@end