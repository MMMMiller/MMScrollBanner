//
//  MMScrollBannerPageControll.m
//  MMScrollBannerDemo
//
//  Created by xueMingLuan on 2018/3/7.
//  Copyright © 2018年 mille. All rights reserved.
//

#import "MMScrollBannerPageControl.h"
#define kBTDotWidth 6//圆点直径
#define kBTDotMargin 4//圆点间距


@implementation MMScrollBannerPageControl

- (instancetype)initWithFrame:(CGRect)frame
               highLightImage:(UIImage *)highLightImage
                 defaultImage:(UIImage *)defaultImage {
    
    self = [super initWithFrame:frame];
    self.highLightImage = highLightImage;
    self.defaultImage = defaultImage;
    return self;
}

- (void)setCurrentPage:(NSInteger)page {
    [super setCurrentPage:page];
    
    [self setUpDots];
    
}

/**
 重写设置圆点图片
 */
- (void)setUpDots {
    for (int i=0; i<[self.subviews count]; i++) {
        UIView *dot = [self.subviews objectAtIndex:i];
        if ([dot.subviews count] == 0) {
            UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(dot.bounds.origin.x, dot.bounds.origin.y, kBTDotWidth, kBTDotWidth)];
            [dot addSubview:view];
        };
        UIImageView *view = dot.subviews[0];
        if (i == self.currentPage) {
            if (self.highLightImage) {
                view.image = self.highLightImage;
                dot.backgroundColor = [UIColor clearColor];
            }else {
                view.image = nil;
                dot.backgroundColor = self.currentPageIndicatorTintColor;
            }
        }else if (self.defaultImage) {
            view.image = self.defaultImage;
            dot.backgroundColor = [UIColor clearColor];
        }else {
            view.image = nil;
            dot.backgroundColor = self.pageIndicatorTintColor;
        }
    }
}


/**
 重写设置圆点间距
 */
- (void)layoutSubviews{
    [super layoutSubviews];
    //计算圆点间距
    CGFloat marginX = kBTDotWidth + kBTDotMargin;
    //计算整个pageControll的宽度
    CGFloat newW = (self.subviews.count - 1 ) * marginX;
    //设置新frame
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, newW, self.frame.size.height);
    //设置居中
    CGPoint center = self.center;
    center.x = self.superview.center.x;
    self.center = center;
    //遍历subview,设置圆点frame
    for (int i=0; i<[self.subviews count]; i++) {
        UIImageView* dot = [self.subviews objectAtIndex:i];
        [dot setFrame:CGRectMake(i * marginX, dot.frame.origin.y, kBTDotWidth, kBTDotWidth)];
    }
}

@end
