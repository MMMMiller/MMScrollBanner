//
//  MMScrollBannerCell.h
//  MMScrollBannerDemo
//
//  Created by xueMingLuan on 2018/3/7.
//  Copyright © 2018年 mille. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *kMMScrollBannerCellId = @"kMMScrollBannerCellId";

@interface MMScrollBannerCell : UICollectionViewCell

//传递整个图片数组是为了大图浏览时可以浏览所有图片
@property (nonatomic, copy) NSArray *imageUrlArray;

- (void)setLycollectionViewCellWithImage:(NSString *)imageName
                        placeholderImage:(NSString *)placeholderImage
                        isNeedNetworking:(BOOL)isNeedNetworking;

@end
