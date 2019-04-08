//
//  ViewController.h
//  Animation
//
//  Created by 董志玮 on 2019/4/8.
//  Copyright © 2019 董志玮. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *rotatingImageView;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundView;
- (IBAction)previousSong:(id)sender;
- (IBAction)nextSong:(id)sender;

- (void) startRotating: (UIImageView *)imageView;
- (void)stopRotating:(UIImageView *)imageView;
- (void)resumeRotate:(UIImageView *)imageView;

@end

