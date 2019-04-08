//
//  ViewController.m
//  Animation
//
//  Created by 董志玮 on 2019/4/8.
//  Copyright © 2019 董志玮. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property(nonatomic,strong) NSArray *imageArray;
@property (nonatomic, assign) NSInteger numberOfSong;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _imageArray = @[@"disk", @"guita",@"music", @"musically", @"speaker"];
    _numberOfSong = 0;
    // Do any additional setup after loading the view, typically from a nib.
    _backgroundView.layer.cornerRadius = _backgroundView.frame.size.height/2;
    _rotatingImageView.layer.cornerRadius = _rotatingImageView.frame.size.height/2;
    _rotatingImageView.image = [UIImage imageNamed:_imageArray[_numberOfSong]];
    [self startRotating: _rotatingImageView];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self resumeRotate:_rotatingImageView];
}
// 开始旋转
- (IBAction)previousSong:(id)sender {
    if (_numberOfSong != 0) {
        _numberOfSong--;
        _rotatingImageView.image = [UIImage imageNamed:_imageArray[_numberOfSong]];
        [self startRotating: _rotatingImageView];
    }
    
}

- (IBAction)nextSong:(id)sender {
    if (_numberOfSong != 4) {
        _numberOfSong++;
        _rotatingImageView.image = [UIImage imageNamed:_imageArray[_numberOfSong]];
        [self startRotating: _rotatingImageView];
    }
    
}

- (void)startRotating:(UIImageView *)imageView {
    CABasicAnimation* rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotateAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    rotateAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2];   // 旋转一周
    rotateAnimation.duration = 20.0;                                 // 旋转时间20秒
    rotateAnimation.repeatCount = MAXFLOAT;                          // 重复次数，这里用最大次数
    
    [imageView.layer addAnimation:rotateAnimation forKey:nil];
    
}

// 停止旋转
- (void)stopRotating:(UIImageView *)imageView {
    
    CFTimeInterval pausedTime = [self.rotatingImageView.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    imageView.layer.speed = 0.0;                                          // 停止旋转
    imageView.layer.timeOffset = pausedTime;                              // 保存时间，恢复旋转需要用到
}

// 恢复旋转
- (void)resumeRotate:(UIImageView *)imageView {
    
    if (self.rotatingImageView.layer.timeOffset == 0) {
        [self startRotating:imageView];
        return;
    }
    
    CFTimeInterval pausedTime = self.rotatingImageView.layer.timeOffset;
    imageView.layer.speed = 1.0;                                         // 开始旋转
    imageView.layer.timeOffset = 0.0;
    imageView.layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [imageView.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;                                             // 恢复时间
    imageView.layer.beginTime = timeSincePause;                          // 从暂停的时间点开始旋转
}


@end
