//
//  WLJTask.h
//  TaskToDo
//
//  Created by 王 霖 on 14-4-1.
//  Copyright (c) 2014年 Jasper. All rights reserved.
//

#import <Foundation/Foundation.h>
#define Important @"important"
#define Unimportant @"unimportant"

@interface WLJTask : NSObject
@property (nonatomic,strong) NSString * taskTitle;
@property (nonatomic,strong) NSString * taskDetail;
@property (nonatomic,strong) NSString * isImportant;
@property (nonatomic,strong) NSString * itIsTest;
@property (nonatomic,strong) NSString *zhangyuan;

@end
