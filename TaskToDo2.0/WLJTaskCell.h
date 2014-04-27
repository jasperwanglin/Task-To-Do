//
//  WLJTaskCell.h
//  TaskToDo
//
//  Created by 王 霖 on 14-4-1.
//  Copyright (c) 2014年 Jasper. All rights reserved.
//

#import "DNSSwipeableCell.h"
#import <UIKit/UIKit.h>

FOUNDATION_EXPORT CGFloat const kTaskCellHeight;

@interface WLJTaskCell : DNSSwipeableCell

//taskImageView用来表示任务的重要程度的表示图标
@property (nonatomic, strong) UIImageView *taskImageView;
@property (nonatomic, strong) UILabel *taskTitleLavel;
//任务的名字
@property (nonatomic, strong) UITextField *taskNameTextField;

@end
