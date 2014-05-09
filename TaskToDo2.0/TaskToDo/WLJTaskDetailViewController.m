//
//  WLJTaskDetailViewController.m
//  TaskToDo
//
//  Created by 王 霖 on 14-5-9.
//  Copyright (c) 2014年 Jasper. All rights reserved.
//

#import "WLJTaskDetailViewController.h"

#define NAVIGATIONBARTAG 1
#define TABLEVIEWTAG 2
#define HEADERVIEWINSECTIONHEIGHT 22.0f
#define TITLECELLHEIGHT 50.0f
#define CREATEDATECELLHEIGHT 50.0f
#define TASKDETAILCELLHEIGHT 340.0f

@interface WLJTaskDetailViewController ()

@end

@implementation WLJTaskDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //设置表视图的分割线风格和表视图的背景颜色
    UITableView *tableView = (UITableView *)[self.view viewWithTag:TABLEVIEWTAG];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    tableView.backgroundColor = [UIColor clearColor];
    
    //设置视图的背景颜色
    self.view.backgroundColor = [UIColor colorWithRed:22.0/255.0 green:31.0/255.0 blue:68.0/255.0 alpha:1];
    
    //设置导航栏的样式
    UINavigationBar *navigationBar = (UINavigationBar *)[self.view viewWithTag:NAVIGATIONBARTAG];
    navigationBar.barTintColor = [UIColor colorWithRed:22.0/255.0 green:31.0/255.0 blue:68.0/255.0 alpha:1];
    //设置导航项目的标题视图
    UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(115, 10, 94, 26)];
    [titleImageView setContentMode:UIViewContentModeScaleAspectFit];
    UIImage *titleImage = [UIImage imageNamed:@"title"];
    titleImageView.image = titleImage;
    navigationBar.topItem.titleView = titleImageView;
    //设置导航项目右边按钮
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"done"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
    rightButton.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *rightBarbutton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    navigationBar.topItem.rightBarButtonItem = rightBarbutton;
    //设置导航项目左边按钮
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    navigationBar.topItem.leftBarButtonItem = leftBarButton;
    
}
- (void)done:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//状态栏样式
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableViewSourceData

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return @"Task Title";
            break;
        case 1:
            return @"Create Date";
            break;
        case 2:
            return @"Task Describe";
            break;
        default:
            return nil;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *cellWithIdentifier = @"CellWithIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellWithIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellWithIdentifier];
        switch (indexPath.section) {
            case 0:{
                cell.backgroundColor = [UIColor colorWithRed:122.0/255.0 green:55.0/255.0 blue:139.0/255.0 alpha:1];
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, TITLECELLHEIGHT)];
                titleLabel.font = [UIFont fontWithName:@"AmericanTypewriter" size:20.0f];
                titleLabel.textColor = [UIColor whiteColor];
                titleLabel.textAlignment = NSTextAlignmentCenter;
                titleLabel.text = @"test";
                [cell addSubview:titleLabel];
                break;
            }
            case 1:{
                cell.backgroundColor = [UIColor colorWithRed:104.0/255.0 green:34.0/255.0 blue:139.0/255.0 alpha:1];
                UILabel *createDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, CREATEDATECELLHEIGHT)];
                createDateLabel.font = [UIFont fontWithName:@"AmericanTypewriter" size:20.0f];
                createDateLabel.textColor = [UIColor whiteColor];
                createDateLabel.textAlignment = NSTextAlignmentCenter;
                createDateLabel.text = @"test";
                [cell addSubview:createDateLabel];
                break;
            }
            case 2:{
                cell.backgroundColor = [UIColor colorWithRed:85.0/255.0 green:26.0/255.0 blue:139.0/255.0 alpha:1];
                UILabel *taskDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, TASKDETAILCELLHEIGHT)];
                taskDetailLabel.font = [UIFont fontWithName:@"AmericanTypewriter" size:25.0f];
                taskDetailLabel.textColor = [UIColor whiteColor];
                taskDetailLabel.textAlignment = NSTextAlignmentCenter;
                taskDetailLabel.text = @"test";
                [cell addSubview:taskDetailLabel];
            }
            default:
                break;
        }
    }
    cell.userInteractionEnabled = NO;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    switch (indexPath.section) {
        case 0:
            return TITLECELLHEIGHT;
            break;
        case 1:
            return CREATEDATECELLHEIGHT;
            break;
        case 2:
            return TASKDETAILCELLHEIGHT;
            break;
        default:
            return 0.0f;
            break;
    }
}


#pragma mark - TableViewDelegate
//设置表视图的段的头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerViewInSection = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, HEADERVIEWINSECTIONHEIGHT)];
    UILabel *headerTitle = [[UILabel alloc] initWithFrame:headerViewInSection.frame];
    headerTitle.textAlignment = NSTextAlignmentCenter;
    headerTitle.textColor = [UIColor whiteColor];
    [headerViewInSection addSubview:headerTitle];
    
    switch (section) {
        case 0:
            headerTitle.text = @"Task Title";
            headerTitle.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:187.0/255.0 blue:255.0/255.0 alpha:1];
            break;
        case 1:
            headerTitle.text = @"Create Date";
            headerTitle.backgroundColor = [UIColor colorWithRed:218.0/255.0 green:112.0/255.0 blue:214.0/255.0 alpha:1];
            break;
        case 2:
            headerTitle.text = @"Task Detail";
            headerTitle.backgroundColor = [UIColor colorWithRed:93.0/255.0 green:71.0/255.0 blue:139.0/255.0 alpha:1];
            break;
        default:
            break;
    }
    
    return headerViewInSection;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
