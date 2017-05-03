//
//  HomeViewController.h
//  ReactiveCocoaDemo
//
//  Created by 叶炯 on 2017/3/13.
//  Copyright © 2017年 叶炯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController

@end

/**
 *******************************************************************
                                RAC简介
 *******************************************************************
 */

/**
 1.ReactiveCocoa简介
 
 ReactiveCocoa（简称为RAC）,是由Github开源的一个应用于iOS和OS开发的新框架,Cocoa是苹果整套框架的简称，因此很多苹果框架喜欢以Cocoa结尾。
 
 2.ReactiveCocoa作用
 在我们iOS开发过程中，当某些事件响应的时候，需要处理某些业务逻辑,这些事件都用不同的方式来处理。
 比如按钮的点击使用action，ScrollView滚动使用delegate，属性值改变使用KVO等系统提供的方式。
 其实这些事件，都可以通过RAC处理
 ReactiveCocoa为事件提供了很多处理方法，而且利用RAC处理事件很方便，可以把要处理的事情，和监听的事情的代码放在一起，这样非常方便我们管理，就不需要跳到对应的方法里。非常符合我们开发中高聚合，低耦合的思想。
 
 3.ReactiveCocoa结合了几种编程风格：
 
 函数式编程（Functional Programming）
 
 响应式编程（Reactive Programming）
*/
