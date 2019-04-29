//
//  ViewController.m
//  BSHorizontalScrollView
//
//  Created by 董志玮 on 2019/4/28.
//  Copyright © 2019 董志玮. All rights reserved.
//

#import "ViewController.h"
#import "BSHorizontalScrollView.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
@interface ViewController ()<UIScrollViewDelegate,BSScrollViewDidSelectDelegate>

@property (nonatomic,strong)NSArray *colorsArray;
@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic, strong) BSHorizontalScrollView *bsBannerView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //    self.myscrollView.delegate = self;
    _bsBannerView = [[BSHorizontalScrollView alloc]initWithViewRect:CGRectMake(0, 0, kScreenWidth, kScreenWidth / 1.7) bannerImageNameArray: @[                                                                                                                                           @"https://placeimg.com/640/480/arch?t=1556506795233",@"https://www.gstatic.com/webp/gallery/1.sm.jpg",@"https://placeimg.com/640/480/any?t=1556506681405",@"https://placeimg.com/640/480/animals",@"1.jpg"]];
    //        _bsBannerView = [[BSHorizontalScrollView alloc]initWithViewRect:CGRectMake(0, 0, kScreenWidth, kScreenHeight/3) bannerImageNameArray: @[                                                                                                                                            @"https://homepages.cae.wisc.edu/~ece533/images/mountain.png",@"https://www.gstatic.com/webp/gallery/1.sm.jpg",@"https://www.gstatic.com/webp/gallery/5.sm.jpg",@"https://homepages.cae.wisc.edu/~ece533/images/pool.png"]];
    //            _bsBannerView = [[BSHorizontalScrollView alloc]initWithViewRect:CGRectMake(0, 0, kScreenWidth, kScreenHeight/3) bannerImageNameArray: @[                                                                                                                                            @"https://homepages.cae.wisc.edu/~ece533/images/mountain.png",@"https://www.gstatic.com/webp/gallery/5.sm.jpg",@"https://homepages.cae.wisc.edu/~ece533/images/pool.png"]];
//                _bsBannerView = [[BSHorizontalScrollView alloc]initWithViewRect:CGRectMake(0, 0, kScreenWidth, kScreenHeight/3) bannerImageNameArray: @[                                                                                                                                            @"https://homepages.cae.wisc.edu/~ece533/images/mountain.png",@"https://homepages.cae.wisc.edu/~ece533/images/pool.png"]];
    //
//            _bsBannerView = [[BSHorizontalScrollView alloc]initWithViewRect:CGRectMake(0, 0, kScreenWidth, kScreenHeight/3) bannerImageNameArray: @[                                                                                                                                           @"https://www.gstatic.com/webp/gallery/4.sm.jpg"]];
    
    //  @[@"1.jpg",@"2.jpg",@"3.jpg"]];
    
    _bsBannerView.scrollView.delegate = self;
    _bsBannerView.delegate = self;
    [self.view addSubview:_bsBannerView.scrollViewWithPaging];

}



- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //    NSLog(@"EndDecelerating");
    if (scrollView.tag == 1) {
        _bsBannerView.svDidEndDeceler(scrollView);
    }
}

// 定时器 以动画形式改变scrollview的contentOffset 调用

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    //    NSLog(@"EndScrollingAnimation");
    if (scrollView.tag == 1) {
        _bsBannerView.svDidEndScoAni(scrollView);
    }
}

//开始拖拽

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //    NSLog(@"WillBeginDragging");
    if (scrollView.tag == 1) {
        [_bsBannerView  invalidateTimer];
    }
}

//结束拖拽

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //        NSLog(@"EndDragging");
    if (scrollView.tag == 1) {
        [_bsBannerView addTimer];
    }
}

-(void)selectedAtIndex:(int)atIndex {
    NSLog(@"selected at index %d",atIndex);
}

@end
