//
//  HomeViewController.m
//  ReactiveCocoaDemo
//
//  Created by 叶炯 on 2017/3/13.
//  Copyright © 2017年 叶炯. All rights reserved.
//

#import "HomeViewController.h"
#import "RACSignalController.h"
#import "RACSubscriberController.h"
#import "RACSetViewController.h"
#import "RACMulticastConnectionController.h"
#import "RACCommandController.h"
#import "RACMethodUseViewController.h"
#import "RACOperationMethodController.h"
#import "RACOperationMethodFilteringVC.h"
#import "RACOperationOrderController.h"

@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) NSArray *classArr;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"RAC学习";
    
    self.dataArr = @[@"RACSignal",@"RACSubscriber",@"RAC集合",@"RACMulticastConnection",@"RACCommand",@"RAC常用方法",@"RAC操作方法一",@"RAC操作方法二",@"RAC操作方法三"];
    
    self.classArr = @[@"RACSignalController",@"RACSubscriberController",@"RACSetViewController",@"RACMulticastConnectionController",@"RACCommandController",@"RACMethodUseViewController",@"RACOperationMethodController",@"RACOperationMethodFilteringVC",@"RACOperationOrderController"];
    
    [self.view addSubview:self.tableView];
}

- (UITableView *)tableView {

    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
    static NSString *cellStr = @"cellStr";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    
    cell.textLabel.text = self.dataArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    Class classes = NSClassFromString(self.classArr[indexPath.row]);
    
    [self.navigationController pushViewController:[classes new] animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
