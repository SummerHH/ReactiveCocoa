//
//  RACOperationOrderController.m
//  ReactiveCocoaDemo
//
//  Created by 叶炯 on 2017/4/17.
//  Copyright © 2017年 叶炯. All rights reserved.
//

#import "RACOperationOrderController.h"

@interface RACOperationOrderController ()
@property (nonatomic, strong) RACSubject *signal;
@end

@implementation RACOperationOrderController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initView];
    
    [self doNext];
    
    [self deliverOn];
    
    [self timeout];
    
    [self interval];
    
    [self delay];
    
    [self retry];
    
    [self replay];
    
    [self throttle];
}

- (void)initView {
    self.navigationItem.title = @"RAC操作方法三";
    self.view.backgroundColor = [UIColor whiteColor];
}

//ReactiveCocoa操作方法之秩序。
- (void)doNext {

    //doNext: 执行Next之前，会先执行这个Block
    //doCompleted: 执行sendCompleted之前，会先执行这个Block
    [[[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@1];
        [subscriber sendCompleted];
        return nil;
    }] doNext:^(id x) {
        // 执行[subscriber sendNext:@1];之前会调用这个Block
        NSLog(@"doNext");
    }] doCompleted:^{
        // 执行[subscriber sendCompleted];之前会调用这个Block
        NSLog(@"doCompleted");
    }] subscribeNext:^(id x) {
        NSLog(@"%@",x);

    }];
}

//ReactiveCocoa操作方法之线程。
- (void)deliverOn {
    //deliverOn: 内容传递切换到制定线程中，副作用在原来线程中,把在创建信号时block中的代码称之为副作用。
    
    //subscribeOn: 内容传递和副作用都会切换到制定线程中。
}

//ReactiveCocoa操作方法之时间。
- (void)timeout {
    //timeout：超时，可以让一个信号在一定的时间后，自动报错。
    RACSignal *signal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        return nil;
    }] timeout:1 onScheduler:[RACScheduler currentScheduler]];
    
    [signal subscribeNext:^(id x) {
        
        NSLog(@"%@",x);

    } error:^(NSError *error) {
        // 1秒后会自动调用
        NSLog(@"%@",error);
    }];
}

//interval 定时：每隔一段时间发出信号
- (void)interval {

    [[RACSignal interval:1 onScheduler:[RACScheduler currentScheduler]] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    } error:^(NSError *error) {
         NSLog(@"%@",error);
    }];
}

//delay 延迟发送next
- (void)delay {

   [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
      
        [subscriber sendNext:@1];
        return nil;
    }] delay:2] subscribeNext:^(id x) {
         NSLog(@"%@",x);
    }];
}

// ReactiveCocoa操作方法之重复。
- (void)retry {
    //retry重试 ：只要失败，就会重新执行创建信号中的block,直到成功.
    __block int i = 0;
    [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        if (i == 10) {
            [subscriber sendNext:@1];
        }else{
            NSLog(@"接收到错误");
            [subscriber sendError:nil];
        }
        i++;
        return nil;
        
    }] retry] subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
        
    } error:^(NSError *error) {
        
        
    }];
}

//replay重放：当一个信号被多次订阅,反复播放内容
- (void)replay {
    RACSignal *signal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        
        [subscriber sendNext:@1];
        [subscriber sendNext:@2];
        
        return nil;
    }] replay];
    
    [signal subscribeNext:^(id x) {
        
        NSLog(@"第一个订阅者%@",x);
        
    }];
    
    [signal subscribeNext:^(id x) {
        
        NSLog(@"第二个订阅者%@",x);
        
    }];
}


- (void)throttle {
    RACSubject *signal = [RACSubject subject];
    _signal = signal;
    // 节流，在一定时间（1秒）内，不接收任何信号内容，过了这个时间（1秒）获取最后发送的信号内容发出。
    [[signal throttle:1] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
