//
//  TaskManagedObject.h
//  TaskToDo
//
//  Created by 王 霖 on 14-5-1.
//  Copyright (c) 2014年 Jasper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TaskManagedObject : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * detail;
@property (nonatomic, retain) NSNumber * isImportant;
@property (nonatomic, retain) NSString * title;

@end
