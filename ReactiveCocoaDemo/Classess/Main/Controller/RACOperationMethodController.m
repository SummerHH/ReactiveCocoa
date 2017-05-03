//
//  RACOperationMethodController.m
//  ReactiveCocoaDemo
//
//  Created by 叶炯 on 2017/4/17.
//  Copyright © 2017年 叶炯. All rights reserved.
//

#import "RACOperationMethodController.h"
#import <RACReturnSignal.h>
@interface RACOperationMethodController ()
@property (strong, nonatomic) UITextField *textField;

@end

@implementation RACOperationMethodController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initView];
    [self flattenMap];
    [self map];
    [self flatternMapWithMap];
    [self RACOperationMethodCombination];
}

- (void)initView {
    self.navigationItem.title = @"RAC 操作方法一";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 150, 40)];
    _textField.center = self.view.center;
    _textField.placeholder = @"请输入内容";
    [self.view addSubview:_textField];
}

//flattenMap简单使用
// 监听文本框的内容改变，把结构重新映射成一个新值.
// flattenMap作用:把源信号的内容映射成一个新的信号，信号可以是任意类型。
- (void)flattenMap {
    
    // flattenMap使用步骤:
    // 1.传入一个block，block类型是返回值RACStream，参数value
    // 2.参数value就是源信号的内容，拿到源信号的内容做处理
    // 3.包装成RACReturnSignal信号，返回出去。
    
    // flattenMap底层实现:
    // 0.flattenMap内部调用bind方法实现的,flattenMap中block的返回值，会作为bind中bindBlock的返回值。
    // 1.当订阅绑定信号，就会生成bindBlock。
    // 2.当源信号发送内容，就会调用bindBlock(value, *stop)
    // 3.调用bindBlock，内部就会调用flattenMap的block，flattenMap的block作用：就是把处理好的数据包装成信号。
    // 4.返回的信号最终会作为bindBlock中的返回信号，当做bindBlock的返回信号。
    // 5.订阅bindBlock的返回信号，就会拿到绑定信号的订阅者，把处理完成的信号内容发送出来。

    [[_textField.rac_textSignal flattenMap:^RACStream *(id value) {
        // block什么时候 : 源信号发出的时候，就会调用这个block。
        
        // block作用 : 改变源信号的内容。
        // 返回值：绑定信号的内容.
        return [RACReturnSignal return:[NSString stringWithFormat:@"输出:%@",value]];
    }] subscribeNext:^(id x) {
         // 订阅绑定信号，每当源信号发送内容，做完处理，就会调用这个block。
        NSLog(@"输出:flattenMap%@",x);
    }];
}

- (void)map {

    //Map简单使用:
    // 监听文本框的内容改变，把结构重新映射成一个新值.
    // Map作用:把源信号的值映射成一个新的值
    
    // Map使用步骤:
    // 1.传入一个block,类型是返回对象，参数是value
    // 2.value就是源信号的内容，直接拿到源信号的内容做处理
    // 3.把处理好的内容，直接返回就好了，不用包装成信号，返回的值，就是映射的值。
    
    // Map底层实现:
    // 0.Map底层其实是调用flatternMap,Map中block中的返回的值会作为flatternMap中block中的值。
    // 1.当订阅绑定信号，就会生成bindBlock。
    // 3.当源信号发送内容，就会调用bindBlock(value, *stop)
    // 4.调用bindBlock，内部就会调用flattenMap的block
    // 5.flattenMap的block内部会调用Map中的block，把Map中的block返回的内容包装成返回的信号。
    // 5.返回的信号最终会作为bindBlock中的返回信号，当做bindBlock的返回信号。
    // 6.订阅bindBlock的返回信号，就会拿到绑定信号的订阅者，把处理完成的信号内容发送出来。
    
    [[_textField.rac_textSignal map:^id(id value) {
        // 当源信号发出，就会调用这个block，修改源信号的内容
        // 返回值：就是处理完源信号的内容。
        return [NSString stringWithFormat:@"输出:%@",value];
    }] subscribeNext:^(id x) {
        
        NSLog(@"map输出%@",x);
    }];
}

- (void)flatternMapWithMap {

    /**
     FlatternMap和Map的区别
     
     1.FlatternMap中的Block返回信号。
     2.Map中的Block返回对象。
     3.开发中，如果信号发出的值不是信号，映射一般使用Map
     4.开发中，如果信号发出的值是信号，映射一般使用FlatternMap。
     总结：signalOfsignals用FlatternMap。
     */
    
    //创建信号中的信号
    RACSubject *signalOfsignals = [RACSubject subject];
    RACSubject *signal = [RACSubject subject];
    
    [[signalOfsignals flattenMap:^RACStream *(id value) {
       
        //当signalOfsignals的signals发出信号才会调用
        return value;
    }] subscribeNext:^(id x) {
        // 只有signalOfsignals的signal发出信号才会调用，因为内部订阅了bindBlock中返回的信号，也就是flattenMap返回的信号。
        // 也就是flattenMap返回的信号发出内容，才会调用。
        
        NSLog(@"%@aaa",x);
    }];
    
    // 信号的信号发送信号
    [signalOfsignals sendNext:signal];
    
    // 信号发送内容
    [signal sendNext:@1];
}

//RAC 操作之组合
- (void)RACOperationMethodCombination {

    //一.concat:按一定顺序拼接信号，当多个信号发出的时候，有顺序的接收信号。
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@1];
        [subscriber sendCompleted];
        return nil;
    }];
    
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@2];
        [subscriber sendCompleted];
        
        return nil;
    }];
    
    // 把signalA拼接到signalB后，signalA发送完成，signalB才会被激活。
    RACSignal *concatSignal = [signalA concat:signalB];
    
    // 以后只需要面对拼接信号开发。
    // 订阅拼接的信号，不需要单独订阅signalA，signalB
    // 内部会自动订阅。
    // 注意：第一个信号必须发送完成，第二个信号才会被激活
    [concatSignal subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
    
    // concat底层实现:
    // 1.当拼接信号被订阅，就会调用拼接信号的didSubscribe
    // 2.didSubscribe中，会先订阅第一个源信号（signalA）
    // 3.会执行第一个源信号（signalA）的didSubscribe
    // 4.第一个源信号（signalA）didSubscribe中发送值，就会调用第一个源信号（signalA）订阅者的nextBlock,通过拼接信号的订阅者把值发送出来.
    // 5.第一个源信号（signalA）didSubscribe中发送完成，就会调用第一个源信号（signalA）订阅者的completedBlock,订阅第二个源信号（signalB）这时候才激活（signalB）。
    // 6.订阅第二个源信号（signalB）,执行第二个源信号（signalB）的didSubscribe
    // 7.第二个源信号（signalA）didSubscribe中发送值,就会通过拼接信号的订阅者把值发送出来.
    
    //二.then:用于连接两个信号，当第一个信号完成，才会连接then返回的信号。
    // then:用于连接两个信号，当第一个信号完成，才会连接then返回的信号
    // 注意使用then，之前信号的值会被忽略掉.
    // 底层实现：1、先过滤掉之前的信号发出的值。2.使用concat连接then返回的信号
    
    [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@1];
        [subscriber sendCompleted];
        
        return nil;
        
    }] then:^RACSignal *{
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@2];
            return nil;
        }];
    }] subscribeNext:^(id x) {
        // 只能接收到第二个信号的值，也就是then返回信号的值
        NSLog(@"%@",x);
    }];
    
    
    //三.merge:把多个信号合并为一个信号,任何一个信号有新值的时候就会调用.
    //merge: 把多个信号合并成一个信号
    //创建多个信号
    
    RACSignal *signalC = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@3];
        
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"信号释放了");
        }];
    }];
    
    RACSignal *signalD = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@4];
        
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"信号释放了");
        }];
    }];
    
    //合并信号.任何一个信号发送数据,都能监听到
    
    RACSignal *mergeSignal = [signalC merge:signalD];
    [mergeSignal subscribeNext:^(id x) {
        NSLog(@"合并信号,任何一个数据发送数据,都能监听到%@",x);
    }];
    
    // 底层实现：
    // 1.合并信号被订阅的时候，就会遍历所有信号，并且发出这些信号。
    // 2.每发出一个信号，这个信号就会被订阅
    // 3.也就是合并信号一被订阅，就会订阅里面所有的信号。
    // 4.只要有一个信号被发出就会被监听。
    
    //四.zipWith:把两个信号压缩成一个信号，只有当两个信号同时发出信号内容时，并且把两个信号的内容合并成一个元组，才会触发压缩流的next事件。
    
    RACSignal *signalE = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@5];
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
    
    RACSignal *signalF = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@6];
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
    
    // 压缩信号A，信号B
    
    RACSignal *zipSignal = [signalE zipWith:signalF];
    
    [zipSignal subscribeNext:^(id x) {
        NSLog(@"压缩的信号%@",x);
    }];
    
    // 底层实现:
    // 1.定义压缩信号，内部就会自动订阅signalA，signalB
    // 2.每当signalA或者signalB发出信号，就会判断signalA，signalB有没有发出个信号，有就会把最近发出的信号都包装成元组发出。
    
    
    //第五:combineLatest:将多个信号合并起来，并且拿到各个信号的最新的值,必须每个合并的signal至少都有过一次sendNext，才会触发合并的信号.
    
    RACSignal *signalG = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@5];
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
    
    RACSignal *signalH = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@6];
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
    
    // 把两个信号组合成一个信号,跟zip一样，没什么区别
    RACSignal *combineSignal = [signalG combineLatestWith:signalH];
    
    [combineSignal subscribeNext:^(id x) {
       NSLog(@"把两个信号组合成一个信号%@",x);
    }];
    
    // 底层实现：
    // 1.当组合信号被订阅，内部会自动订阅signalA，signalB,必须两个信号都发出内容，才会被触发。
    // 2.并且把两个信号组合成元组发出。
    
    
    //第六:reduce聚合:用于信号发出的内容是元组，把信号发出元组的值聚合成一个值
    RACSignal *signalL = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@5];
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
    
    RACSignal *signalM = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@6];
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
    
    RACSignal *reduceSignal = [RACSignal combineLatest:@[signalL,signalM] reduce:^id(NSNumber *num1, NSNumber *num2){
        return [NSString stringWithFormat:@"reduce聚合%@ %@",num1,num2];
    }];
    
    [reduceSignal subscribeNext:^(id x) {
        NSLog(@"%@",x);
 
    }];
    
    // // 底层实现:
    // 1.订阅聚合信号，每次有内容发出，就会执行reduceblcok，把信号内容转换成reduceblcok返回的值。
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
