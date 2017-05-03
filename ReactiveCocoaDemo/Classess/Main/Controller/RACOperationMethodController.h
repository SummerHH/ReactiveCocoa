//
//  RACOperationMethodController.h
//  ReactiveCocoaDemo
//
//  Created by 叶炯 on 2017/4/17.
//  Copyright © 2017年 叶炯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RACOperationMethodController : UIViewController

@end
//1.ReactiveCocoa常见操作方法介绍。

/**
 1.1 ReactiveCocoa操作须知
 
 所有的信号（RACSignal）都可以进行操作处理，因为所有操作方法都定义在RACStream.h中，而RACSignal继承RACStream。
 1.2 ReactiveCocoa操作思想
 
 运用的是Hook（钩子）思想，Hook是一种用于改变API(应用程序编程接口：方法)执行结果的技术.
 Hook用处：截获API调用的技术。
 Hook原理：在每次调用一个API返回结果之前，先执行你自己的方法，改变结果的输出。
 RAC开发方式：RAC中核心开发方式，也是绑定，之前的开发方式是赋值，而用RAC开发，应该把重心放在绑定，也就是可以在创建一个对象的时候，就绑定好以后想要做的事情，而不是等赋值之后在去做事情。
 列如：把数据展示到控件上，之前都是重写控件的setModel方法，用RAC就可以在一开始创建控件的时候，就绑定好数据。
 1.3 ReactiveCocoa核心方法bind
 
 ReactiveCocoa操作的核心方法是bind（绑定）,给RAC中的信号进行绑定，只要信号一发送数据，就能监听到，从而把发送数据改成自己想要的数据。
 
 在开发中很少使用bind方法，bind属于RAC中的底层方法，RAC已经封装了很多好用的其他方法，底层都是调用bind，用法比bind简单.
 
 bind方法简单介绍和使用。
 */

/**
 // 假设想监听文本框的内容，并且在每次输出结果的时候，都在文本框的内容拼接一段文字“输出：”
 
 // 方式一:在返回结果后，拼接。
 [_textField.rac_textSignal subscribeNext:^(id x) {
 
 NSLog(@"输出:%@",x);
 
 }];
 
 // 方式二:在返回结果前，拼接，使用RAC中bind方法做处理。
 // bind方法参数:需要传入一个返回值是RACStreamBindBlock的block参数
 // RACStreamBindBlock是一个block的类型，返回值是信号，参数（value,stop），因此参数的block返回值也是一个block。
 
 // RACStreamBindBlock:
 // 参数一(value):表示接收到信号的原始值，还没做处理
 // 参数二(*stop):用来控制绑定Block，如果*stop = yes,那么就会结束绑定。
 // 返回值：信号，做好处理，在通过这个信号返回出去，一般使用RACReturnSignal,需要手动导入头文件RACReturnSignal.h。
 
 // bind方法使用步骤:
 // 1.传入一个返回值RACStreamBindBlock的block。
 // 2.描述一个RACStreamBindBlock类型的bindBlock作为block的返回值。
 // 3.描述一个返回结果的信号，作为bindBlock的返回值。
 // 注意：在bindBlock中做信号结果的处理。
 
 // 底层实现:
 // 1.源信号调用bind,会重新创建一个绑定信号。
 // 2.当绑定信号被订阅，就会调用绑定信号中的didSubscribe，生成一个bindingBlock。
 // 3.当源信号有内容发出，就会把内容传递到bindingBlock处理，调用bindingBlock(value,stop)
 // 4.调用bindingBlock(value,stop)，会返回一个内容处理完成的信号（RACReturnSignal）。
 // 5.订阅RACReturnSignal，就会拿到绑定信号的订阅者，把处理完成的信号内容发送出来。
 
 // 注意:不同订阅者，保存不同的nextBlock，看源码的时候，一定要看清楚订阅者是哪个。
 // 这里需要手动导入#import <ReactiveCocoa/RACReturnSignal.h>，才能使用RACReturnSignal。
 
 [[_textField.rac_textSignal bind:^RACStreamBindBlock{
 
 // 什么时候调用:
 // block作用:表示绑定了一个信号.
 
 return ^RACStream *(id value, BOOL *stop){
 
 // 什么时候调用block:当信号有新的值发出，就会来到这个block。
 
 // block作用:做返回值的处理
 
 // 做好处理，通过信号返回出去.
 return [RACReturnSignal return:[NSString stringWithFormat:@"输出:%@",value]];
 };
 
 }] subscribeNext:^(id x) {
 
 NSLog(@"%@",x);
 
 }];
 */
