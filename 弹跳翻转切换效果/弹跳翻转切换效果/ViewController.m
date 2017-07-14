//
//  ViewController.m
//  弹跳翻转切换效果
//
//  Created by M on 2017/7/11.
//  Copyright © 2017年 dabao. All rights reserved.
//

#import "ViewController.h"
#import "JumpFilpView.h"

@interface ViewController ()

@property (nonatomic, strong) JumpFilpView *jumpView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _jumpView = [JumpFilpView new];
    [self.view addSubview:_jumpView];
    _jumpView.frame = CGRectMake(self.view.frame.size.width * .5 - 10, self.view.frame.size.height * .5 - 10, 20, 20);
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:button];
    button.frame = CGRectMake(self.view.frame.size.width * .5 - 20, CGRectGetMaxY(_jumpView.frame) + 10, 50, 30);
    [button setTitle:@"jump" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(jump) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (void)jump {
    [_jumpView animate];// 点击按钮开始动画
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
