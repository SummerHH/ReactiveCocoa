//
//  RedView.m
//  ReactiveCocoaDemo
//
//  Created by 叶炯 on 2017/3/14.
//  Copyright © 2017年 叶炯. All rights reserved.
//

#import "RedView.h"

@implementation RedView
- (void)awakeFromNib {

    [super awakeFromNib];
}

//懒加载信号
- (RACSubject *)btnClickSignal {

    if (_btnClickSignal == nil) {
        _btnClickSignal = [RACSubject subject];
    }
    return _btnClickSignal;
}

- (IBAction)btnClick:(UIButton *)sender {
    
    [self.btnClickSignal sendNext:@"按钮被点击了"];
}

@end
