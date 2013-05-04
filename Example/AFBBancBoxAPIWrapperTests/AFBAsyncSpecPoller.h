//
//  AFBAsyncSpecPoller.h
//  AFBBancBoxAPIWrapper
//
//  Created by Adam Block on 5/3/13.
//  Copyright (c) 2013 Adam Block. All rights reserved.
//

// Thanks to Mike from codely for the core of this solution
// http://codely.wordpress.com/2013/01/16/unit-testing-asynchronous-tasks-in-objective-c/

#define POLL_INTERVAL 0.25      // 250ms
#define N_SEC_TO_POLL 5.0       // poll for 1s
#define MAX_POLL_COUNT N_SEC_TO_POLL / POLL_INTERVAL

#define CAT(x, y) x ## y
#define TOKCAT(x, y) CAT(x, y)
#define __pollCountVar TOKCAT(__pollCount,__LINE__)

#define POLL(__done) \
NSUInteger __pollCountVar = 0; \
while (__done == NO && __pollCountVar < MAX_POLL_COUNT) { \
NSLog(@"Polling... %i", __pollCountVar ); \
NSDate* untilDate = [NSDate dateWithTimeIntervalSinceNow:POLL_INTERVAL]; \
[[NSRunLoop currentRunLoop] runUntilDate:untilDate]; \
__pollCountVar ++; \
} \
if (__pollCountVar  == MAX_POLL_COUNT) { \
NSLog(@"Poller timed out."); \
[[theValue(YES) should] equal:theValue(NO)]; \
}