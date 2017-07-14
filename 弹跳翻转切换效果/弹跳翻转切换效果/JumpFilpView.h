//
//  JumpFilpView.h
//  弹跳翻转切换效果
//
//  Created by M on 2017/7/11.
//  Copyright © 2017年 dabao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    NONmark,
    Mark,
} STATE;


@interface JumpFilpView : UIView

@property (nonatomic, assign, setter=setState:) STATE state;


- (void)animate;




@end
