//
//  SnakePageControl.h
//  BSHorizontalScrollView
//
//  Created by 董志玮 on 2019/4/28.
//  Copyright © 2019 董志玮. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SnakePageControl : UIView

@property (assign, nonatomic) int pageCount;

@property (assign, nonatomic) CGFloat progress;

@property (assign, nonatomic) int currentPage;

@property (readonly, nonatomic) UIColor *activeTint;

@property (readonly, nonatomic) UIColor *inactiveTint;

@property (assign, nonatomic) CGFloat indicatorPadding;

@property (assign, nonatomic) CGFloat indicatorRadius;

-(CGSize)intrinsicContentSize;

-(CGSize)sizeThatFits:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
