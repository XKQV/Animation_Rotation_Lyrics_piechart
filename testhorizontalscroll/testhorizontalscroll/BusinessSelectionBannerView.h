//
//  BusinessSelectionBannerView.h
//  testhorizontalscroll
//
//  Created by 董志玮 on 2019/4/25.
//  Copyright © 2019 董志玮. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^scrollViewBlock)(UIScrollView *scrollView, CGFloat targetOffset, CGPoint *velosity);
@protocol BSScrollViewDidSelectDelegate <NSObject>

- (void)scrolltoIndex:(int)toIndex;

@end


@interface BusinessSelectionBannerView : NSObject<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *scrollViewWithPaging;
@property (strong, nonatomic) UIPageControl *pageControl;

@property (nonatomic, weak) id<BSScrollViewDidSelectDelegate>delegate;
@property (nonatomic, strong) scrollViewBlock svBlock;

- (instancetype)initWithViewRect:(CGRect)viewRect bannerImageNameArray:(NSArray *)imageNameArray;

@end

NS_ASSUME_NONNULL_END
