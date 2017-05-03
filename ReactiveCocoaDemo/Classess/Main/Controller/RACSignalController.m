//
//  RACSignalController.m
//  ReactiveCocoaDemo
//
//  Created by 叶炯 on 2017/4/15.
//  Copyright © 2017年 叶炯. All rights reserved.
//

#import "RACSignalController.h"
@interface RACSignalController ()
@property (nonatomic, strong) id<RACSubscriber> subscriber;

@end

@implementation RACSignalController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"RACSignal";
    
    /**
     RACSiganl:信号类,一般表示将来有数据传递，只要有数据改变，信号内部接收到数据，就会马上发出数据。
     信号类(RACSiganl)，只是表示当数据改变时，信号内部会发出数据，它本身不具备发送信号的能力，而是交给内部一个订阅者去发出。
     
     默认一个信号都是冷信号，也就是值改变了，也不会触发，只有订阅了这个信号，这个信号才会变为热信号，值改变了才会触发。
     
     如何订阅信号：调用信号RACSignal的subscribeNext就能订阅。
     */
    
    //1.创建信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
       
        //3.发送信号
        [subscriber sendNext:@"发送信号"];
        /**
         如果不在发送数据，最好发送信号完成，内部会自动调用[RACDisposable disposable]取消订阅信号
         */
        [subscriber sendCompleted];
        
        //取消订阅方法
        return [RACDisposable disposableWithBlock:^{
            //block调用时刻：当信号发送完成或者发送错误，就会自动执行这个block,取消订阅信号
            // 执行完Block后，当前信号就不在被订阅了。
            NSLog(@"信号销毁了");
        }];
    }];
    
    //2.订阅信号
    [signal subscribeNext:^(id x) {
        NSLog(@"订阅信号:%@",x);
    }];
    
    //输出
    //订阅信号:发送信号
    //信号销毁了

    /**
     RACSignal底层实现
     1.创建信号，首先把didSubscribe保存到信号中，还不会触发。
     2.当信号被订阅，也就是调用signal的subscribeNext:nextBlock
     2.1 subscribeNext内部会调用siganl的didSubscribe
     2.2 subscribeNext内部会创建订阅者subscriber，并且把nextBlock保存到subscriber中
     3.siganl的didSubscribe中调用[subscriber sendNext:@"发送信号"];
     3.1 sendNext底层其实就是执行subscriber的nextBlock
     */
    
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
       
        /**
         有一个全局变量保存值就不会走下面取消订阅方法
         */
        _subscriber = subscriber;
        
        [subscriber sendNext:@"123"];
        [subscriber sendCompleted];
        
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"走销毁这个方法了");
        }];
    }];
    
    //订阅信号返回RACDisposable
    RACDisposable *disposable = [signal1 subscribeNext:^(id x) {
        NSLog(@"接收打印的值:%@",x);
    }];
    
    // 默认一个信号发送数据完毕们就会主动取消订阅.
    // 只要订阅者在,就不会自动取消信号订阅
    // 手动取消订阅者
    [disposable dispose];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
}

@end
