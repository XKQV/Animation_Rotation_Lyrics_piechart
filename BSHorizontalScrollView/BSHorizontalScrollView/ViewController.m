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
@interface ViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *myscrollView;

@property (nonatomic,strong)NSArray *colorsArray;
@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic, strong) BSHorizontalScrollView *bsBannerView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //    self.myscrollView.delegate = self;
    _bsBannerView = [[BSHorizontalScrollView alloc]initWithViewRect:CGRectMake(0, 0, kScreenWidth, kScreenHeight/3) bannerImageNameArray: @[                                                                                                                                           @"https://www.gstatic.com/webp/gallery/4.sm.jpg", @"https://www.gstatic.com/webp/gallery3/2.sm.png",@"https://www.gstatic.com/webp/gallery/1.sm.jpg",@"https://www.gstatic.com/webp/gallery/5.sm.jpg"]];
    //  @[@"1.jpg",@"2.jpg",@"3.jpg"]];
    
    _bsBannerView.scrollView.delegate = self;
    [self.view addSubview:_bsBannerView.scrollView];
    [self.view addSubview:_bsBannerView.pageControl];
}
/*
 假设  scrollview展示三个View  红 黄 蓝
 这里 最左边加个 蓝 右边加个红 用于循环
 
 
 
 /**
 *  开启定时器
 */
/**
 *  手动 拖拽scrollView 调用
 *
 *  @param scrollView <#scrollView description#>
 */
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"Scroll");
    _bsBannerView.svDidScroll(scrollView);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"EndDecelerating");
    _bsBannerView.svDidEndDeceler(scrollView);
    
}
/**
 *  定时器 以动画形式改变scrollview的contentOffset 调用
 *
 *  @param scrollView <#scrollView description#>
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSLog(@"EndScrollingAnimation");
    _bsBannerView.svDidEndScoAni(scrollView);
    
}
/**
 *  开始拖拽
 *
 *  @param scrollView <#scrollView description#>
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"WillBeginDragging");
    [_bsBannerView  invalidateTimer];
}
/**
 *  结束拖拽
 *
 *  @param scrollView <#scrollView description#>
 *  @param decelerate <#decelerate description#>
 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
        NSLog(@"EndDragging");
    [_bsBannerView addTimer];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
