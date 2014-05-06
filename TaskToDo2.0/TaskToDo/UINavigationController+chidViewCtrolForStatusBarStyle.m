//
//  UINavigationController+chidViewCtrolForStatusBarStyle.m
//  TaskToDo
//
//  Created by 王 霖 on 14-5-7.
//  Copyright (c) 2014年 Jasper. All rights reserved.
//

#import "UINavigationController+chidViewCtrolForStatusBarStyle.h"

@implementation UINavigationController (chidViewCtrolForStatusBarStyle)

- (UIViewController *)childViewControllerForStatusBarStyle
{
    return self.topViewController;
}

@end
