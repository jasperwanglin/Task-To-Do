//
//  WLJMasterViewController.h
//  TaskToDo
//
//  Created by 王 霖 on 14-4-1.
//  Copyright (c) 2014年 Jasper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WLJMasterViewController : UITableViewController

@property (nonatomic, strong) NSIndexPath* currentSelectedCellIndexPath;//存放当前选中的单元
@property (nonatomic, strong) NSMutableArray *Tasks;//存放所有的任务，从数据库中读取

@end
