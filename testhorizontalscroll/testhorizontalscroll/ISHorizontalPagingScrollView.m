//
//  ISHorizontalPagingScrollView.m
//  ISHorizontalPagingScrollView
//
//  Created by yoyokko on 6/2/11.
//  Copyright 2011 IntSig Information Co,. Ltd. All rights reserved.
//

#import "ISHorizontalPagingScrollView.h"

#define kColumnPoolSize 3

@interface ISHorizontalPagingScrollView () <UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *pageViews;
@property (nonatomic, assign) NSUInteger physicalPageIndex;
@property (nonatomic, assign) CGFloat columnWidth;
@property (nonatomic, assign) CGFloat columnPadding;
@property (nonatomic, strong) NSMutableArray *columnPool;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITapGestureRecognizer *privateTapGestureRecognizer;

- (void)preparePages;
- (void)layoutPages;
- (void)currentPageIndexWillChange;
- (NSUInteger)numberOfPages;
- (void)layoutPhysicalPage:(NSUInteger)pageIndex;
- (UIView *)viewForPhysicalPage:(NSUInteger)pageIndex;
- (void)removeColumnAtIndex:(NSInteger)pageIndex;
- (CGSize)pageSize;
- (BOOL)isPhysicalPageLoaded:(NSUInteger)pageIndex;
- (void)queueColumnView:(UIView *)view;
- (void)layoutScrollView;
- (CGRect)frameForPageAtIndex:(NSInteger)pageIndex;
- (void)setPhysicalPageIndex:(NSUInteger)physicalPageIndex animated:(BOOL)animated;
- (void)checkIfNeedToFireDidChangeEvent;

@end

@implementation ISHorizontalPagingScrollView

@synthesize pageViews = pageViews_;
@synthesize scrollView = scrollView_;
@synthesize currentPageIndex = currentPageIndex_;
@synthesize columnPool = columnPool_;
@synthesize columnWidth = columnWidth_;
@synthesize delegate = delegate_;
@synthesize dataSource = dataSource_;
@synthesize physicalPageIndex = physicalPageIndex_;
@synthesize columnPadding = columnPadding_;
@synthesize privateTapGestureRecognizer = tapGestureRecognizer_;
@synthesize tapToGo;

- (void)dealloc
{
    dataSource_ = nil;
    delegate_ = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self preparePages];

        columnPadding_ = -1;
        columnWidth_ = -1;

        tapGestureRecognizer_ = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureDidTap:)];
        tapGestureRecognizer_.delegate = (id <UIGestureRecognizerDelegate> )self;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self preparePages];

        columnPadding_ = -1;
        columnWidth_ = -1;

        tapGestureRecognizer_ = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureDidTap:)];
        tapGestureRecognizer_.delegate = (id <UIGestureRecognizerDelegate> )self;
    }
    return self;
}

#pragma mark -- Instance Methods --

- (void)reloadData
{
    [self reloadDataWithStartIndex:currentPageIndex_];
}

- (void)reloadDataWithStartIndex:(NSInteger)index
{
    columnPadding_ = -1;
    columnWidth_ = -1;
    [scrollView_.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.pageViews = [NSMutableArray array];
    NSUInteger numberOfPhysicalPages = [self numberOfPages];
    for (NSUInteger i = 0; i < numberOfPhysicalPages; i++)
    {
        [self.pageViews addObject:[NSNull null]];
    }
    self.columnPool = [NSMutableArray array];

    self.scrollView.frame = self.bounds;
    [self layoutScrollView];
    [self layoutPages];

    currentPageIndex_ = MIN(index, numberOfPhysicalPages - 1);
    [self currentPageIndexWillChange];
    [self scrollToPageIndex:currentPageIndex_ animated:NO];
}

- (UIView *)dequeueColumnView
{
    UIView *view = [columnPool_ lastObject];

    if (view)
    {
        [columnPool_ removeLastObject];
    }
    return view;
}

- (UIView *)pageViewForIndex:(NSInteger)pageIndex
{
    if (pageIndex >= 0 && pageIndex < [pageViews_ count])
    {
        id thePage = [pageViews_ objectAtIndex:pageIndex];
        if (thePage != [NSNull null])
        {
            return thePage;
        }
        else
        {
            return [dataSource_ pagingScrollView:self viewForIndex:pageIndex];
        }
    }
    return nil;
}

- (NSUInteger)pageCount
{
    return [self numberOfPages];
}

- (UITapGestureRecognizer *)tapGestureRecognizer
{
    return tapGestureRecognizer_;
}

- (void)setTapToGo:(BOOL)tapToGoValue
{
    tapToGo = tapToGoValue;
    if (!tapToGo)
    {
        [self removeGestureRecognizer:tapGestureRecognizer_];
    }
    else
    {
        [self addGestureRecognizer:tapGestureRecognizer_];
    }
}

- (void)setScrollEnabled:(BOOL)scrollEnabled
{
    _scrollEnabled = scrollEnabled;
    self.scrollView.scrollEnabled = scrollEnabled;
}

- (void)gestureDidTap:(UITapGestureRecognizer *)gesture
{
    if (self.tapToGo && gesture.state == UIGestureRecognizerStateRecognized)
    {
        [self scrollToNextPage];
    }
}

#pragma mark -- UIGestureRecognizer Delegate Methods --

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    UIView *view = [self hitTest:[gestureRecognizer locationInView:self] withEvent:nil];

    if (view && [self.delegate respondsToSelector:@selector(pagingScrollView:tapToGoShouldStartForTappingView:)])
    {
        return [self.delegate pagingScrollView:self tapToGoShouldStartForTappingView:view];
    }

    return YES;
}

#pragma mark -- Private Methods --

- (NSUInteger)numberOfPages
{
    NSInteger numPages = 0;

    if ([dataSource_ respondsToSelector:@selector(numberOfColumnsForPagingScrollView:)])
    {
        numPages = [dataSource_ numberOfColumnsForPagingScrollView:self];
    }
    else
    {
        [NSException raise:NSInvalidArgumentException format:@"DataSource %@ does not implement numberOfColumnsForPagingScrollView method.", dataSource_];
    }
    return numPages;
}

- (UIView *)viewForPhysicalPage:(NSUInteger)pageIndex
{
    NSParameterAssert(pageIndex >= 0);
    NSParameterAssert(pageIndex < [self.pageViews count]);
    UIView *pageView = nil;
    if ([self.pageViews objectAtIndex:pageIndex] == [NSNull null])
    {
        if ([dataSource_ respondsToSelector:@selector(pagingScrollView:viewForIndex:)])
        {
            pageView = [dataSource_ pagingScrollView:self viewForIndex:pageIndex];
            [self.pageViews replaceObjectAtIndex:pageIndex withObject:pageView];
            [self.scrollView addSubview:pageView];
        }
        else
        {
            [NSException raise:NSInvalidArgumentException format:@"DataSource %@ does not implement pagingScrollView:viewForIndex: method.", dataSource_];
        }
    }
    return pageView;
}

- (CGSize)pageSize
{
    CGRect rect = self.scrollView.bounds;

    return rect.size;
}

- (CGFloat)columnWidth
{
    if (columnWidth_ == -1)
    {
        if ([delegate_ respondsToSelector:@selector(columnWidthForPagingScrollView:)])
        {
            CGFloat width = [delegate_ columnWidthForPagingScrollView:self];
            if (width > [self pageSize].width)
            {
                return [self pageSize].width;
            }
            columnWidth_ = width;
        }
        else
        {
            columnWidth_ = [self pageSize].width;
        }
    }
    return columnWidth_;
}

- (CGFloat)columnPadding
{
    if (columnPadding_ == -1)
    {
        if ([delegate_ respondsToSelector:@selector(columnPaddingForPagingScrollView:)])
        {
            columnPadding_ = [delegate_ columnPaddingForPagingScrollView:self];
            if (columnPadding_ < 0)
            {
                columnPadding_ = 0;
            }
        }
        else
        {
            columnPadding_ = 0;
        }
    }
    return columnPadding_;
}

- (BOOL)isPhysicalPageLoaded:(NSUInteger)pageIndex
{
    return [self.pageViews objectAtIndex:pageIndex] != [NSNull null];
}

- (void)layoutPhysicalPage:(NSUInteger)pageIndex
{
    UIView *pageView = [self viewForPhysicalPage:pageIndex];

    pageView.frame = [self frameForPageAtIndex:pageIndex];
}

- (CGRect)frameForPageAtIndex:(NSInteger)pageIndex
{
    CGFloat padding = [self columnPadding];

    CGSize pageSize = [self pageSize];
    CGFloat columnWidth = [self columnWidth];
    CGRect rect = CGRectMake(pageSize.width * pageIndex + padding, 0, columnWidth, pageSize.height);

    return rect;
}

- (void)queueColumnView:(UIView *)view
{
    if ([self.columnPool count] >= kColumnPoolSize)
    {
        return;
    }
    [self.columnPool addObject:view];
}

- (void)removeColumnAtIndex:(NSInteger)index
{
    if ([self.pageViews objectAtIndex:index] != [NSNull null])
    {
        UIView *view = [self.pageViews objectAtIndex:index];
        [self queueColumnView:view];
        [view removeFromSuperview];
        [self.pageViews replaceObjectAtIndex:index withObject:[NSNull null]];
    }
}

- (void)currentPageIndexWillChange
{
    CGSize pageSize = [self pageSize];
    CGFloat columnWidth = [self columnWidth];

    visibleColumnCount_ = pageSize.width / columnWidth + 1;

    NSInteger leftMostPageIndex = -1;
    NSInteger rightMostPageIndex = 0;

    for (NSInteger i = -1; i < visibleColumnCount_; i++)
    {
        NSInteger index = currentPageIndex_ + i;
        if (index < [pageViews_ count] && index >= 0)
        {
            [self layoutPhysicalPage:index];
            if (leftMostPageIndex < 0)
            {
                leftMostPageIndex = index;
            }
            rightMostPageIndex = index;
        }
    }
    rightMostPageIndex += 1;

    for (NSInteger i = 0; i < leftMostPageIndex; i++)
    {
        [self removeColumnAtIndex:i];
    }

    for (NSInteger i = rightMostPageIndex; i < [pageViews_ count]; i++)
    {
        [self removeColumnAtIndex:i];
    }
    if ([delegate_ respondsToSelector:@selector(pagingScrollView:willScrollToPageIndex:fromPageIndex:)] && self.isDidScrollAndWillScrollDelegateDisable == NO)
    {
        [delegate_ pagingScrollView:self willScrollToPageIndex:currentPageIndex_ fromPageIndex:lastPageIndex_];
    }

    if (!scrollView_.isDragging && !scrollView_.isDecelerating && !isAnimating_)
    {
        if (currentPageIndex_ != lastPageIndex_ && [delegate_ respondsToSelector:@selector(pagingScrollView:didScrollToPageIndex:fromPageIndex:)] && self.isDidScrollAndWillScrollDelegateDisable == NO)
        {
            [delegate_ pagingScrollView:self didScrollToPageIndex:currentPageIndex_ fromPageIndex:lastPageIndex_];
        }
        lastPageIndex_ = currentPageIndex_;
    }
}

- (void)layoutPages
{
    CGSize pageSize = [self pageSize];

    scrollView_.contentSize = CGSizeMake([pageViews_ count] * [self pageSize].width, pageSize.height);
}

- (void)layoutScrollView
{
    CGFloat padding = [self columnPadding];

    CGRect frame = self.bounds;

    frame.size.width = [self columnWidth];
    frame.size.width += (2 * padding);
    frame.origin.y = 0;
    scrollView_.frame = frame;
    scrollView_.center = CGPointMake(self.bounds.size.width / 2.0f, self.bounds.size.height / 2.0f);
}

- (void)preparePages
{
    self.columnPool = [NSMutableArray arrayWithCapacity:kColumnPoolSize];
    columnWidth_ = 0.0f;
    self.clipsToBounds = YES;

    self.autoresizesSubviews = YES;

    scrollView_ = [[UIScrollView alloc] init];
    CGRect rect = self.bounds;
    scrollView_.frame = rect;
    scrollView_.backgroundColor = [UIColor clearColor];
    scrollView_.delegate = self;
    scrollView_.autoresizesSubviews = YES;
    scrollView_.showsVerticalScrollIndicator = NO;
    scrollView_.showsHorizontalScrollIndicator = NO;
    scrollView_.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    scrollView_.pagingEnabled = YES;
    if (@available(iOS 11.0 ,*)) {
        scrollView_.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    _scrollEnabled = YES;
    [self addSubview:scrollView_];
}

- (NSUInteger)physicalPageIndex
{
    CGFloat tempPageIndex = scrollView_.contentOffset.x / [self pageSize].width;
    NSInteger pageIndex = tempPageIndex;

    return (tempPageIndex - pageIndex) >= 0.5 ? pageIndex + 1 : pageIndex;
}

- (void)setPhysicalPageIndex:(NSUInteger)physicalPageIndex
{
    [self setPhysicalPageIndex:physicalPageIndex animated:YES];
}

- (void)setPhysicalPageIndex:(NSUInteger)physicalPageIndex animated:(BOOL)animated
{
    isAnimating_ = animated;
    CGRect frame = [self frameForPageAtIndex:physicalPageIndex];
    CGFloat padding = [self columnPadding];
    [scrollView_ setContentOffset:CGPointMake(frame.origin.x - padding, 0) animated:animated];
}

- (void)scrollToStartPage
{
    [self scrollToPageIndex:0 animated:YES];
}

- (void)scrollToEndPage
{
    [self scrollToPageIndex:([self numberOfPages] - 1) animated:YES];
}

- (void)scrollToNextPage
{
    [self scrollToPageIndex:(currentPageIndex_ + 1) animated:YES];
}

- (void)scrollToPrePage
{
    [self scrollToPageIndex:(currentPageIndex_ - 1) animated:YES];
}

- (void)scrollToPageIndex:(NSInteger)pageIndex animated:(BOOL)animated
{
    if (pageIndex < [self numberOfPages] && pageIndex >= 0)
    {
        [self setPhysicalPageIndex:pageIndex animated:animated];
    }
}

- (void)checkIfNeedToFireDidChangeEvent
{
    NSUInteger newPageIndex = self.physicalPageIndex;

    if (newPageIndex != currentPageIndex_ && newPageIndex < [self numberOfPages])
    {
        lastPageIndex_ = currentPageIndex_;
        [self willChangeValueForKey:@"currentPageIndex"];
        currentPageIndex_ = newPageIndex;
        [self didChangeValueForKey:@"currentPageIndex"];
        [self currentPageIndexWillChange];
    }
}

#pragma mark -- UIScrollView Delegate --

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!isAnimating_)
    {
        [self checkIfNeedToFireDidChangeEvent];
    }

    if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewDidScroll:)])
    {
        [self.scrollViewDelegate scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    isAnimating_ = NO;
    [self checkIfNeedToFireDidChangeEvent];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate && (lastPageIndex_ != currentPageIndex_))
    {
        if ([delegate_ respondsToSelector:@selector(pagingScrollView:didScrollToPageIndex:fromPageIndex:)] && self.isDidScrollAndWillScrollDelegateDisable == NO)
        {
            [delegate_ pagingScrollView:self didScrollToPageIndex:currentPageIndex_ fromPageIndex:lastPageIndex_];
        }
        lastPageIndex_ = currentPageIndex_;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (lastPageIndex_ != currentPageIndex_)
    {
        if ([delegate_ respondsToSelector:@selector(pagingScrollView:didScrollToPageIndex:fromPageIndex:)] && self.isDidScrollAndWillScrollDelegateDisable == NO)
        {
            [delegate_ pagingScrollView:self didScrollToPageIndex:currentPageIndex_ fromPageIndex:lastPageIndex_];
        }
        lastPageIndex_ = currentPageIndex_;
    }
}

@end
