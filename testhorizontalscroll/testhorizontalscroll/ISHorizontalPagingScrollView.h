//
//  ISHorizontalPagingScrollView.h
//  ISHorizontalPagingScrollView
//
//  Created by yoyokko on 6/2/11.
//  Copyright 2011 IntSig Information Co,. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ISHorizontalPagingScrollView;

@protocol ISHorizontalPagingScrollViewDelegate <NSObject>

@optional
- (CGFloat)columnPaddingForPagingScrollView:(ISHorizontalPagingScrollView *)pagingScrollView;
- (BOOL)pagingScrollView:(ISHorizontalPagingScrollView *)pagingScrollView tapToGoShouldStartForTappingView:(UIView *)tappingView;
- (void)pagingScrollView:(ISHorizontalPagingScrollView *)pagingScrollView willScrollToPageIndex:(NSInteger)index1 fromPageIndex:(NSInteger)index2;
- (void)pagingScrollView:(ISHorizontalPagingScrollView *)pagingScrollView didScrollToPageIndex:(NSInteger)index1 fromPageIndex:(NSInteger)index2;
- (CGFloat)columnWidthForPagingScrollView:(ISHorizontalPagingScrollView *)pagingScrollView;

@end

@protocol ISHorizontalPagingScrollViewDataSource <NSObject>

- (NSInteger)numberOfColumnsForPagingScrollView:(ISHorizontalPagingScrollView *)pagingScrollView;
- (UIView *)pagingScrollView:(ISHorizontalPagingScrollView *)pagingScrollView viewForIndex:(NSInteger)index;

@end

@interface ISHorizontalPagingScrollView : UIView
{
    @private
    NSMutableArray *pageViews_;
    UIScrollView *scrollView_;
    NSUInteger lastPageIndex_;
    NSUInteger currentPageIndex_;
    NSUInteger physicalPageIndex_;

    NSInteger visibleColumnCount_;
    CGFloat columnWidth_;
    CGFloat columnPadding_;

    NSMutableArray *columnPool_;

    BOOL isAnimating_;

    id <ISHorizontalPagingScrollViewDelegate> __weak delegate_;
    id <ISHorizontalPagingScrollViewDataSource> __weak dataSource_;

    UITapGestureRecognizer *tapGestureRecognizer_;
}

@property (nonatomic, assign) BOOL isDidScrollAndWillScrollDelegateDisable; // Default is NO, if set to YES, willScroll & didScroll will not post to delegate
@property (nonatomic, readonly) UIScrollView *scrollView;
@property (nonatomic, weak) id<ISHorizontalPagingScrollViewDataSource> dataSource;
@property (nonatomic, weak) id<ISHorizontalPagingScrollViewDelegate> delegate;
@property (nonatomic, weak) id<UIScrollViewDelegate> scrollViewDelegate;
@property (nonatomic, readonly) NSUInteger currentPageIndex;
@property (nonatomic, readonly) NSUInteger pageCount;
@property (weak, nonatomic, readonly) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, assign) BOOL tapToGo; // default is NO. If set to YES, tapping on PagingScrollView will make it scroll to nextpage.
@property (nonatomic, assign) BOOL scrollEnabled;

- (UIView *)pageViewForIndex:(NSInteger)pageIndex;
- (void)reloadDataWithStartIndex:(NSInteger)index;
- (void)reloadData;
- (UIView *)dequeueColumnView;
- (void)scrollToPageIndex:(NSInteger)pageIndex animated:(BOOL)animated;
- (void)scrollToNextPage;
- (void)scrollToPrePage;
- (void)scrollToStartPage;
- (void)scrollToEndPage;

@end
