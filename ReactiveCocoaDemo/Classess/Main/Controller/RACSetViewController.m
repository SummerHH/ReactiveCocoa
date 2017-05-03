//
//  RACSetViewController.m
//  ReactiveCocoaDemo
//
//  Created by 叶炯 on 2017/4/15.
//  Copyright © 2017年 叶炯. All rights reserved.
//

#import "RACSetViewController.h"
#import "Flag.h"

@interface RACSetViewController ()

@end

@implementation RACSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self tuple];
    [self array];
    [self dictionary];
    [self initWithDictionary];
}

- (void)tuple {
   
    /**
     RACTuple:元组类,类似NSArray,用来包装值.
     */
    //元组
    RACTuple *tuple = [RACTuple tupleWithObjectsFromArray:@[@"123",@"345",@1]];
    NSString *first = tuple[0];
    NSLog(@"%@",first);
    
    //输出:
    //123
}

- (void)array {
    // 数组
    NSArray *arr = @[@"213",@"321",@1];
    //RAC 集合
//    RACSequence *sequence = arr.rac_sequence;
//    // 把集合转换成信号
//    RACSignal *signal = sequence.signal;
//    //订阅集合信号,内部会自动遍历所有的元素发出来
//    [signal subscribeNext:^(id x) {
//        NSLog(@"遍历数组%@",x);
//    }];
    //输出:
    /**
     遍历数组213
     遍历数组321
     遍历数组1
     */
    
    //高级写法
    [arr.rac_sequence.signal subscribeNext:^(id x) {
        NSLog(@"高级写法遍历数组打印%@",x);
    }];
    
    //输出:
    /**
     高级写法遍历数组打印213
     高级写法遍历数组打印321
     高级写法遍历数组打印1
     */
}

- (void)dictionary {
    // 字典
    NSDictionary *dict = @{@"sex":@"女",@"name":@"苍老师",@"age":@18};
    
    //转换成集合
    [dict.rac_sequence.signal subscribeNext:^(RACTuple *x) {
//        NSString *key = x[0];
//        NSString *value = x[1];
//        NSLog(@"%@ %@",key,value);
        // RACTupleUnpack:用来解析元组
        // 宏里面的参数,传需要解析出来的变量名
        //= 右边,放需要解析的元组
        RACTupleUnpack(NSString *key, NSString *value) = x;
        NSLog(@"%@ %@",key,value);
     
    }];
    //输出:
    /**
     sex 女
     name 苍老师
     age 18
     */
}


//字典转模型
- (void)initWithDictionary {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"flags.plist" ofType:nil];
    NSArray *dictArr = [NSArray arrayWithContentsOfFile:filePath];
    
    //    NSMutableArray *arr = [NSMutableArray array];
    //    // rac_sequence注意点：调用subscribeNext，并不会马上执行nextBlock，而是会等一会。
    
    //    [dictArr.rac_sequence.signal subscribeNext:^(NSDictionary *x) {
    //        Flag *flag = [Flag flagWithDict:x];
    //        [arr addObject:flag];
    //    }];
    
    //高级用法
    // map:映射的意思，目的：把原始值value映射成一个新值
    // array: 把集合转换成数组
    // 底层实现：当信号被订阅，会遍历集合中的原始值，映射成新值，并且保存到新的数组里。
    NSArray *arr = [[dictArr.rac_sequence map:^id(NSDictionary *value) {
        return [Flag flagWithDict:value];
    }] array];
    
    NSLog(@"%@",arr);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
