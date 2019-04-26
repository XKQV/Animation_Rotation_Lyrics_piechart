//
//  BusinessSelectionBannerView.m
//  testhorizontalscroll
//
//  Created by 董志玮 on 2019/4/25.
//  Copyright © 2019 董志玮. All rights reserved.
//

#import "BusinessSelectionBannerView.h"
#import "SDWebImage.h"

@interface BusinessSelectionBannerView()


@property (strong, nonatomic) NSMutableArray<NSString *> *imageNameArray;
@property (assign, nonatomic) CGRect viewRect;
@property (assign, nonatomic) CGFloat scrollViewWidth;
@property (assign, nonatomic) BOOL  isGoForward;

@end


@implementation BusinessSelectionBannerView


-(instancetype)initWithViewRect:(CGRect)viewRect bannerImageNameArray:(NSArray *)imageNameArray {
    
    self = [super init];
    if (self) {
        _imageNameArray = imageNameArray.mutableCopy;
        [self processImageNameArray];
        self.scrollViewWidth = viewRect.size.width;
        self.viewRect = viewRect;
        [self setupHorizontalScrollViewWithRect:viewRect];
    }
    return self;
}
- (void)startTimerWithScrollView:(UIScrollView *)scrollView{
    __weak typeof(self) weakSelf = self;
    int index;
    if (scrollView) {
        index = scrollView.contentOffset.x/scrollView.frame.size.width;
    }else{
        index = 1;
    }

    //    NSLog(@"bfindex is %d, indexpassed %d",_bfScrollIndex,index);
    if (index == _imageCount-2) {
        _bfScrollIndex = 1;
    }else{
        _bfScrollIndex = index;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        
        NSLog(@"bfindex %d",weakSelf.bfScrollIndex);
        if (weakSelf.bfScrollIndex < (weakSelf.imageCount -2) && weakSelf.bfScrollIndex){
            weakSelf.bfScrollIndex ++;
            [weakSelf.scrollView setContentOffset:CGPointMake(weakSelf.bfScrollIndex * weakSelf.scrollView.frame.size.width, 0) animated:YES];
            weakSelf.pageControl.currentPage = weakSelf.bfScrollIndex-1;
            
        }else if (weakSelf.bfScrollIndex == weakSelf.imageCount -2 || weakSelf.bfScrollIndex == 0){
            weakSelf.bfScrollIndex ++;
            weakSelf.pageControl.currentPage = 0;
//            weakSelf.pageControl.transform = CGAffineTransformMakeScale(1.5, 1.0);
            
            [weakSelf.scrollView setContentOffset:CGPointMake(weakSelf.bfScrollIndex * weakSelf.scrollView.frame.size.width, 0) animated:YES];
            [weakSelf.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
            [weakSelf.scrollView setContentOffset:CGPointMake(weakSelf.scrollView.frame.size.width, 0) animated:YES];
            weakSelf.bfScrollIndex = 1;
        };
    }];
}


- (void)cancelTimer {
    [self.timer invalidate];
    _timer = nil;
}
-(void)processImageNameArray{
    NSString *firstObject = _imageNameArray.firstObject;
    NSString *lastObject = _imageNameArray.lastObject;
    [_imageNameArray addObject:firstObject];
    [_imageNameArray insertObject:lastObject atIndex:0];
    self.imageCount = (int)_imageNameArray.count;
    if (_imageCount > 3) {
        [self startTimerWithScrollView:nil];
    }
}

- (void)setupHorizontalScrollViewWithRect:(CGRect)viewRect {
    
    self.scrollViewWithPaging = [[UIView alloc]initWithFrame:viewRect];
    //scrollview
    self.scrollView = [[UIScrollView alloc]initWithFrame:viewRect];
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * _imageNameArray.count,_scrollView.frame.size.height);
    _scrollView.pagingEnabled=YES;
    _scrollView.backgroundColor = [UIColor clearColor];
    
    int i = 0;
    while (i<_imageCount) {
        
        UIView *views = [[UIView alloc] initWithFrame:CGRectMake(((_scrollView.frame.size.width)*i), 0,(_scrollView.frame.size.width), _scrollView.frame.size.height)];
        views.backgroundColor=[UIColor clearColor];
        [views setTag:i];
        UIImageView *tempImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, views.frame.size.width, views.frame.size.height)];
        
        [tempImageView sd_setImageWithURL:[NSURL URLWithString: _imageNameArray[i]]];
        tempImageView.contentMode = UIViewContentModeScaleAspectFill;
        tempImageView.clipsToBounds = YES;
        [views addSubview:tempImageView];
        [_scrollView addSubview:views];
        i++;
    }
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectItem)];
    [_scrollView addGestureRecognizer: singleTap];
    _scrollView.indicatorStyle = UIScrollViewIndicatorStyleDefault;
    _scrollView.showsHorizontalScrollIndicator = false;
    
    //page control
    self.pageControl = [[UIPageControl alloc]init];
    self.pageControl.numberOfPages = _imageNameArray.count-2;
    CGSize pageControlSize = [self.pageControl sizeThatFits:self.scrollView.bounds.size];
    self.pageControl.frame = CGRectMake(_scrollView.frame.size.width-pageControlSize.width-20, self.scrollView.bounds.size.height-pageControlSize.height,pageControlSize.width, pageControlSize.height);
    self.pageControl.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [_scrollViewWithPaging addSubview:_scrollView];
    [_scrollViewWithPaging addSubview:_pageControl];
    [_scrollView setContentOffset:CGPointMake(_scrollViewWidth, 0)];
    self.pageControl.pageIndicatorTintColor = [UIColor redColor];
   
    
    if (self.imageCount <= 3) {
        _scrollView.scrollEnabled = false;
        _scrollView.pagingEnabled = false;
        [_pageControl removeFromSuperview];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    _svBlock = ^(CGFloat velocity, CGFloat offset){
        int toIndex = offset/weakSelf.scrollViewWidth;
        //                NSLog(@"velocity is %f,offset is %f",velocity,offset);
        //                NSLog(@"toindex is %d,bfscrollindex is %d",toIndex,weakSelf.bfScrollIndex);
        
        if (toIndex < weakSelf.bfScrollIndex) {
            NSLog(@"go back");
            weakSelf.isGoForward = false;
        }else{
            NSLog(@"go forward");
            weakSelf.isGoForward = true;
        }
        
        if (toIndex == weakSelf.imageCount-1 && weakSelf.bfScrollIndex == weakSelf.imageCount-2) {
            NSLog(@"to the first");
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.pageControl.currentPage = 0;
            });
        }else if (toIndex == 0 && weakSelf.bfScrollIndex == 1){
            NSLog(@"to the last");
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.pageControl.currentPage = weakSelf.imageCount-2;
            });
        }else{
            NSLog(@"normal %d",toIndex);
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.pageControl.currentPage = toIndex-1;
            });
        }
    };
    
    _svEndDeceBlock = ^(UIScrollView *scrollView){
        dispatch_async(dispatch_get_main_queue(), ^{
            int currentIndex = scrollView.contentOffset.x / scrollView.frame.size.width;
            //            NSLog(@"Current index2 %d",currentIndex);
            if (currentIndex == 0) {
                
                [weakSelf.scrollView setContentOffset:CGPointMake((weakSelf.imageCount - 2)*scrollView.frame.size.width, 0) animated:false];
            }
            if (currentIndex == (weakSelf.imageCount - 1)) {
                
                [weakSelf.scrollView setContentOffset:CGPointMake(scrollView.frame.size.width, 0) animated:false];
                
            }
        });
        
    };
    
}

-(void)didSelectItem{
    if ([self.delegate respondsToSelector:@selector(selectedAtIndex:)]) {
        int selectedIndex = (int)(_scrollView.contentOffset.x/_scrollView.frame.size.width);
        [self.delegate selectedAtIndex:selectedIndex - 1];
    }
}




@end
