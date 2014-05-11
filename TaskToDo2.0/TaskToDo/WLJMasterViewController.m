//
//  WLJMasterViewController.m
//  TaskToDo
//
//  Created by 王 霖 on 14-4-1.
//  Copyright (c) 2014年 Jasper. All rights reserved.
//

#import "WLJMasterViewController.h"

#import "WLJDetailViewController.h"
#import "WLJHeaderView.h"
#import "WLJTaskCell.h"
#import "WLJTaskBL.h"
#import "WLJTask.h"
#import "WLJTaskDetailViewController.h"
#import "UIImageView+LBBlurredImage.h"

#define HEADER_HEIGHT 200.0f
#define HEADER_INIT_FRAME CGRectMake(0, 0, self.view.frame.size.width, HEADER_HEIGHT)
#define TIMELABEL_HEIGHT 50.0f
#define IMAGEVIEW_FRAME CGRectMake(0, 0, self.view.frame.size.width, HEADER_HEIGHT)
#define TEXTFIELD_FRAME CGRectMake(0, 0, self.view.frame.size.width, HEADER_HEIGHT)
#define NAVIGATIONITEM_TITLE_VIEW_RECT CGRectMake(115, 10, 94, 26)
#define CREATE_TASK_VIEW_TAG 101
#define RELOAD_VIEW_NOTIFICATION @"reloadViewNotification"


typedef NS_ENUM(NSInteger, RE_EDITING_TYPE) {
    BeImportant = 0 ,
    ReName,
};


int rowNum;
@interface WLJMasterViewController () <DNSSwipeableCellDataSource,DNSSwipeableCellDelegate,HeaderViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) WLJHeaderView *headerView;//表视图的头视图
@property (nonatomic, strong) NSMutableArray *taskCellsCurrentlyEditing;//存放正在编辑的任务
@property (nonatomic, strong) NSIndexPath* currentEditingCellIndexPath;//存放当前正在编辑的任务单元的索引
@property (nonatomic, strong) NSArray *backgroundColors;//任务单元中的按钮的颜色
@property (nonatomic, assign) BOOL hideStatusBar;//状态栏隐藏与否
@property (nonatomic, assign) CGFloat preContentOffsetY;//前一次表视图滚动的偏移值
@property (nonatomic, strong) WLJTaskBL *taskBL;//业务持久层类，用于管理数据


@end

static NSString * const kWLJTaskCellIdentifier = @"Cell";

@implementation WLJMasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //设置状态栏状态为显示
    self.hideStatusBar = NO;
    
    //表视图的背景颜色和内容视图的背景颜色
    self.tableView.backgroundColor = [UIColor colorWithRed:22.0/255.0 green:31.0/255.0 blue:68.0/255.0 alpha:1];
    
    //表视图的单元分割线设置
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //初始化编辑单元数组
    self.taskCellsCurrentlyEditing = [NSMutableArray array];
    
    //初始化当前打开的任务单元
    self.currentEditingCellIndexPath = [NSIndexPath indexPathForRow:-1 inSection:0];
    
    //登记重复使用的任务单元
    [self.tableView registerClass:[WLJTaskCell class] forCellReuseIdentifier:kWLJTaskCellIdentifier];
    
    //设置单元按钮的背景颜色
    self.backgroundColors = @[[UIColor colorWithRed:255.0/255.0 green:0 blue:0 alpha:1],[UIColor colorWithRed:255.0/255.0 green:20.0/255.0 blue:147.0/255.0 alpha:1],[UIColor colorWithRed:255.0/255.0 green:182.0/255.0 blue:193.0/255.0 alpha:1]];
    [self creatHeadeerView];
    
    //设置导航栏的着色
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:22.0/255.0 green:31.0/255.0 blue:68.0/255.0 alpha:1];
    
    //表视图刚开始的contentOffset就为-64.0f
    self.preContentOffsetY = -64.0f;
    
    //设置导航项目的标题视图
    UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:NAVIGATIONITEM_TITLE_VIEW_RECT];
    [titleImageView setContentMode:UIViewContentModeScaleAspectFit];
    UIImage *titleImage = [UIImage imageNamed:@"title"];
    titleImageView.image = titleImage;
    self.navigationItem.titleView = titleImageView;
    
    //导航项目左边按钮,用于设置
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(setting:) forControlEvents:UIControlEventTouchUpInside];
    leftButton.frame = CGRectMake(0, 0, 30, 30);
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    //导航项目右边按钮,用于添加任务
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"adding"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(insertNewObject:) forControlEvents:UIControlEventTouchUpInside];
    rightButton.frame = CGRectMake(0, 0, 30, 30);
    
    UIBarButtonItem *rightBarbutton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarbutton;
    
    //读取文件，将用户已经创建的任务读入任务数组
    self.taskBL = [[WLJTaskBL alloc] init];
//    //测试
//    WLJTask *task = [[WLJTask alloc] init];
//    task.title = @"wang";
//    task.date = [NSDate date];
//    task.detail = @"lin";
//    [self.taskBL createTask:task];
    self.Tasks = [self.taskBL findAllTask];
//    for (int i = 0; i < [self.Tasks count]; i++) {
//        NSLog(@"%d : %@", i, [self.Tasks objectAtIndex:i]);
//    }
    
    //注册通知中心的重载视图通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadView:) name:RELOAD_VIEW_NOTIFICATION object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

//导航栏左侧按钮出发动作，弹出提供设置的模态视图
- (void)setting:(UIButton *)button
{
    //setting按钮的动画效果
    [UIView animateWithDuration:0.3 animations:^{
        button.transform = CGAffineTransformMakeRotation(M_PI);
    } completion:^(BOOL finished) {
        button.transform = CGAffineTransformMakeRotation(0);
    }];
    
}

//状态栏状态设置
- (BOOL)prefersStatusBarHidden{
    return self.hideStatusBar;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation{
    return UIStatusBarAnimationSlide;
}

//插入任务
- (void)insertNewObject:(UIButton *)button
{
    //adding按钮的动画效果
    [UIView animateWithDuration:0.3 animations:^{
        button.transform = CGAffineTransformMakeRotation(M_PI);
    } completion:^(BOOL finished) {
        button.transform = CGAffineTransformMakeRotation(0);
    }];
    //测试，弹出创建任务视图
    [self presentCreateTaskView];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//    //调用编辑任务
//    [self editTask:indexPath];
}
//编辑任务
- (void)editTask:(NSIndexPath *)indexPath{

    WLJTaskCell *taskCell = (WLJTaskCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    //添加任务重要性图片
    taskCell.taskImageView.image = [UIImage imageNamed:@"unimportant"];
    
    //添加任务的时间
    NSDate *createTaskDate = [NSDate date];
    taskCell.taskCreatedDateLabel.text =
    [NSDateFormatter localizedStringFromDate:createTaskDate dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterShortStyle];
    
    //添加任务的标题
    taskCell.taskTitleLabel.text = @"I AM WANGLIN I AM JASPER";
    
    //设置单元的颜色
    taskCell.myContentView.backgroundColor = taskCell.cellColor;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    //把输入的文本变成富文本
    NSMutableAttributedString *taskAttributeNameString = [[NSMutableAttributedString alloc] initWithString:textField.text];
    NSDictionary *taskNameAttributs = @{NSFontAttributeName : [UIFont fontWithName:@"Courier" size:23] ,NSStrokeWidthAttributeName : @3.0 };
    NSRange range;
    range.location = 0;
    range.length = [taskAttributeNameString length];
    
    [taskAttributeNameString setAttributes:taskNameAttributs range:range];
    textField.textColor = [UIColor purpleColor];
    textField.attributedText = taskAttributeNameString;
    
    [textField resignFirstResponder];
    return YES;
}



#pragma mark - Header View
- (void)creatHeadeerView{
    self.headerView = [[WLJHeaderView alloc] initWithFrame:HEADER_INIT_FRAME];
    self.headerView.delegate = self;
    [self.tableView setTableHeaderView:self.headerView];

    //当前的日期标签
    CGRect timeLabelRect = CGRectMake(0, self.headerView.bounds.size.height / 2 - TIMELABEL_HEIGHT / 2, self.headerView.bounds.size.width, TIMELABEL_HEIGHT);
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:timeLabelRect];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    
    NSDate *now = [NSDate date];
    NSMutableAttributedString *timeAttributeText = [[NSMutableAttributedString alloc] initWithString:[NSDateFormatter localizedStringFromDate:now dateStyle:NSDateFormatterLongStyle timeStyle:NSDateFormatterNoStyle]];
    
    NSDictionary *timeAttributs = @{NSFontAttributeName : [UIFont fontWithName:@"Courier" size:24] ,NSStrokeWidthAttributeName : @3.0 };
    NSRange range;
    range.location = 0;
    range.length = [timeAttributeText length];
    [timeAttributeText setAttributes:timeAttributs range:range];
    
    timeLabel.attributedText = timeAttributeText;
    timeLabel.textColor = [UIColor whiteColor];
    [self.headerView.scrollView addSubview:timeLabel];
    
    CGRect weatherLabelRect = timeLabelRect;
    weatherLabelRect.origin.y +=30;
    UILabel * weatherLabel= [[UILabel alloc] initWithFrame:weatherLabelRect];
    NSMutableAttributedString *weatherString = [[NSMutableAttributedString alloc] initWithString:@"Weather"];
    NSDictionary *weatherAttributs = @{NSFontAttributeName : [UIFont fontWithName:@"Courier" size:20] ,NSStrokeWidthAttributeName : @3.0 };
    weatherLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    range.length = [weatherString length];
    [weatherString setAttributes:weatherAttributs range:range];
    weatherLabel.attributedText = weatherString;
    
    weatherLabel.textAlignment = NSTextAlignmentCenter;
    [self.headerView.scrollView addSubview:weatherLabel];
}


#pragma mark - Header View Delegate Method

- (void)toggleHeaderViewFrame{
    
//    self.headerView.isExpanded = !self.headerView.isExpanded;
//    
//    [UIView animateWithDuration:0.8 animations:^{
//        if (self.headerView.isExpanded) {
//            //视图处于展开的状态，tableView要移动到合适的位置,防止了表视图的头视图缩放有问题
//            self.tableView.contentOffset = CGPointMake(0, -64.0);
//            //当头视图处展开状态的时候，右边的添加任务按钮不可用
//            self.navigationItem.rightBarButtonItem.enabled = NO;
//    
//        }else{
//            self.navigationItem.rightBarButtonItem.enabled = YES;
//        }
//        [self.headerView updateFrame:self.headerView.isExpanded ? CGRectMake(0, self.tableView.contentOffset.y, self.view.frame.size.width, self.view.frame.size.height) : HEADER_INIT_FRAME];
//        
//    } completion:^(BOOL finished){
//        //表视图的头视图展开后，禁止表视图滚动
//        [self.tableView setScrollEnabled:!self.headerView.isExpanded];
//        if (self.headerView.isExpanded && self.hideStatusBar == YES) {
//            self.hideStatusBar = NO;
//            [UIView animateWithDuration:0.3 animations:^{
//                [self setNeedsStatusBarAppearanceUpdate];
//            }];
//        }
//    }];
}


#pragma mark - ScrollView Method


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    float dalta = 0.0f;
    CGRect rect = HEADER_INIT_FRAME;
    
    if (self.tableView.contentOffset.y < -64.0f) {
        dalta = fabs(MIN(-64.0f, self.tableView.contentOffset.y));
        rect.origin.y -= (dalta - 64.0);
        rect.size.height += (dalta - 64.0);
        [self.headerView updateFrame:rect];
    }
    
    if (scrollView.contentOffset.y > self.preContentOffsetY) {
        self.hideStatusBar = YES;
        [UIView animateWithDuration:0.25 animations:^{
            [self setNeedsStatusBarAppearanceUpdate];
        }];
    }else if (scrollView.contentOffset.y < self.preContentOffsetY){
        self.hideStatusBar = NO;
        [UIView animateWithDuration:0.25 animations:^{
            [self setNeedsStatusBarAppearanceUpdate];
        }];
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.preContentOffsetY = scrollView.contentOffset.y;
}

#pragma mark - Table View Delegate and DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kTaskCellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.Tasks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"生成任务单元");
    WLJTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:kWLJTaskCellIdentifier forIndexPath:indexPath];
    
    WLJTask *task = self.Tasks[indexPath.row];
    
    /*
     *设置任务单元的内容
     */
    //任务标题
    cell.taskTitleLabel.text = task.title;
    
    //任务创建时间
    cell.taskCreatedDateLabel.text = [NSDateFormatter localizedStringFromDate:task.date dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterShortStyle];
    
    //任务单元的重要性图标
    cell.taskImageView.image = task.isImportant ? [UIImage imageNamed:@"important"] : [UIImage imageNamed:@"unimportant"];
    
    //任务单元颜色
    cell.myContentView.backgroundColor = [cell cellColor];
    
    //保存任务单元的索引(重要，否则无法正常工作)
    cell.indexPath = indexPath;
    
    cell.dataSource = self;
    cell.delegate = self;
    //需要的时候调整按钮的大小和位置
    [cell setNeedsUpdateConstraints];
    
    if ([self.taskCellsCurrentlyEditing containsObject:indexPath]) {
        [cell openCell:NO];
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //弹出详细任务单
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    WLJTaskDetailViewController *taskDetailViewController = [storyboard instantiateViewControllerWithIdentifier:@"TaskDetailVIewController"];
    taskDetailViewController.delegate = self;
    self.currentSelectedCellIndexPath = indexPath;
    [self presentViewController:taskDetailViewController animated:YES completion:nil];
}
-(void)closeModal{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //完成任务，即要删除任务
        WLJTask *deletedTask = self.Tasks[indexPath.row];
        [self.taskBL removeTask:deletedTask];
        self.Tasks = [self.taskBL findAllTask];
        
        //删除表视图中的任务单元
        WLJTaskCell *deletedCell = (WLJTaskCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        [self swipeableCellDidClose:deletedCell];
        [deletedCell closeCell:YES];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        NSLog(@"插入操作");
    }

    [self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.5];
}

#pragma mark - DNSSwipeableCellDataSource

#pragma mark Required Methods
- (NSInteger)numberOfButtonsInSwipeableCellAtIndexPath:(NSIndexPath *)indexPath{
    return 3;
}

- (NSString *)titleForButtonAtIndex:(NSInteger)index inCellAtIndexPath:(NSIndexPath *)indexPath{
    switch (index) {
        case 0:
            return @" Done ";
            break;
        case 1:
            return @" Edit ";
            break;
        case 2:
            return @"Urgent";
            break;
        default:
            break;
    }
    return nil;
}

- (UIColor *)backgroundColorForButtonAtIndex:(NSInteger)index inCellAtIndexPath:(NSIndexPath *)indexPath{

    return [self.backgroundColors objectAtIndex:index];
}

- (UIColor *)textColorForButtonAtIndex:(NSInteger)index inCellAtIndexPath:(NSIndexPath *)indexPath{
    return [UIColor whiteColor];
}


#pragma mark Optional Methods
- (CGFloat)fontSizeForButtonAtIndex:(NSInteger)index inCellAtIndexPath:(NSIndexPath *)indexPath{
    return 15.0f;
}
- (NSString *)fontNameForButtonAtIndex:(NSInteger)index inCellAtIndexPath:(NSIndexPath *)indexPath{
    return @"AmericanTypewriter";
}

#pragma mark - DNSSwipeableCellDelegate
- (void)swipeableCell:(DNSSwipeableCell *)cell didSelectButtonAtIndex:(NSInteger)index{
    //点中任务单元中的某个按钮
    if (index == 0) {
        //点击完成按钮
        [self.taskCellsCurrentlyEditing removeObject:cell.indexPath];
        [self tableView:self.tableView commitEditingStyle:UITableViewCellEditingStyleDelete forRowAtIndexPath:cell.indexPath];
        
    }else if(index == 1){
        [self swipeableCellDidClose:cell];
        [cell closeCell:YES];
        
        //点击编辑按钮，弹出编辑视图
        
    }else{
        WLJTask *modifyTask = [self.Tasks objectAtIndex:cell.indexPath.row];
        if (modifyTask.isImportant) {

            modifyTask.isImportant = NO;
            [(WLJTaskCell *)cell taskImageView].image = [UIImage imageNamed:@"unimportant"];
        
        }else{
        
            modifyTask.isImportant = YES;
            [(WLJTaskCell *)cell taskImageView].image = [UIImage imageNamed:@"important"];
        }
        //更新数据库信息
        [self.taskBL modifyTask:modifyTask];
        self.Tasks = [self.taskBL findAllTask];
        
        [self swipeableCellDidClose:cell];
        [cell closeCell:YES];
        
    }
}

- (void)swipeableCellDidOpen:(DNSSwipeableCell *)cell{
    
    if (self.currentEditingCellIndexPath.row != -1) {
        WLJTaskCell *preCell = (WLJTaskCell *)[self.tableView cellForRowAtIndexPath:self.currentEditingCellIndexPath];
        [self swipeableCellDidClose:preCell];
        [preCell closeCell:YES];
    }
    self.currentEditingCellIndexPath = cell.indexPath;
    
    //添加正在编辑的单元索引到编辑单元数组中
    [self.taskCellsCurrentlyEditing addObject:cell.indexPath];
}

- (void)swipeableCellDidClose:(DNSSwipeableCell *)cell{
    //从编辑单元数组中移除指定的单元索引
    [self.taskCellsCurrentlyEditing removeObject:cell.indexPath];
}

#pragma mark - present create task view or modify task veiw

- (void)presentCreateTaskView
{

    CGRect mainRect = [[UIScreen mainScreen] bounds];
    CGRect beginRect = CGRectMake(0, mainRect.size.height, mainRect.size.width, mainRect.size.height);
    UIView *createTaskView = [[UIView alloc] initWithFrame: beginRect];
    createTaskView.tag = CREATE_TASK_VIEW_TAG;
    createTaskView.alpha = 0.97;
    //添加背景图片
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:mainRect];
    bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    bgImageView.image = [UIImage imageNamed:@"bg"];
    [createTaskView addSubview:bgImageView];
//    //添加磨砂效果
//    UIImageView * blurredImageView = [[UIImageView alloc]init];
//    blurredImageView.contentMode = UIViewContentModeScaleAspectFill;
//    blurredImageView.alpha = 1;
//    [blurredImageView setImageToBlur:[UIImage imageNamed:@"bg"] blurRadius:10.0f completionBlock:nil];
//    [createTaskView addSubview:blurredImageView];
//    
    [self.navigationController.view addSubview:createTaskView];
    
    /*
     *添加输入框
     */
    //任务标题
    CGRect taskTitleRect = CGRectMake(0, 64.0f, mainRect.size.width, 30.0f);
    UILabel *taskTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, mainRect.size.height, mainRect.size.width, 30.0f)];
    taskTitle.tag = 1;
    taskTitle.font = [UIFont fontWithName:@"AmericanTypewriter" size:20.0f];
    taskTitle.textColor = [UIColor whiteColor];
    taskTitle.textAlignment = NSTextAlignmentCenter;
    taskTitle.text = @"Task Title";
    [createTaskView addSubview:taskTitle];
    
    CGRect taskTitleTextRect = CGRectMake(0, 94.0f, mainRect.size.width, 40.0f);
    UITextField *taskTitleTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, mainRect.size.height + 30.0f, mainRect.size.width, 40.0f)];
    taskTitleTextField.tag = 2;
    taskTitleTextField.borderStyle = UITextBorderStyleRoundedRect;
    taskTitleTextField.alpha = 0.6;
    taskTitleTextField.font = [UIFont fontWithName:@"AmericanTypewriter" size:20.0f];
    taskTitleTextField.textColor = [UIColor whiteColor];
    taskTitleTextField.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:187.0/255.0 blue:255.0/255.0 alpha:1];
    taskTitleTextField.placeholder = @"new task title";
    [createTaskView addSubview:taskTitleTextField];
    
    //任务细节
    CGRect taskDetailRect = CGRectMake(0, 134.0f, mainRect.size.width, 30.0f);
    UILabel *taskDetail = [[UILabel alloc]initWithFrame:CGRectMake(0, mainRect.size.height + 70.0f, mainRect.size.width, 30.0f)];
    taskDetail.tag = 3;
    taskDetail.font = [UIFont fontWithName:@"AmericanTypewriter" size:20.0f];
    taskDetail.textColor = [UIColor whiteColor];
    taskDetail.textAlignment = NSTextAlignmentCenter;
    taskDetail.text = @"Task Detail";

    [createTaskView addSubview:taskDetail];
    
    CGRect taskDetailTextRect = CGRectMake(0, 164.0f, mainRect.size.width, 460.0f);
    UITextView *taskDetailTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, mainRect.size.height + 100.0f, mainRect.size.width, 460.0f)];
    taskDetailTextView.tag = 4;
    taskDetailTextView.layer.cornerRadius = 10.0f;
    //bouncesZoom和bounces数值默认是YES
    //taskDetailTextView.bouncesZoom = YES;
    //taskDetailTextView.bounces = YES;
    taskDetailTextView.alpha = 0.6;
    taskDetailTextView.textAlignment = NSTextAlignmentCenter;
    taskDetailTextView.font = [UIFont fontWithName:@"AmericanTypewriter" size:20.0f];
    taskDetailTextView.textColor = [UIColor whiteColor];
    taskDetailTextView.backgroundColor = [UIColor colorWithRed:85.0/255.0 green:26.0/255.0 blue:139.0/255.0 alpha:1];
    taskDetailTextView.text = @"Jasper";
    [createTaskView addSubview:taskDetailTextView];
    
    /*
     *创建任务导航栏的样式（取消和保存按钮）
     */
    //导航栏和导航项目
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 20.0f, mainRect.size.width, 44.0f)];
    navigationBar.barTintColor = [UIColor colorWithRed:22.0/255.0 green:31.0/255.0 blue:68.0/255.0 alpha:1];
    UINavigationItem *navigationItem = [[UINavigationItem alloc] init];
    //导航栏标题视图
    UILabel *navigationItemTitleLabel = [[UILabel alloc] initWithFrame:NAVIGATIONITEM_TITLE_VIEW_RECT];
    navigationItemTitleLabel.font = [UIFont fontWithName:@"AmericanTypewriter" size:26.0f];
    navigationItemTitleLabel.textAlignment = NSTextAlignmentCenter;
    navigationItemTitleLabel.text = @"Task Create";
    navigationItemTitleLabel.textColor = [UIColor whiteColor];
    navigationItem.titleView = navigationItemTitleLabel;
    //导航栏右侧按钮
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"save"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(saveCreateTask) forControlEvents:UIControlEventTouchUpInside];
    rightButton.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *rightBarbutton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    navigationItem.rightBarButtonItem = rightBarbutton;
    //导航栏左侧按钮
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(cancelCreateTask) forControlEvents:UIControlEventTouchUpInside];
    leftButton.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *leftBarbutton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    navigationItem.leftBarButtonItem = leftBarbutton;
    
    [navigationBar pushNavigationItem:navigationItem animated:YES];

    
    [createTaskView addSubview:navigationBar];
    
    //创建任务的视图弹出的动画效果
    [UIView animateWithDuration:0.35f animations:^{
        createTaskView.frame = mainRect;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            taskTitle.frame = taskTitleRect;
        }];
        [UIView animateWithDuration:0.25 animations:^{
            taskTitleTextField.frame = taskTitleTextRect;
        }];
        
        [UIView animateWithDuration:0.3 animations:^{
            taskDetail.frame = taskDetailRect;
        }];
        
        [UIView animateWithDuration:0.35 animations:^{
            taskDetailTextView.frame = taskDetailTextRect;
        }];
    }];
    

}

- (void)saveCreateTask{

    UIView *dismissCreateTaskView = [self.navigationController.view viewWithTag:CREATE_TASK_VIEW_TAG];
    
    UILabel *titleLabel = (UILabel *)[dismissCreateTaskView viewWithTag:1];
    UITextField *titleTextField = (UITextField *)[dismissCreateTaskView viewWithTag:2];
    UILabel *taskDetailLabel = (UILabel *)[dismissCreateTaskView viewWithTag:3];
    UITextView *taskDetailTextView = (UITextView *)[dismissCreateTaskView viewWithTag:4];
    
    /*
     *创建任务
     */
    //创建任务
    WLJTask *newTask = [[WLJTask alloc] init];
    newTask.title = titleTextField.text;
    newTask.date = [NSDate date];
    newTask.detail = taskDetailTextView.text;
    //把任务出入数据库
    [self.taskBL createTask:newTask];
    //更新tasks数据
    self.Tasks = [self.taskBL findAllTask];
    
    //动画弹出
    CGRect mainRect = [UIScreen mainScreen].bounds;
    CGRect titleLabelRect = CGRectMake(0, mainRect.size.height, mainRect.size.width, 30.0f);
    CGRect titleTextFieldRect = CGRectMake(0, mainRect.size.height + 30.0f, mainRect.size.width, 40.0f);
    CGRect taskDetailLabelRect = CGRectMake(0, mainRect.size.height + 70.0f, mainRect.size.width, 30.0f);
    CGRect taskDetailTextViewRect = CGRectMake(0, mainRect.size.height + 100.0f, mainRect.size.width, 460.0f);
    
    [UIView animateWithDuration:0.35 animations:^{
        titleLabel.frame = titleLabelRect;
    }];
    [UIView animateWithDuration:0.3 animations:^{
        titleTextField.frame = titleTextFieldRect;
    }];
    [UIView animateWithDuration:0.25 animations:^{
        taskDetailLabel.frame = taskDetailLabelRect;
    }];
    [UIView animateWithDuration:0.2 animations:^{
        taskDetailTextView.frame = taskDetailTextViewRect;
    }];
    [UIView animateWithDuration:0.45 animations:^{
        dismissCreateTaskView.frame = CGRectMake(0, mainRect.size.height, mainRect.size.width, mainRect.size.height);
    } completion:^(BOOL finished) {
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        //记住，一定能够要重载一下
        [self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.5f];
        [dismissCreateTaskView removeFromSuperview];
    }];

}
-(void)cancelCreateTask{
    UIView *dismissCreateTaskView = [self.navigationController.view viewWithTag:CREATE_TASK_VIEW_TAG];
    
    UILabel *titleLabel = (UILabel *)[dismissCreateTaskView viewWithTag:1];
    UITextField *titleTextField = (UITextField *)[dismissCreateTaskView viewWithTag:2];
    UILabel *taskDetailLabel = (UILabel *)[dismissCreateTaskView viewWithTag:3];
    UITextView *taskDetailTextView = (UITextView *)[dismissCreateTaskView viewWithTag:4];
    
    CGRect mainRect = [UIScreen mainScreen].bounds;
    CGRect titleLabelRect = CGRectMake(0, mainRect.size.height, mainRect.size.width, 30.0f);
    CGRect titleTextFieldRect = CGRectMake(0, mainRect.size.height + 30.0f, mainRect.size.width, 40.0f);
    CGRect taskDetailLabelRect = CGRectMake(0, mainRect.size.height + 70.0f, mainRect.size.width, 30.0f);
    CGRect taskDetailTextViewRect = CGRectMake(0, mainRect.size.height + 100.0f, mainRect.size.width, 460.0f);
    
    [UIView animateWithDuration:0.35 animations:^{
        titleLabel.frame = titleLabelRect;
    } completion:^(BOOL finished) {
       
    }];
    [UIView animateWithDuration:0.3 animations:^{
        titleTextField.frame = titleTextFieldRect;
    }];
    [UIView animateWithDuration:0.25 animations:^{
        taskDetailLabel.frame = taskDetailLabelRect;
    }];
    [UIView animateWithDuration:0.2 animations:^{
        taskDetailTextView.frame = taskDetailTextViewRect;
    }];
    [UIView animateWithDuration:0.45 animations:^{
        dismissCreateTaskView.frame = CGRectMake(0, mainRect.size.height, mainRect.size.width, mainRect.size.height);
    } completion:^(BOOL finished) {
        [dismissCreateTaskView removeFromSuperview];
    }];
}

//重新载入表视图数据
- (void)reloadView: (NSNotification *)notification
{
    self.Tasks = [self.taskBL findAllTask];
    [self.tableView reloadData];
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    /*if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = _objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }*/
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
