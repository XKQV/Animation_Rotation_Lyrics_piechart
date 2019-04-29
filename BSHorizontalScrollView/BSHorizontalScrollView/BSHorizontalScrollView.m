//
//  BSHorizontalScrollView.m
//  lunboScrollView
//
//  Created by 董志玮 on 2019/4/26.
//  Copyright © 2019 chao. All rights reserved.
//

#import "BSHorizontalScrollView.h"
#import "SDWebImage.h"
#import "Masonry.h"

@interface BSHorizontalScrollView()
@property (assign, nonatomic) CGFloat scrollViewWidth;
@property (assign, nonatomic) CGFloat scrollViewHeight;
@property (assign, nonatomic) NSUInteger imageCount;
@end


@implementation BSHorizontalScrollView

- (instancetype)initWithViewRect:(CGRect)viewRect bannerImageNameArray:(NSArray *)imageNameArray{
    self = [super init];
    if (self) {
        if (imageNameArray.count == 0 || imageNameArray.count > 5) {
            return self;
        }
        self.imageArray = imageNameArray.mutableCopy;
        self.scrollViewWidth = viewRect.size.width;
        self.scrollViewHeight = viewRect.size.height;
        self.viewRect = viewRect;
        [self processImageNameArray];
        [self setupHorizontalScrollView];
    }
    return self;
}
- (void)setupHorizontalScrollView {
    if (_imageCount == 0 || _imageCount > 7) {
        return;
    }
    //setup scroll view
    self.scrollViewWithPaging = [[UIView alloc]initWithFrame:_viewRect];
    self.scrollView = [[UIScrollView alloc]initWithFrame:_viewRect];
    
    for (int i = 0; i < self.imageArray.count; i++) {
        
        UIView *views = [[UIView alloc] initWithFrame:CGRectMake((_scrollViewWidth*i), 0,_scrollViewWidth, _scrollViewHeight)];
        UIImageView *tempImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _scrollViewWidth, _scrollViewHeight)];
        
        if ([self isValidURL:_imageArray[i]]) {
            [tempImageView sd_setImageWithURL:[NSURL URLWithString: _imageArray[i]]];
        }else{
            tempImageView.image = [UIImage imageNamed:_imageArray[i]];
        }
        tempImageView.contentMode = UIViewContentModeScaleAspectFill;
        tempImageView.clipsToBounds = YES;
        [views addSubview:tempImageView];
        [_scrollView addSubview:views];
    }
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(_imageArray.count * _scrollViewWidth, 0);
    _scrollView.bounces = NO;
    _scrollView.tag = 1;
    
    //Add tap gesture
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectItem)];
    [_scrollView addGestureRecognizer: singleTap];
    [self.scrollViewWithPaging addSubview:_scrollView];
    
    //setup page control and add timer if there are more than one images
    if (_imageCount > 1) {
        self.pageControl = [[UIPageControl alloc]init];
        self.pageControl.numberOfPages = _imageCount - 2;
        self.pageControl.pageIndicatorTintColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
        self.pageControl.currentPageIndicatorTintColor  = [UIColor colorWithRed:0.11 green:0.66 blue:1.00 alpha:1.0];
        
        //add pagecontrol
        [self.scrollViewWithPaging addSubview:_pageControl];
        
        _scrollView.contentOffset = CGPointMake(_scrollViewWidth, 0);
        
        [self addTimer];
    } else if (_imageCount == 1){
        _scrollView.contentOffset = CGPointMake(0, 0);
    }
    __weak typeof(self) weakSelf = self;
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.scrollViewWithPaging);
        make.bottom.equalTo(self.scrollViewWithPaging).offset(-5);
    }];
    
    //scrollViewDidEndDecelerating
    self.svDidEndDeceler = ^(UIScrollView * _Nonnull svDidEndDe) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (svDidEndDe.contentOffset.x == 0) {//滑动到最左边
                [weakSelf.scrollView setContentOffset:CGPointMake(weakSelf.scrollViewWidth*(weakSelf.imageArray.count-2), 0)];
            }else if (svDidEndDe.contentOffset.x == weakSelf.scrollView.contentSize.width-weakSelf.scrollViewWidth){//最右边
                [weakSelf.scrollView setContentOffset:CGPointMake(weakSelf.scrollViewWidth, 0)];
            }
            NSInteger page = svDidEndDe.contentOffset.x / weakSelf.scrollViewWidth;
            weakSelf.pageControl.currentPage = page -1;
        });
        
    };
    
    //scrollViewDidEndScrollingAnimation
    self.svDidEndScoAni = ^(UIScrollView * _Nonnull svDidEndScoAni) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (svDidEndScoAni.contentOffset.x == 0) {
                [weakSelf.scrollView setContentOffset:CGPointMake(weakSelf.scrollViewWidth*(weakSelf.imageArray.count-2), 0)];
            }else if (svDidEndScoAni.contentOffset.x == weakSelf.scrollView.contentSize.width-weakSelf.scrollViewWidth){
                [weakSelf.scrollView setContentOffset:CGPointMake(weakSelf.scrollViewWidth, 0)];
            }
            NSInteger page = svDidEndScoAni.contentOffset.x / weakSelf.scrollViewWidth;
            weakSelf.pageControl.currentPage = page - 1;
        });
        
    };
    //scrollViewDidScroll
    self.svDidScroll = ^(UIScrollView * _Nonnull svDidScroll) {
        
        
    };
    
    
}

-(BOOL)isValidURL:(NSString *)urlString{
    NSURL *url = [NSURL URLWithString:urlString];
    if (url && url.scheme && url.host)
    {
        return true;
    }
    return false;
}

-(void)processImageNameArray{
    if (_imageArray.count == 0) {
        return;
    }else if (_imageArray.count == 1){
        _imageCount = _imageArray.count;
    }else if (_imageArray.count <= 5) {
        NSString *firstObject = _imageArray.firstObject;
        NSString *lastObject = _imageArray.lastObject;
        [_imageArray addObject:firstObject];
        [_imageArray insertObject:lastObject atIndex:0];
        _imageCount = _imageArray.count;
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

-(void)didSelectItem{
    if ([self.delegate respondsToSelector:@selector(selectedAtIndex:)]) {
        int selectedIndex = (int)(_scrollView.contentOffset.x/_scrollView.frame.size.width);
        if (selectedIndex >= 1) {
            [self.delegate selectedAtIndex:selectedIndex - 1];
        } else {
            [self.delegate selectedAtIndex:0];
        }
        
    }
}
@end
