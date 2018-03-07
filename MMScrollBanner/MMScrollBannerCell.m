//
//  MMScrollBannerCell.m
//  MMScrollBannerDemo
//
//  Created by xueMingLuan on 2018/3/7.
//  Copyright © 2018年 mille. All rights reserved.
//

#import "MMScrollBannerCell.h"
#import <YYKit/YYKit.h>
#import <YYKit/UIImageView+YYWebImage.h>

@interface MMScrollBannerCell()

@property (nonatomic, assign) CGSize size;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, copy) NSString *urlStr;

@end

@implementation MMScrollBannerCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.size = frame.size;
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

- (void)setLycollectionViewCellWithImage:(NSString *)imageName
                        placeholderImage:(NSString *)placeholderImage
                        isNeedNetworking:(BOOL)isNeedNetworking{
    
    if(isNeedNetworking == NO){
        [self.imageView setImage:[UIImage imageNamed:imageName]];
        
    }else{
        _urlStr = imageName;
        _urlStr = [_urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [self imageView:self.imageView setImgUrl:_urlStr];
    }
}

- (void)imageView:(UIImageView *)imgView setImgUrl:(NSString *)url {
    
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicatorView.tag = 999;
    [self addSubview:indicatorView];
    [indicatorView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [indicatorView startAnimating];
    
    @weakify(self);
    [imgView setImageWithURL:[NSURL URLWithString:url] placeholder:nil options:YYWebImageOptionShowNetworkActivity completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            for (UIView *v in self.subviews) {
                if (v.tag == 999) {
                    [(UIActivityIndicatorView *)v stopAnimating];
                    [v removeFromSuperview];
                }
            }
            self.imageView.image = image;
        });
    }];
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc]init];
        _imageView.backgroundColor = [UIColor whiteColor];
        _imageView.frame = CGRectMake(0, 0, self.size.width, self.size.height);
        _imageView.userInteractionEnabled = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

@end
