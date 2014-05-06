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

//展现任务的重要程度的表示图标
@property (nonatomic, strong) UIImageView *taskImageView;

//展现任务创建的时间
@property (nonatomic, strong) UILabel *taskCreatedDateLabel;


//任务标题
@property (nonatomic,strong) UILabel *taskTitleLabel;

//任务的名字
@property (nonatomic, strong) UITextField *taskNameTextField;

//返回单元随机的颜色
-(UIColor *)cellColor;

@end
