//
//  RACMethodUseViewController.m
//  ReactiveCocoaDemo
//
//  Created by 叶炯 on 2017/4/15.
//  Copyright © 2017年 叶炯. All rights reserved.
//

#import "RACMethodUseViewController.h"
#import "RedView.h"

@interface RACMethodUseViewController ()

@end

@implementation RACMethodUseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ////常见的五个宏
    //使用宏定义要单独导入 #import <RACEXTScope.h>

    //1：
    //RAC(TARGET, [KEYPATH, [NIL_VALUE]]):用于给某个对象的某个属性绑定
    // 只要文本框文字改变，就会修改label的文字
    //RAC(self.labelView,text) = _textField.rac_textSignal;
    
    //2:
    //RACObserve(self, name):监听某个对象的某个属性,返回的是信号。
    //[RACObserve(self.view, center) subscribeNext:^(id x) {
    //    NSLog(@"%@",x);
    //}];
    
    
    //当RACObserve放在block里面使用时一定要加上weakify，不管里面有没有使用到self；否则会内存泄漏，因为RACObserve宏里面就有一个self
    //@weakify(self);
    //RACSignal *signal3 = [anotherSignal flattenMap:^(NSArrayController *arrayController) {
    // Avoids a retain cycle because of RACObserve implicitly referencing self
    //    @strongify(self);
    //    return RACObserve(arrayController, items);
    //}];
    
    //3:
    //@weakify(Obj)和@strongify(Obj),一般两个都是配套使用,在主头文件(ReactiveCocoa.h)中并没有导入，需要自己手动导入，RACEXTScope.h才可以使用。但是每次导入都非常麻烦，只需要在主头文件自己导入就好了
    
    //4:
    //RACTuplePack：把数据包装成RACTuple（元组类）
    // 把参数中的数据包装成元组
    //RACTuple *tuple = RACTuplePack(@10,@20);
    
    //5:
    //RACTupleUnpack：把RACTuple（元组类）解包成对应的数据
    //// 把参数中的数据包装成元组
    //RACTuple *tuple = RACTuplePack(@"xmg",@20);
    //
    //// 解包元组，会把元组的值，按顺序给参数里面的变量赋值
    //// name = @"xmg" age = @20
    //RACTupleUnpack(NSString *name,NSNumber *age) = tuple;
    
    
    [self initView];
    
    
}

- (void)initView {

    self.navigationItem.title = @"RAC常用方法";
    self.view.backgroundColor = [UIColor whiteColor];
    //1.监听按钮的点击事件
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 100, 80, 40);
    [button setTitle:@"点击事件" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:button];
    
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSLog(@"按钮被点击了");
    }];
    
    //2代理的使用
    // 只要传值,就必须使用RACSubject
    RedView *redView = [[[NSBundle mainBundle] loadNibNamed:@"RedView" owner:nil options:nil] lastObject];
    redView.frame = CGRectMake(0, 140, self.view.bounds.size.width, 200);
    [self.view addSubview:redView];
    [redView.btnClickSignal subscribeNext:^(id x) {
        NSLog(@"---点击按钮了,触发了事件");
    }];
    
    // 把控制器调用didReceiveMemoryWarning转换成信号
    //rac_signalForSelector:监听某对象有没有调用某方法

    [[self rac_signalForSelector:@selector(didReceiveMemoryWarning)] subscribeNext:^(id x) {
        NSLog(@"控制器调用didReceiveMemoryWarning");

    }];
    
    // 3.KVO
    // 把监听redV的center属性改变转换成信号，只要值改变就会发送信号
    // observer:可以传入nil
    [[redView rac_valuesAndChangesForKeyPath:@"center" options:NSKeyValueObservingOptionNew observer:nil] subscribeNext:^(id x) {
        NSLog(@"center:%@",x);
    }];
    
    //4.代替通知
    UITextField *textfield = [[UITextField alloc] initWithFrame:CGRectMake(100, 340, 150, 40)];
    textfield.placeholder = @"监听键盘的弹起";
    textfield.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:textfield];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(id x) {
        NSLog(@"监听键盘的高度:%@",x);
    }];
    
    //5.监听文本框的文字改变
    [textfield.rac_textSignal subscribeNext:^(id x) {
       
        NSLog(@"输入框中文字改变了---%@",x);
    }];
    
    // 6.处理多个请求，都返回结果的时候，统一做处理.
    RACSignal *request1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        // 发送请求1
        [subscriber sendNext:@"发送请求1"];
        return nil;
    }];
    
    RACSignal *request2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 发送请求2
        [subscriber sendNext:@"发送请求2"];
        return nil;
    }];
    
    // 使用注意：几个信号，参数一的方法就几个参数，每个参数对应信号发出的数据。
    [self rac_liftSelector:@selector(updateUIWithR1:r2:) withSignalsFromArray:@[request1,request2]];
}

// 更新UI
- (void)updateUIWithR1:(id)data r2:(id)data1
{
    NSLog(@"更新UI%@  %@",data,data1);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
