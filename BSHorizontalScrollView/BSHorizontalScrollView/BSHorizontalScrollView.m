//
//  BSHorizontalScrollView.m
//  lunboScrollView
//
//  Created by 董志玮 on 2019/4/26.
//  Copyright © 2019 chao. All rights reserved.
//

#import "BSHorizontalScrollView.h"
#import "SDWebImage.h"

@interface BSHorizontalScrollView()
@property (assign, nonatomic) CGFloat scrollViewWidth;
@property (assign, nonatomic) CGFloat scrollViewHeight;
@property (assign, nonatomic) NSUInteger imageCount;
@end


@implementation BSHorizontalScrollView

- (instancetype)initWithViewRect:(CGRect)viewRect bannerImageNameArray:(NSArray *)imageNameArray{
    self = [super init];
    if (self) {
        self.imageArray = imageNameArray.mutableCopy;
        self.imageCount = _imageArray.count;
        self.scrollViewWidth = viewRect.size.width;
        self.scrollViewHeight = viewRect.size.height;
        self.viewRect = viewRect;
        [self processImageNameArray];
        [self setupHorizontalScrollView];
    }
    return self;
}
- (void)setupHorizontalScrollView {
    if (_imageCount == 0 || _imageCount > 5) {
        return;
    }
    self.scrollView = [[UIScrollView alloc]initWithFrame:_viewRect];
    self.pageControl = [[SnakePageControl alloc]init];
    
    CGSize pageControlSize = [self.pageControl sizeThatFits:self.scrollView.bounds.size];
    self.pageControl.frame = CGRectMake(_scrollView.frame.size.width-pageControlSize.width-20, self.scrollView.bounds.size.height-pageControlSize.height,pageControlSize.width, pageControlSize.height);
    self.pageControl.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
   
    [_scrollView setContentOffset:CGPointMake(_scrollViewWidth, 0)];
    
  
    
    for (int i = 0; i < self.imageArray.count; i++) {
        
        UIView *views = [[UIView alloc] initWithFrame:CGRectMake((_scrollViewWidth*i), 0,_scrollViewWidth, _scrollViewHeight)];
        UIImageView *tempImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _scrollViewWidth, _scrollViewHeight)];
        [tempImageView sd_setImageWithURL:[NSURL URLWithString: _imageArray[i]]];
        //        UIImage *image = [UIImage imageNamed:_imageArray[i]];
        //        tempImageView.image = image;
        tempImageView.contentMode = UIViewContentModeScaleAspectFill;
        tempImageView.clipsToBounds = YES;
        [views addSubview:tempImageView];
        [_scrollView addSubview:views];
    }
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(_imageArray.count*_scrollViewWidth, 0);
    _scrollView.contentOffset = CGPointMake(_scrollViewWidth, 0);
    _scrollView.bounces = NO;
    
    __weak typeof(self) weakSelf = self;
    //scrollViewDidEndDecelerating
    self.svDidEndDeceler = ^(UIScrollView * _Nonnull svDidEndDe) {
        if (svDidEndDe.contentOffset.x==0) {//滑动到最左边
            [weakSelf.scrollView setContentOffset:CGPointMake(weakSelf.scrollViewWidth*(weakSelf.imageArray.count-2), 0)];
        }else if (svDidEndDe.contentOffset.x==weakSelf.scrollView.contentSize.width-weakSelf.scrollViewWidth){//最右边
            [weakSelf.scrollView setContentOffset:CGPointMake(weakSelf.scrollViewWidth, 0)];
        }
    };
    
    //scrollViewDidEndScrollingAnimation
    self.svDidEndScoAni = ^(UIScrollView * _Nonnull svDidEndScoAni) {
        if (svDidEndScoAni.contentOffset.x==0) {
            [weakSelf.scrollView setContentOffset:CGPointMake(weakSelf.scrollViewWidth*(weakSelf.imageArray.count-2), 0)];
        }else if (svDidEndScoAni.contentOffset.x==weakSelf.scrollView.contentSize.width-weakSelf.scrollViewWidth){
            [weakSelf.scrollView setContentOffset:CGPointMake(weakSelf.scrollViewWidth, 0)];
        }
    };
    //scrollViewDidScroll
    self.svDidScroll = ^(UIScrollView * _Nonnull svDidScroll) {
        CGFloat page = svDidScroll.contentOffset.x / svDidScroll.bounds.size.width;
        CGFloat progressInPage = svDidScroll.contentOffset.x - (page * svDidScroll.bounds.size.width);
        CGFloat progress = (CGFloat)page + progressInPage;
        weakSelf.pageControl.progress = progress;
    };
    
    [self.scrollView addSubview:_pageControl];
    
    if (_imageCount > 1) {
        [self addTimer];
    }
}


-(void)processImageNameArray{
    if (_imageCount == 0) {
        return;
    }else if (_imageCount == 1){
        
    }else if (_imageCount <= 5) {
        NSString *firstObject = _imageArray.firstObject;
        NSString *lastObject = _imageArray.lastObject;
        [_imageArray addObject:firstObject];
        [_imageArray insertObject:lastObject atIndex:0];
    }else{
        return;
    }
}
- (void)addTimer
{
    if (self.timer) {
        return;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(flipToTheNextImage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)invalidateTimer
{
    [self.timer invalidate];
    
    self.timer = nil;
}
- (void)flipToTheNextImage
{
    CGPoint apoint = self.scrollView.contentOffset;
    
    [self.scrollView setContentOffset:CGPointMake(apoint.x+_scrollViewWidth, 0) animated:YES];
    
}

@end
