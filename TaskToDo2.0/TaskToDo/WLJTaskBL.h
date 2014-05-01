//
//  WLJTaskBL.h
//  TaskToDo
//
//  Created by 王 霖 on 14-5-1.
//  Copyright (c) 2014年 Jasper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WLJTask.h"

@interface WLJTaskBL : NSObject

//插入任务
- (void) createTask: (WLJTask *)task;
//修改任务
- (void) modifyTask: (WLJTask *)task;
//删除任务
- (void) removeTask: (WLJTask *)task;
//查找任务
- (WLJTask *) queryTask: (WLJTask *)task;

//查找返回所有的任务
- (NSMutableArray *)findAllTask;

@end
