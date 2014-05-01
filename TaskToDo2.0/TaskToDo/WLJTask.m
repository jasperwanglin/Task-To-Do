//
//  WLJTask.m
//  TaskToDo
//
//  Created by 王 霖 on 14-5-1.
//  Copyright (c) 2014年 Jasper. All rights reserved.
//

#import "WLJTask.h"

@implementation WLJTask

-(NSString *)description{
    NSString *descriptionString = [NSString stringWithFormat:@"{ title:%@ \n date:%@ \n detail:%@}",_title,_date,_detail];
    return descriptionString;
}

@end
