//
//  MMScrollBanner.m
//  MMScrollBannerDemo
//
//  Created by xueMingLuan on 2018/3/7.
//  Copyright © 2018年 mille. All rights reserved.
//

#import "MMScrollBanner.h"
#import "MMScrollBannerCell.h"
#import "MMScrollBannerPageControl.h"
#import <MMWeakTimer/MMWeakTimer.h>
#import <YYKit/YYKit.h>

//bannar滚动视图
#define kMMAutoScrollTimeInterval 3

@interface MMScrollBanner()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *originalArr;
@property (nonatomic ,strong) UICollectionView *collectionView;
@property (nonatomic ,strong) NSMutableArray *imagesArray;
@property (nonatomic ,strong) NSString *placeholderImageName;
@property (nonatomic ,assign) BOOL isNetworkding;
@property (nonatomic ,strong) MMScrollBannerPageControl *pageControl;
@property (nonatomic ,strong) NSTimer *timer;

@property (nonatomic, strong) UIView *pageIndicatorView;//默认圆点视图
@property (nonatomic, strong) UIView *currentPageIndicatorView;//当前选择圆点视图
@end

@implementation MMScrollBanner
- (void)dealloc {
    [_timer invalidate];
    _timer = nil;
}

- (instancetype)initWithFrame:(CGRect)frame
               imageUrlsArray:(NSArray<NSString *> *)dataSource
         placeholderImageName:(NSString *)placeholderImageName {
    
    if (self = [super initWithFrame:frame]){
        if (dataSource.count == 1) {
            self.isCancelAutoNextPage = YES;
            self.isCancelInfiniteBanner = YES;
        }else if (dataSource.count <1){
            return self;
        }else{
            self.isCancelAutoNextPage = NO;
            self.isCancelInfiniteBanner = NO;
        }
        
        self.originalArr = dataSource;
        self.imagesArray = [NSMutableArray arrayWithArray:dataSource];
        self.placeholderImageName = placeholderImageName;
        self.isNetworkding = YES;
        if(self.isCancelInfiniteBanner == NO){
            if (self.imagesArray[self.imagesArray.count-1]) {
                [self.imagesArray insertObject:self.imagesArray[self.imagesArray.count-1] atIndex:0];
            }
            if (self.imagesArray[0+1]) {
                [self.imagesArray insertObject:self.imagesArray[0+1] atIndex:self.imagesArray.count];
            }
        }
        [self initView:self.imagesArray];
    }
    return self;
}


- (void)initView:(NSArray *)array{
    if (self.subviews.count > 0) {
        [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj) {
                [obj removeFromSuperview];
            }
        }];
    }
    
    [self setBackgroundColor:[UIColor clearColor]];
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    flowLayout.itemSize  = CGSizeMake(self.frame.size.width, self.frame.size.height);
    flowLayout.scrollDirection  = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    
    UICollectionView *collection = [[UICollectionView  alloc]initWithFrame:self.bounds collectionViewLayout:flowLayout];
    collection.delegate = self;
    collection.dataSource = self;
    collection.pagingEnabled = YES;
    collection.showsVerticalScrollIndicator = NO;
    collection.showsHorizontalScrollIndicator = NO;
    [collection registerClass:[MMScrollBannerCell class] forCellWithReuseIdentifier:kMMScrollBannerCellId];
    
    collection.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
    [collection setBackgroundColor:[UIColor clearColor]];
    self.collectionView = collection;
    [self addSubview:self.collectionView];
    
    //自定义pageControl
    [self addSubview:self.pageControl];
    self.pageControl.userInteractionEnabled = NO;
    self.pageControl.currentPage = 0;
    if (array.count >1) {
        self.pageControl.hidden = NO;
    }else{
        self.pageControl.hidden = YES;
    }
    
    if(self.isCancelInfiniteBanner == NO){
        self.pageControl.numberOfPages = array.count - 2;
    }
    else{
        self.pageControl.numberOfPages = array.count;
    }
    
    [self setupCollectionView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kMMAutoScrollTimeInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if(self.isCancelAutoNextPage == NO){
            self.timer = [MMWeakTimer scheduledTimerWithTimeInterval:kMMAutoScrollTimeInterval target:self selector:@selector(nextPage:) userInfo:nil repeats:NO];
            [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSDefaultRunLoopMode];//mainRunLoop
        }
    });
}

- (MMScrollBannerPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[MMScrollBannerPageControl alloc] initWithFrame:CGRectMake(0 , self.frame.size.width - 22, self.frame.size.width, 12)
                                                        highLightImage:[self convertViewToImage:self.currentPageIndicatorView]
                                                          defaultImage:[self convertViewToImage:self.pageIndicatorView]];
    }
    return _pageControl;
}

- (UIImage *)convertViewToImage:(UIView *)view{
    CGSize size = view.bounds.size;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。
    //如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIView *)currentPageIndicatorView{
    if (_currentPageIndicatorView == nil) {
        _currentPageIndicatorView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 12, 12)];
        _currentPageIndicatorView.backgroundColor = [UIColor colorWithHexString:@"0xe75988"];
        _currentPageIndicatorView.layer.cornerRadius  =6;
    }
    return _currentPageIndicatorView;
}

- (UIView *)pageIndicatorView{
    if (_pageIndicatorView == nil) {
        _pageIndicatorView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,12, 12)];
        _pageIndicatorView.backgroundColor = [UIColor whiteColor];
        _pageIndicatorView.layer.cornerRadius = 6;
        _pageIndicatorView.layer.borderColor = [UIColor colorWithWhite:0.0 alpha:0.08].CGColor;
        _pageIndicatorView.layer.borderWidth = 0.5;
    }
    return _pageIndicatorView;
    
}

- (void)refreshViewWithDataSource:(NSArray *)dataSource {
    self.imagesArray = nil;
    [self.timer invalidate];
    self.timer = nil;
    self.collectionView.delegate = nil;
    self.collectionView.dataSource = nil;
    self.imagesArray = [NSMutableArray arrayWithArray:dataSource];
    self.isNetworkding = YES;
    self.originalArr = dataSource;
    if(self.isCancelInfiniteBanner == NO){
        if (self.imagesArray[self.imagesArray.count-1]) {
            [self.imagesArray insertObject:self.imagesArray[self.imagesArray.count-1] atIndex:0];
        }
        if (self.imagesArray[0+1]) {
            [self.imagesArray insertObject:self.imagesArray[0+1] atIndex:self.imagesArray.count];
        }
    }
    [self initView:self.imagesArray];
}


- (void)nextPage:(NSTimer *)timer{
    
    int page = self.collectionView.contentOffset.x / self.collectionView.frame.size.width;
    page ++;
    
    if(self.isCancelInfiniteBanner == NO){
        if(self.isCancelAutoNextPage == NO) {
            self.collectionView.allowsSelection = NO;
            [self.timer invalidate];
            self.timer = nil;
        }
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:page inSection:0];
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    }else{
        
        if (page == self.imagesArray.count) {
            page = 0;
        }
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:page inSection:0];
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    }
}

//当用户开始拖拽的时候就调用
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    if(self.isCancelAutoNextPage == NO) {
        self.collectionView.allowsSelection = NO;
        [self.timer invalidate];
        self.timer = nil;
    }
}

//停止滚动的时候调用（手动）
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if(self.isCancelAutoNextPage == NO){
        self.collectionView.allowsSelection = YES;
        if (self.timer == nil) {
            self.timer = [MMWeakTimer scheduledTimerWithTimeInterval:kMMAutoScrollTimeInterval target:self selector:@selector(nextPage:) userInfo:nil repeats:NO];
            [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSDefaultRunLoopMode];//mainRunLoop
        }
    }
}

//停止滚动的时候调用（带动画即自动）
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if(self.isCancelAutoNextPage == NO){
        self.collectionView.allowsSelection = YES;
        if (self.timer == nil) {
            self.timer = [MMWeakTimer scheduledTimerWithTimeInterval:kMMAutoScrollTimeInterval target:self selector:@selector(nextPage:) userInfo:nil repeats:NO];
            [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSDefaultRunLoopMode];//mainRunLoop
        }
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger page = scrollView.contentOffset.x / scrollView.frame.size.width;
    if(self.isCancelInfiniteBanner == NO){
        if(page == self.imagesArray.count-1 && scrollView.contentOffset.x >= scrollView.contentSize.width - scrollView.frame.size.width - 30){
            //最后一张
            page = 0+1;
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:page inSection:0];
            [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        }else if (page == 0 && scrollView.contentOffset.x <= 30){
            //第一张
            page = self.imagesArray.count-2;
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:page inSection:0];
            [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        }
        
    }
    NSInteger pageNum = scrollView.contentOffset.x / scrollView.frame.size.width + 0.5;
    if(self.isCancelInfiniteBanner == NO){
        self.pageControl.currentPage = pageNum - 1;
    }else{
        self.pageControl.currentPage = pageNum;
    }
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imagesArray.count ;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MMScrollBannerCell *cell = [collectionView
                                dequeueReusableCellWithReuseIdentifier:kMMScrollBannerCellId
                                forIndexPath:indexPath];
    cell.imageUrlArray = self.originalArr;
    [cell setCollectionViewCellWithImage:_imagesArray[indexPath.row]
                          placeholderImage:self.placeholderImageName isNeedNetworking:self.isNetworkding];
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    if([self.delegate respondsToSelector:@selector(scrollBanner:didClickedItemAtIndex:)]){
        if(self.isCancelInfiniteBanner == NO){
            if (indexPath.row > self.originalArr.count) {
                //防止点到最后一个滚动到第一个的第一个，这时index为count+1，传出会引起数组越界
                return;
            }
            [self.delegate scrollBanner:self didClickedItemAtIndex:(indexPath.item - 1)];
        }else{
            [self.delegate scrollBanner:self didClickedItemAtIndex:(indexPath.item)];
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(void)setupCollectionView{
    
    if(self.isCancelInfiniteBanner == NO) {
        //有无限轮播
        [self.collectionView  scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    } else {
        [self.collectionView  scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
}

-(void)setIsCancelAutoNextPage:(BOOL)isCancelAutoNextPage{
    
    _isCancelAutoNextPage = isCancelAutoNextPage;
    if(isCancelAutoNextPage == NO){
        //自动定时翻页
        [self.timer invalidate];
        self.timer = nil;
        
        self.timer = [MMWeakTimer scheduledTimerWithTimeInterval:kMMAutoScrollTimeInterval target:self selector:@selector(nextPage:) userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSDefaultRunLoopMode];//mainRunLoop
    }else{
        //取消自动翻页
        [self.timer invalidate];
        self.timer = nil;
        
        self.pageControl.currentPage = 0;
    }
    
    [self setupCollectionView];
}


-(void)setIsCancelPageControl:(BOOL)isCancelPageControl{
    if(isCancelPageControl == NO){
        self.pageControl.hidden = NO;
    }else{
        //隐藏
        self.pageControl.hidden = YES;
    }
}

- (void)setIsPause:(BOOL)isPause {
    if (self.originalArr.count == 1) {
        return;
    }
    _isPause = isPause;
    if (_isPause) {
        [self.timer invalidate];
        self.timer = nil;
    } else {
        if (self.timer == nil) {
            self.timer = [MMWeakTimer scheduledTimerWithTimeInterval:kMMAutoScrollTimeInterval target:self selector:@selector(nextPage:) userInfo:nil repeats:NO];
            [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSDefaultRunLoopMode];//mainRunLoop
        }
    }
}

-(void)setIsCancelInfiniteBanner:(BOOL)isCancelInfiniteBanner{
    
    if(self.isCancelInfiniteBanner == isCancelInfiniteBanner)
        return;
    _isCancelInfiniteBanner = isCancelInfiniteBanner;
    if(isCancelInfiniteBanner == NO){
        if (self.imagesArray[self.imagesArray.count-1]) {
            [self.imagesArray insertObject:self.imagesArray[self.imagesArray.count-1] atIndex:0];
        }
        if (self.imagesArray[0+1]) {
            [self.imagesArray insertObject:self.imagesArray[0+1] atIndex:self.imagesArray.count];
        }
    }else{
        //取消无限轮播
        if (self.imagesArray.count > 0) {
            [self.imagesArray removeObjectAtIndex:0];
        }
        //        [self.imagesArray removeObjectAtIndex:self.imagesArray.count-1];
        NSInteger index = self.imagesArray.count-1;
        if (self.imagesArray.count > index) {
            [self.imagesArray removeObjectAtIndex:index];
        }
        
        [self setupCollectionView];
    }
    
    [self.collectionView reloadData];
}

@end
