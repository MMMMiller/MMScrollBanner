//
//  MMScrollBannerPageControll.h
//  MMScrollBannerDemo
//
//  Created by xueMingLuan on 2018/3/7.
//  Copyright © 2018年 mille. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMScrollBannerPageControl : UIPageControl
@property (nonatomic, strong) UIImage *highLightImage; //高亮图片
@property (nonatomic, strong) UIImage *defaultImage; //默认图片

- (instancetype)initWithFrame:(CGRect)frame
               highLightImage:(UIImage *)currentImage
                 defaultImage:(UIImage *)defaultImage;
@end
