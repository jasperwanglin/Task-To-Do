//
//  WLJTaskBL.m
//  TaskToDo
//
//  Created by 王 霖 on 14-5-1.
//  Copyright (c) 2014年 Jasper. All rights reserved.
//

#import "WLJTaskBL.h"
#import "WLJTaskDao.h"

@implementation WLJTaskBL


//插入任务
- (void) createTask: (WLJTask *)task{
    WLJTaskDao *taskDAO = [WLJTaskDao shareTaskDAO:nil];
    [taskDAO creatTask:task];
}
//修改任务
- (void) modifyTask: (WLJTask *)task{
    WLJTaskDao *taskDAO = [WLJTaskDao shareTaskDAO:nil];
    [taskDAO modifyTask:task];
}
//删除任务
- (void) removeTask: (WLJTask *)task{
    WLJTaskDao *taskDAO = [WLJTaskDao shareTaskDAO:nil];
    [taskDAO removeTask:task];
}
//查找任务
- (WLJTask *) queryTask: (WLJTask *)task{
    WLJTaskDao *taskDAO = [WLJTaskDao shareTaskDAO:nil];
    return [taskDAO queryTask:task];
}

//查找返回所有的任务
- (NSMutableArray *)findAllTask{
    WLJTaskDao *taskDAO = [WLJTaskDao shareTaskDAO:nil];
    return [taskDAO findAllTasks];
}

@end
