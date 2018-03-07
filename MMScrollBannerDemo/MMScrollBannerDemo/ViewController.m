//
//  ViewController.m
//  MMScrollBannerDemo
//
//  Created by xueMingLuan on 2018/3/7.
//  Copyright © 2018年 mille. All rights reserved.
//

#import "ViewController.h"
#import "MMScrollBanner.h"

@interface ViewController ()<MMScrollBannerDelegate> {
    MMScrollBanner *_bannarView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *imgs = @[@"http://upload-images.jianshu.io/upload_images/1426854-b20dc3e4aefd878f.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",
                      @"http://upload-images.jianshu.io/upload_images/1426854-ae96c202843dcbce.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",
                      @"http://upload-images.jianshu.io/upload_images/1426854-88c1ec49d2f51faf.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",
                      @"http://upload-images.jianshu.io/upload_images/1426854-b8661d64f8ec160c.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",
                      @"http://upload-images.jianshu.io/upload_images/1426854-72ff92aeeb638184.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240"];
    
    _bannarView = [[MMScrollBanner alloc] initWithFrame:CGRectMake(20, 88, 320, 500)
                                         imageUrlsArray:imgs
                                   placeholderImageName:nil];
    _bannarView.layer.borderWidth = 2;
    _bannarView.layer.borderColor = [UIColor blackColor].CGColor;
    _bannarView.delegate = self;
    _bannarView.isCancelAutoNextPage = NO;
    _bannarView.isCancelInfiniteBanner = NO;
    [self.view addSubview:_bannarView];
}

@end
