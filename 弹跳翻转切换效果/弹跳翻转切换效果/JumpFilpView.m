//
//  JumpFilpView.m
//  弹跳翻转切换效果
//
//  Created by M on 2017/7/11.
//  Copyright © 2017年 dabao. All rights reserved.
//

#import "JumpFilpView.h"

#define jumpDuration 0.125
#define downDuration 0.215


@interface JumpFilpView () <CAAnimationDelegate>

@property (nonatomic, strong) UIImageView *jumpView;
@property (nonatomic, strong) UIImageView *shadowView;

@property (nonatomic, strong) UIImage *markedImage;
@property (nonatomic, strong) UIImage *non_markedImage;

@end

@implementation JumpFilpView {
    BOOL animation;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (UIImage *)markedImage {
    if (!_markedImage) {
        _markedImage = [UIImage imageNamed:@"icon_star_incell"];
    }
    return _markedImage;
}

- (UIImage *)non_markedImage {
    if (!_non_markedImage) {
        _non_markedImage = [UIImage imageNamed:@"blue_dot"];
    }
    return _non_markedImage;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.backgroundColor = [UIColor clearColor];
    if (self.jumpView == nil) {
        self.jumpView = [[UIImageView alloc]initWithFrame:CGRectMake(self.bounds.size.width/2 - (self.bounds.size.width-6)/2, 0, self.bounds.size.width-6, self.bounds.size.height - 6)];
        self.jumpView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:self.jumpView];
        self.state = NONmark;
    }
    if (self.shadowView == nil) {
        self.shadowView = [[UIImageView alloc]initWithFrame:CGRectMake(self.bounds.size.width/2 - 10/2, self.bounds.size.height - 3, 10, 3)];
        self.shadowView.alpha = 0.4;
        self.shadowView.image = [UIImage imageNamed:@"shadow_new"];
        [self addSubview:self.shadowView];
    }
    
}

// 重写setter方法 当state属性改变时，同时改变jumpview显示的图片
- (void)setState:(STATE)state {
    _state = state;
    self.jumpView.image = _state == Mark ? self.markedImage : self.non_markedImage;
}

- (void)animate {
    
    // “当动画开始时，立刻把状态设置为正在动画。禁止在动画的过程中继续触发动画。”
    if (animation == YES) {
        return;
    }
    
    animation = YES;
    
    CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    transformAnimation.fromValue = @(0);
    /* 
     “正数表示逆时针旋转，也就是右侧往里转，左侧往外转”
     “负数表示顺时针旋转，也就是左侧往里转，右侧往外转”
     “所以这里的  @(M_PI_2) 的就是右侧往里转，左侧往外转。”
     */
    transformAnimation.toValue = @(M_PI_2);
    transformAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    
    CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position.y"];
    positionAnimation.fromValue = @(self.jumpView.center.y);
    positionAnimation.toValue = @(self.jumpView.center.y - 14);
    positionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = jumpDuration;
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.removedOnCompletion = NO;
    animationGroup.delegate = self;
    animationGroup.animations = @[transformAnimation, positionAnimation];
    
    [self.jumpView.layer addAnimation:animationGroup forKey:@"jumpUp"];
    
    
}


#pragma mark- CAAnimationDelegate

// 动画开始
- (void)animationDidStart:(CAAnimation *)anim {
    if ([anim isEqual:[self.jumpView.layer animationForKey:@"jumpUp"]]) {
        [UIView animateWithDuration:jumpDuration animations:^{
            self.shadowView.alpha = .2;
            self.shadowView.bounds = CGRectMake(0, 0,_shadowView.bounds.size.width*1.6, _shadowView.bounds.size.height);
        }];
    } else if ([anim isEqual:[self.jumpView.layer animationForKey:@"jumpDown"]]) {
        [UIView animateWithDuration:jumpDuration animations:^{
            self.shadowView.alpha = .4;
            self.shadowView.bounds = CGRectMake(0, 0,_shadowView.bounds.size.width/1.6, _shadowView.bounds.size.height);
        }];
    }
}

// 动画结束时
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if ([anim isEqual:[self.jumpView.layer animationForKey:@"jumpUp"]]) {// 当上弹动画结束进行下落动画
        self.state = self.state == Mark ? NONmark : Mark;
        CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
        transformAnimation.fromValue = @(M_PI_2);
        transformAnimation.toValue = @(M_PI);
        transformAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position.y"];
        positionAnimation.fromValue = @(self.jumpView.center.y - 14);
        positionAnimation.toValue = @(self.jumpView.center.y);
        positionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
        animationGroup.duration = downDuration;
        animationGroup.fillMode = kCAFillModeForwards;
        animationGroup.removedOnCompletion = NO;
        animationGroup.delegate = self;
        animationGroup.animations = @[transformAnimation, positionAnimation];
        
        [self.jumpView.layer addAnimation:animationGroup forKey:@"jumpDown"];
        
        
    } else if ([anim isEqual:[self.jumpView.layer animationForKey:@"jumpDown"]]) {// 当下落动画结束时 remove掉所有动画对象 并将动画状态设置为NO
        [self.jumpView.layer removeAllAnimations];
        animation = NO;
    }
}














@end
