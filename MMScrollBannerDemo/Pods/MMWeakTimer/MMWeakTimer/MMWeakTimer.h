//
//  MMWeakTimer.h
//  MMWeakTimerDemo
//
//  Created by xueMingLuan on 2018/3/7.
//  Copyright © 2018年 mille. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMWeakTimer : NSTimer

@property (nonatomic, assign) SEL selector;
@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, weak) id target;

+ (NSTimer *) scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                      target:(id)aTarget
                                    selector:(SEL)aSelector
                                    userInfo:(id)userInfo
                                     repeats:(BOOL)repeats;

@end
