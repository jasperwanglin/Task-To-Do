//
//  WLJCoreDataDAO.m
//  TaskToDo
//
//  Created by 王 霖 on 14-5-1.
//  Copyright (c) 2014年 Jasper. All rights reserved.
//

#import "WLJCoreDataDAO.h"

@implementation WLJCoreDataDAO

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSManagedObjectContext *)managedObjectContext{
    if (_managedObjectContext) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator{
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *url = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"TaskToDo.sqlite"];
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                              configuration:nil
                                                        URL:url
                                                    options:nil
                                                      error:nil];
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectModel *)managedObjectModel{
    if (_managedObjectModel) {
        return _managedObjectModel;
    }
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"TaskToDo" withExtension:@"momd"];
    
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:url];
    
    return _managedObjectModel;
}

- (NSURL *)applicationDocumentsDirectory{
    
    NSArray *documentsDirectorys = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *url = [documentsDirectorys lastObject];
    return url;
}

@end
