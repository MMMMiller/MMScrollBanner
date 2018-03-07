//
//  MMScrollBanner.h
//  MMScrollBannerDemo
//
//  Created by xueMingLuan on 2018/3/7.
//  Copyright © 2018年 mille. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MMScrollBanner;

@protocol MMScrollBannerDelegate <NSObject>
@optional

- (void)scrollBanner:(MMScrollBanner *)scrollBanner didClickedItemAtIndex:(NSInteger)index;

@end

@interface MMScrollBanner : UIView

- (instancetype)initWithFrame:(CGRect)frame
               imageUrlsArray:(NSArray <NSString *>*)dataSource
         placeholderImageName:(NSString *)placeholderImageName;

- (void)refreshViewWithDataSource:(NSArray *)dataSource;

@property(nonatomic ,assign)BOOL       isCancelAutoNextPage;//取消自动轮播，当page只有1的时候自动取消
@property(nonatomic ,assign)BOOL       isCancelPageControl;//取消pagecontrol，当page只有1的时候自动取消
@property(nonatomic ,assign)BOOL       isCancelInfiniteBanner;//取消无限轮播，当page只有1的时候自动取消
@property(nonatomic ,assign)BOOL       isPause;//是否暂停计时
@property (nonatomic, weak)id <MMScrollBannerDelegate> delegate;

@end
