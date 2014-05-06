//
//  WLJTaskCell.m
//  TaskToDo
//
//  Created by 王 霖 on 14-4-1.
//  Copyright (c) 2014年 Jasper. All rights reserved.
//

#import "WLJTaskCell.h"

#define FONTSIZE 20

//公共常量
CGFloat const kTaskCellHeight = 60.0f;
//私有常量
static CGFloat const kTaskCellLeftMargin = 15.0f;
static CGFloat const kTaskCellRightMargin = 15.0f;
static CGFloat const kBetweenViewsMargin = 8.0f;
static CGFloat const kTaskCellDateLabelWidth = 110.0f;
static CGFloat const taskTitleLabelWidth = 170.0f;

@interface WLJTaskCell()

//存放单元可能的所有颜色
@property (nonatomic, strong) NSArray *cellColorArray;

@end

@implementation WLJTaskCell

- (void)commonInit{
    [super commonInit];
    
    self.contentMode = UIViewContentModeScaleAspectFit;
    
    //单元的内容视图的背景和自带的内容视图的背景的颜色都设置为透明
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];

    //添加图片视图
    CGFloat imageHeight = (kTaskCellHeight - (kBetweenViewsMargin * 2)) / 2;
    self.taskImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kTaskCellLeftMargin, imageHeight + kBetweenViewsMargin, imageHeight, imageHeight)];
    [self.myContentView addSubview:self.taskImageView];
    
    //添加创建时间标签视图
    CGFloat taskCreatDateLabelHeight = imageHeight;
    self.taskCreatedDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(kTaskCellLeftMargin, kBetweenViewsMargin, kTaskCellDateLabelWidth, taskCreatDateLabelHeight)];
    self.taskCreatedDateLabel.font = [UIFont fontWithName:@"AmericanTypewriter" size:FONTSIZE];
    self.taskCreatedDateLabel.textColor = [UIColor whiteColor];
    self.taskCreatedDateLabel.adjustsFontSizeToFitWidth = YES;
    [self.myContentView addSubview:self.taskCreatedDateLabel];
    
    
    //添加任务的标题
    CGFloat taskTitleLabelHeight = kTaskCellHeight - 2*kBetweenViewsMargin;
    self.taskTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - taskTitleLabelWidth - kTaskCellRightMargin, kBetweenViewsMargin, taskTitleLabelWidth, taskTitleLabelHeight)];
    self.taskTitleLabel.textColor = [UIColor whiteColor];
    [self.myContentView addSubview:self.taskTitleLabel];
    
    //设置单元打开详细视图图标

    UIImageView *detailImageView = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - kTaskCellRightMargin, kTaskCellHeight/2 -kTaskCellRightMargin/2, kTaskCellRightMargin, kTaskCellRightMargin)];
    detailImageView.image = [UIImage imageNamed:@"detail"];
    [self.myContentView addSubview:detailImageView];
    
    //设定单元的颜色数组
    self.cellColorArray = @[[UIColor colorWithRed:93.0/255.0 green:71.0/255.0 blue:139.0/255.0 alpha:1],[UIColor colorWithRed:85.0/255.0 green:26.0/255.0 blue:139.0/255.0 alpha:1],[UIColor colorWithRed:104.0/255.0 green:34.0/255.0 blue:139.0/255.0 alpha:1],[UIColor colorWithRed:122.0/255.0 green:55.0/255.0 blue:139.0/255.0 alpha:1],[UIColor colorWithRed:139.0/255.0 green:102.0/255.0 blue:139.0/255.0 alpha:1],[UIColor colorWithRed:255.0/255.0 green:187.0/255.0 blue:255.0/255.0 alpha:1]];
}


-(UIColor *)cellColor{
    //随机返回一种颜色
//    return [self.cellColorArray objectAtIndex:rand()%6];
    static int i = 0;
    UIColor *cellColor = [self.cellColorArray objectAtIndex:i%6];
    i++;
    return cellColor;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
