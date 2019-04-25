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
    _bsBannerView = [[BusinessSelectionBannerView alloc]initWithViewRect:CGRectMake(0, 0, kScreenWidth, kScreenHeight/3) bannerImageNameArray:@[@"1.jpg", @"2.jpg", @"3.jpg", @"4.jpg", @"5.jpg", @"6.jpg", @"7.jpg"]];
    _bsBannerView.scrollView.delegate = self;
    _bsBannerView.delegate = self;
    [self.view addSubview:_bsBannerView.scrollViewWithPaging];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}
-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    _bsBannerView.svBlock(scrollView);
}

- (void)scrolltoIndex:(int)toIndex{
    NSLog(@"Current index %d",toIndex);
}
@end
