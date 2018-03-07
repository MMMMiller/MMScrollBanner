//
//  MMWeakTimer.m
//  MMWeakTimerDemo
//
//  Created by xueMingLuan on 2018/3/7.
//  Copyright © 2018年 mille. All rights reserved.
//

#import "MMWeakTimer.h"

@implementation MMWeakTimer

+ (NSTimer *) scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                      target:(id)aTarget
                                    selector:(SEL)aSelector
                                    userInfo:(id)userInfo
                                     repeats:(BOOL)repeats
{
    
    MMWeakTimer * timer = [MMWeakTimer new];
    timer.target = aTarget;
    timer.selector = aSelector;
    timer.timer = [NSTimer scheduledTimerWithTimeInterval:interval target:timer selector:@selector(fire:) userInfo:userInfo repeats:repeats];
    return timer.timer;
}



-(void)fire:(NSTimer *)timer{
    
    if (self.target) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.target performSelector:self.selector withObject:timer.userInfo];
#pragma clang diagnostic pop
    } else {
        
        [self.timer invalidate];
    }
}

@end
