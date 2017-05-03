//
//  RACOperationMethodFilteringVC.m
//  ReactiveCocoaDemo
//
//  Created by 叶炯 on 2017/4/17.
//  Copyright © 2017年 叶炯. All rights reserved.
//

#import "RACOperationMethodFilteringVC.h"

@interface RACOperationMethodFilteringVC ()
@property (strong, nonatomic) UITextField *textField;

@end

@implementation RACOperationMethodFilteringVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initView];
    [self filter];
    [self ignore];
    [self ignoreValues];
    [self takeUntilBlock];
    [self distinctUntilChanged];
    [self take];
    [self takeLast];
    [self takeUntil];
    [self skip];
    [self switchToLatest];
    
    
}

- (void)initView {

    self.navigationItem.title = @"RAC操作方法二";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 150, 40)];
    _textField.center = self.view.center;
    _textField.borderStyle = UITextBorderStyleBezel;
    _textField.placeholder = @"请输入内容";
    [self.view addSubview:_textField];
}

//过滤信号，使用它可以获取满足条件的信号.
- (void)filter {

    //filter 过滤
    //每次信号发出,会先执行过滤条件判断
    [_textField.rac_textSignal filter:^BOOL(NSString *value) {
       
        return value.length > 3;
    }];
}

//ignore:忽略完某些值的信号.
- (void)ignore {
    // 内部调用filter过滤，忽略掉ignore的值
    [[_textField.rac_textSignal ignore:@"1"] subscribeNext:^(id x) {
        NSLog(@"ignore%@",x);
    }];
    
}

//ignoreValues 这个比较极端，忽略所有值，只关心Signal结束，也就是只取Comletion和Error两个消息，中间所有值都丢弃
- (void)ignoreValues {
    
    RACSignal *signal=[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"1"];
        [subscriber sendNext:@"3"];
        [subscriber sendNext:@"15"];
        [subscriber sendNext:@"wujy"];
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"执行清理");
        }];
    }];
    
    
    [[signal ignoreValues] subscribeNext:^(id x) {
        //它是没机会执行  因为ignoreValues已经忽略所有的next值
        NSLog(@"ignoreValues当前值：%@",x);
    } error:^(NSError *error) {
        NSLog(@"ignoreValues error");
    } completed:^{
        NSLog(@"ignoreValues completed");
    }];
    
}


//distinctUntilChanged:当上一次的值和当前的值有明显的变化就会发出信号，否则会被忽略掉。
- (void)distinctUntilChanged {

    // 过滤，当上一次和当前的值不一样，就会发出内容。
    // 在开发中，刷新UI经常使用，只有两次数据不一样才需要刷新
    
    [[_textField.rac_textSignal distinctUntilChanged] subscribeNext:^(id x) {
        NSLog(@"distinctUntilChanged%@",x);
    }];
}

//take:从开始一共取N次的信号
- (void)take {

    //1.创建信号
    RACSubject *signal = [RACSubject subject];
    //2.处理信号,订阅信号
    [[signal take:1] subscribeNext:^(id x) {
        NSLog(@"take:%@",x);

    }];
    
    // 3.发送信号
    [signal sendNext:@1];
    
    [signal sendNext:@2];
}

//takeLast:取最后N次的信号,前提条件，订阅者必须调用完成，因为只有完成，就知道总共有多少信号.
- (void)takeLast {

    //1.创建信号
    RACSubject *signal = [RACSubject subject];
    //2.处理信号,订阅信号
    [[signal takeLast:2] subscribeNext:^(id x) {
        NSLog(@"%@",x);

    }];
    
    //3.发送信号
    [signal sendNext:@1];
    [signal sendNext:@332];
    [signal sendNext:@333];
    [signal sendCompleted];
}

//takeUntil:(RACSignal *):获取信号直到执行完这个信号
- (void)takeUntil {
    // 监听文本框的改变，知道当前对象被销毁
    [_textField.rac_textSignal takeUntil:self.rac_willDeallocSignal];
}

//takeUntilBlock 对于每个next值，运行block，当block返回YES时停止取值
- (void)takeUntilBlock {
    
    RACSignal *signal=[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"1"];
        [subscriber sendNext:@"3"];
        [subscriber sendNext:@"15"];
        [subscriber sendNext:@"wujy"];
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"执行清理");
        }];
    }];
    
    [[signal takeUntilBlock:^BOOL(NSString *x) {
        if ([x isEqualToString:@"15"]) {
            return YES;
        }
        return NO;
    }] subscribeNext:^(id x) {
        NSLog(@"takeUntilBlock 获取的值：%@",x);
    }];
    
    //    输出
    //    takeUntilBlock 获取的值：1
    //    takeUntilBlock 获取的值：3
}


//skip:(NSUInteger):跳过几个信号,不接受。
- (void)skip {

    [[_textField.rac_textSignal skip:1] subscribeNext:^(id x) {
        NSLog(@"跳过几个信号不接收%@",x);
    }];
}

//switchToLatest:用于signalOfSignals（信号的信号），有时候信号也会发出信号，会在signalOfSignals中，获取signalOfSignals发送的最新信号。
- (void)switchToLatest {
    RACSubject *signalOfSignals = [RACSubject subject];
    RACSubject *signal = [RACSubject subject];
    [signalOfSignals sendNext:signal];
    // 获取信号中信号最近发出信号，订阅最近发出的信号。
    // 注意switchToLatest：只能用于信号中的信号
    
    [signalOfSignals.switchToLatest subscribeNext:^(id x) {
        
        NSLog(@"获取信号中信号最近发出信号，订阅最近发出的信号%@",x);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
