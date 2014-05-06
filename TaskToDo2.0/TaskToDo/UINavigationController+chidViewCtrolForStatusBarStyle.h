//
//  UINavigationController+chidViewCtrolForStatusBarStyle.h
//  TaskToDo
//
//  Created by 王 霖 on 14-5-7.
//  Copyright (c) 2014年 Jasper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (chidViewCtrolForStatusBarStyle)

//返回控制状态栏的栈内视图控制器（也就是把栈顶的视图控制器返回）
- (UIViewController *)childViewControllerForStatusBarStyle;
@end
