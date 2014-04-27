//
//  WLJDetailViewController.h
//  TaskToDo
//
//  Created by 王 霖 on 14-4-1.
//  Copyright (c) 2014年 Jasper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WLJDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
