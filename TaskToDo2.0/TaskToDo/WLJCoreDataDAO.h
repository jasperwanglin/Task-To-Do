//
//  WLJCoreDataDAO.h
//  TaskToDo
//
//  Created by 王 霖 on 14-5-1.
//  Copyright (c) 2014年 Jasper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface WLJCoreDataDAO : NSObject

//被管理的对象上下文
@property (nonatomic,strong,readonly) NSManagedObjectContext *managedObjectContext;
//被管理的对象模型
@property (nonatomic,strong,readonly) NSManagedObjectModel *managedObjectModel;
//持久化存储管理协调起
@property (nonatomic,strong,readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

//放回应用程序沙箱中的Documents的URL
- (NSURL *)applicationDocumentsDirectory;

@end
