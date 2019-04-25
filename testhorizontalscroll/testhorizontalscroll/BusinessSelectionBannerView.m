//
//  BusinessSelectionBannerView.m
//  testhorizontalscroll
//
//  Created by 董志玮 on 2019/4/25.
//  Copyright © 2019 董志玮. All rights reserved.
//

#import "BusinessSelectionBannerView.h"


@interface BusinessSelectionBannerView()


@property (strong, nonatomic) NSArray<NSString *> *imageNameArray;
@property (assign, nonatomic) int imageCount;
@property (assign, nonatomic) CGRect *viewRect;

@end


@implementation BusinessSelectionBannerView


-(instancetype)initWithViewRect:(CGRect)viewRect bannerImageNameArray:(NSArray *)imageNameArray {
    
    self = [super init];
    if (self) {
        _imageNameArray = imageNameArray;
        _imageCount = (int)imageNameArray.count;
        [self setupHorizontalScrollViewWithRect:viewRect];
    }
    return self;
}

- (void)setupHorizontalScrollViewWithRect:(CGRect)viewRect {
    
    self.scrollViewWithPaging = [[UIView alloc]initWithFrame:viewRect];
    //scrollview
    self.scrollView = [[UIScrollView alloc]initWithFrame:viewRect];
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * _imageCount,_scrollView.frame.size.height);
    _scrollView.pagingEnabled=YES;
    _scrollView.backgroundColor = [UIColor clearColor];
    
    int i = 0;
    while (i<=6) {
        
        UIView *views = [[UIView alloc] initWithFrame:CGRectMake(((_scrollView.frame.size.width)*i), 0,(_scrollView.frame.size.width), _scrollView.frame.size.height)];
        views.backgroundColor=[UIColor yellowColor];
        [views setTag:i];
        UIImageView *tempImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, views.frame.size.width, views.frame.size.height)];
        tempImageView.image = [UIImage imageNamed:_imageNameArray[i]];
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
    self.pageControl.numberOfPages = _imageCount;
    CGSize pageControlSize = [self.pageControl sizeThatFits:self.scrollView.bounds.size];
    self.pageControl.frame = CGRectMake(_scrollView.frame.size.width-pageControlSize.width-20, self.scrollView.bounds.size.height-pageControlSize.height,pageControlSize.width, pageControlSize.height);
    self.pageControl.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    self.pageControl.pageIndicatorTintColor = [UIColor redColor];
    [_scrollViewWithPaging addSubview:_scrollView];
    [_scrollViewWithPaging addSubview:_pageControl];
    
    __weak typeof(self) weakSelf = self;
    _svBlock =^(UIScrollView *scrollView,CGFloat targetOffset, CGPoint *velosity) {
        float width = scrollView.frame.size.width;
        int toIndex = (int)targetOffset/width;
        
        
        NSLog(@"To index %d",toIndex);
        if (toIndex == weakSelf.imageCount-1 && velosity->x > 0 ) {
            toIndex = 0;
            dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf scrollToIndex:toIndex];
            });
        }else if (toIndex == 0 && velosity->x < 0 ){
            toIndex = weakSelf.imageCount-1;
            dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf scrollToIndex:toIndex];
            });
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf scrollToIndex:toIndex];
            });
        }
    };
}
- (void)scrollToIndex: (int)toIndex{
    self.pageControl.currentPage = toIndex;
    self.scrollView.contentOffset = CGPointMake((_scrollView.frame.size.width)*toIndex, 0);
}
-(void)didSelectItem{
    if ([self.delegate respondsToSelector:@selector(scrolltoIndex:)]) {
        int scrollToIndex = (int)(_scrollView.contentOffset.x/_scrollView.frame.size.width);
        [self.delegate scrolltoIndex:scrollToIndex];
    }
}





@end
