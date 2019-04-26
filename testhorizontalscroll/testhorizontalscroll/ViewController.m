//
//  ViewController.m
//  testhorizontalscroll
//
//  Created by 董志玮 on 2019/4/24.
//  Copyright © 2019 董志玮. All rights reserved.
//

#import "ViewController.h"
#import "BusinessSelectionBannerView.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height


@interface ViewController ()<UIScrollViewDelegate,BSScrollViewDidSelectDelegate>
@property (nonatomic,strong) BusinessSelectionBannerView *bsBannerView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _bsBannerView = [[BusinessSelectionBannerView alloc]initWithViewRect:CGRectMake(0, 0, kScreenWidth, kScreenHeight/3) bannerImageNameArray:@[@"1.jpg", @"2.jpg", @"3.jpg"]];
    _bsBannerView.scrollView.delegate = self;
    _bsBannerView.delegate = self;
    [self.view addSubview:_bsBannerView.scrollViewWithPaging];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
        _bsBannerView.bfScrollIndex = scrollView.contentOffset.x/scrollView.frame.size.width;
    
    [_bsBannerView cancelTimer];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    _bsBannerView.svEndDeceBlock(scrollView);

}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    CGFloat targetOffset = targetContentOffset->x;
    CGFloat targetVelocity = velocity.x;
    _bsBannerView.svBlock(targetVelocity, targetOffset);
//    NSLog(@"dragIndex %d",currentIndex);
    [_bsBannerView startTimerWithScrollView:scrollView];

}

- (void)selectedAtIndex:(int)atIndex{
    NSLog(@"Current selected index %d",atIndex);
}
@end
