//
//  SnakePageControl.m
//  BSHorizontalScrollView
//
//  Created by 董志玮 on 2019/4/28.
//  Copyright © 2019 董志玮. All rights reserved.
//

#import "SnakePageControl.h"

@interface SnakePageControl()

@property (nonatomic, strong) NSMutableArray *inactiveLayers;
@property (nonatomic, strong) CALayer *activeLayer;

@end

@implementation SnakePageControl



- (void)setPageCount:(int)pageCount {
   
    [self setupParameters];
    [self updateNumberOfPages:pageCount];

}

- (void)setupParameters {
    _inactiveLayers = [NSMutableArray new];
    _activeLayer = [CALayer new];

    
}

- (void)setProgress:(CGFloat)progress {
    [self layoutActivePageIndicator:progress];
}

- (int)currentPage {
    return roundf(_progress);
}
    // MARK: - Appearance

-(UIColor *)activeTint {
    return [UIColor whiteColor];
}

-(UIColor *)inactiveTint {
    return [UIColor colorWithWhite:1.0 alpha:0.3];
}

-(CGFloat)indicatorPadding {
    return 10.0;
}

-(CGFloat)indicatorRadius {
    return 5;
}

-(CGFloat)indicatorDiameter {
    return [self indicatorRadius] * 2;
}

-(CALayer *)activeLayer {
    
    CALayer *layer = [CALayer new];
    layer.frame = CGRectMake(0, 0, [self indicatorRadius] * 2, [self indicatorRadius] * 2);
    
    layer.backgroundColor = self.activeTint.CGColor;
    layer.cornerRadius = self.indicatorRadius;
//    layer.actions = [
//                     "bounds": NSNull,
//                     "frame": NSNull(),
//                     "position": NSNull()]
    return layer;
    
}

- (void)updateNumberOfPages:(int)count {
    // no need to update
    if (count == _inactiveLayers.count ) {
        return;
    }
    for (CALayer *layer in _inactiveLayers) {
        [layer removeFromSuperlayer];
    }
    [_inactiveLayers removeAllObjects];
    for (int i = 0; i < count; i++) {
        CALayer *layer = [CALayer new];
        layer.backgroundColor = [self inactiveTint].CGColor;
//        [self.layer addSublayer:layer];
        [_inactiveLayers addObject:layer];
        
    }
    [self layoutInactivePageIndicators:_inactiveLayers];
    [self.layer addSublayer:[self activeLayer]];
    [self layoutActivePageIndicator:_progress];
    [self invalidateIntrinsicContentSize];

}
- (void)layoutActivePageIndicator:(CGFloat)progress {
    // ignore if progress is outside of page indicators' bounds
    if (progress <= 0 && progress >= _pageCount -1 ) {
        return;
    }
    CGFloat denormalizedProgress = progress * ([self indicatorDiameter] + [self indicatorPadding]);
    
    CGFloat distanceFromPage = fabs(round(progress) - progress);
    
    CGFloat width = [self indicatorDiameter] + [self indicatorPadding] * (distanceFromPage *2);
    
    CGRect newFrame = CGRectMake(0, [self activeLayer].frame.origin.y, width, [self indicatorDiameter]);
    
    newFrame.origin.x = denormalizedProgress;
    
    _activeLayer.cornerRadius = [self indicatorRadius];
    _activeLayer.frame = newFrame;
    
}

- (void)layoutInactivePageIndicators:(NSMutableArray *)layers {
    
    CGRect layerFrame = CGRectMake(0, 0, [self indicatorDiameter], [self indicatorDiameter]);
    for (CALayer *layer in layers) {
        layer.cornerRadius = [self indicatorRadius];
        layer.frame = layerFrame;
        layerFrame.origin.x += [self indicatorDiameter] + [self indicatorPadding] ;
    }
    
}

-(CGSize)intrinsicContentSize{
    
    return  [self sizeThatFits:CGSizeZero];
}

-(CGSize)sizeThatFits:(CGSize)size {
    
    return CGSizeMake( _inactiveLayers.count * [self indicatorDiameter] + (CGFloat)(_inactiveLayers.count - 1) * [self indicatorPadding] , [self indicatorDiameter]);
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
