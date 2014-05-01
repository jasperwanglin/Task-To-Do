//
//  WLJTaskDao.h
//  TaskToDo
//
//  Created by 王 霖 on 14-5-1.
//  Copyright (c) 2014年 Jasper. All rights reserved.
//

#import "WLJCoreDataDAO.h"
#import "WLJTask.h"
#import "TaskManagedObject.h"

@interface WLJTaskDao : WLJCoreDataDAO


//TaskDAO单例方法
+ (WLJTaskDao *)shareTaskDAO:(NSError **)error;

//添加任务
- (void)creatTask: (WLJTask *)task;

//修改任务
- (void)modifyTask: (WLJTask *)task;

//删除任务
- (void)removeTask: (WLJTask *)task;

//查询指定任务
- (WLJTask *)queryTask: (WLJTask *)task;

//查询所有任务
- (NSMutableArray *)findAllTasks;


@end
