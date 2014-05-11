//
//  WLJTaskDao.m
//  TaskToDo
//
//  Created by 王 霖 on 14-5-1.
//  Copyright (c) 2014年 Jasper. All rights reserved.
//

#import "WLJTaskDao.h"

@implementation WLJTaskDao

//类方法,用于构造单例
+ (WLJTaskDao *)shareTaskDAO:(NSError **)error{
    static WLJTaskDao * taskDAO;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        taskDAO = [[WLJTaskDao alloc] initTaskDAO];
    });
    return taskDAO;
}

- (WLJTaskDao *) initTaskDAO{
    self = [super init];
    return self;
}
//要防止用户使用init初始化
- (id)init{
    [super doesNotRecognizeSelector:_cmd];
    return nil;
}



//添加任务
- (void)creatTask: (WLJTask *)task{
    NSManagedObjectContext *cxt = [self managedObjectContext];
    
    TaskManagedObject *mo = [NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:cxt];
    mo.title = task.title;
    mo.isImportant = [NSNumber numberWithBool:task.isImportant];
    mo.detail = task.detail;
    mo.date = task.date;
    
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"%s : %@",__func__,error);
    }
}

//修改任务
- (void)modifyTask: (WLJTask *)task{
    NSManagedObjectContext *cxt = [self managedObjectContext];
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:cxt];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"date = %@",task.date];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *tasksManagedObjectData = [cxt executeFetchRequest:request error:&error];
    
    if ([tasksManagedObjectData count] > 0) {
        TaskManagedObject *mo = [tasksManagedObjectData lastObject];
        mo.title = task.title;
        mo.isImportant = [NSNumber numberWithBool:task.isImportant];
        mo.detail = task.detail;
        mo.date  = task.date;
        
        NSError *savingError = nil;
        if (![self.managedObjectContext save:&savingError]) {
            NSLog(@"%s : %@",__func__,error);
        }
    }
}

//删除任务
- (void)removeTask: (WLJTask *)task{
    NSManagedObjectContext *cxt = [self managedObjectContext];
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:cxt];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"date = %@",task.date];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *tasksManagedObjectData = [cxt executeFetchRequest:request error:&error];
    if ([tasksManagedObjectData count] > 0) {
        TaskManagedObject *mo = [tasksManagedObjectData lastObject];
        [self.managedObjectContext deleteObject:mo];
        
        NSError *savingError = nil;
        if (![self.managedObjectContext save:&savingError]) {
            NSLog(@"%s : %@",__func__,error);
        }
    }
}

//查询指定任务
- (WLJTask *)queryTask: (WLJTask *)task{
    NSManagedObjectContext *cxt = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:cxt];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"date = %@",task.date];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *tasksManagedObjectData = [cxt executeFetchRequest:request error:&error];
    
    if ([tasksManagedObjectData count] > 0) {
        TaskManagedObject *mo = [tasksManagedObjectData lastObject];
        
        WLJTask *task = [[WLJTask alloc] init];
        task.title = mo.title;
        task.isImportant = [mo.isImportant boolValue];
        task.detail = mo.detail;
        task.date = mo.date;
        return task;
    }
    return nil;
}

//查询所有任务
- (NSMutableArray *)findAllTasks{
    NSManagedObjectContext *cxt = [self managedObjectContext];

    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:cxt];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    //查询得到的数据要进行排序
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    [request setSortDescriptors:@[sortDescriptor]];
    
    NSError *error = nil;
    //查询的到ManagedObjects
    NSArray *tasksManagedObjectData = [cxt executeFetchRequest:request error:&error];
    
    NSMutableArray *tasksData = [[NSMutableArray alloc] init];
    for (TaskManagedObject *mo in tasksManagedObjectData) {
        WLJTask *task = [[WLJTask alloc] init];
        task.title = mo.title;
        task.isImportant = [mo.isImportant boolValue];
        task.detail = mo.detail;
        task.date = mo.date;
        
        [tasksData addObject:task];
    }
    
    return tasksData;
}


@end
