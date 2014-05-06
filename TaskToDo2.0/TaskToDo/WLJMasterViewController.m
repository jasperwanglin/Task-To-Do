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
#define HEADER_HEIGHT 200.0f
#define HEADER_INIT_FRAME CGRectMake(0, 0, self.view.frame.size.width, HEADER_HEIGHT)
#define TIMELABEL_HEIGHT 50.0f
#define IMAGEVIEW_FRAME CGRectMake(0, 0, self.view.frame.size.width, HEADER_HEIGHT)
#define TEXTFIELD_FRAME CGRectMake(0, 0, self.view.frame.size.width, HEADER_HEIGHT)


typedef NS_ENUM(NSInteger, RE_EDITING_TYPE) {
    BeImportant = 0 ,
    ReName,
};


int rowNum;
@interface WLJMasterViewController () <DNSSwipeableCellDataSource,DNSSwipeableCellDelegate,HeaderViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) WLJHeaderView *headerView;//表视图的头视图
@property (nonatomic, strong) NSMutableArray *taskCellsCurrentlyEditing;//存放正在编辑的任务
@property (nonatomic, strong) NSMutableArray *Tasks;//存放已经添加的任务
@property (nonatomic, strong) NSArray *backgroundColors;//任务单元中的按钮的颜色
@property (nonatomic, strong) NSArray *buttonTextColors;
@property (nonatomic, assign) BOOL hideStatusBar;
@property (nonatomic, assign) CGFloat preContentOffsetY;

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
    rowNum = 6;
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    //添加“添加按钮”到导航栏，用于添加任务
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    //设置状态栏状态为显示
    self.hideStatusBar = NO;
    
    //表视图的背景颜色和内容视图的背景颜色
    self.tableView.backgroundColor = [UIColor colorWithRed:22.0/255.0 green:31.0/255.0 blue:68.0/255.0 alpha:1];
    
    //表视图的单元分割线设置
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //初始化编辑单元数组
    self.taskCellsCurrentlyEditing = [NSMutableArray array];
    
    //登记重复使用的任务单元
    [self.tableView registerClass:[WLJTaskCell class] forCellReuseIdentifier:kWLJTaskCellIdentifier];
    
    //读取文件，将用户已经创建的任务读入
    
    
    //设置单元按钮的背景颜色
    self.backgroundColors = @[[UIColor colorWithRed:255.0/255.0 green:0 blue:0 alpha:1],[UIColor colorWithRed:255.0/255.0 green:20.0/255.0 blue:147.0/255.0 alpha:1],[UIColor colorWithRed:255.0/255.0 green:182.0/255.0 blue:193.0/255.0 alpha:1]];
    [self creatHeadeerView];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:22.0/255.0 green:31.0/255.0 blue:68.0/255.0 alpha:1];
    
    //表视图刚开始的contentOffset就为-64.0f
    self.preContentOffsetY = -64.0f;
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
- (void)insertNewObject:(id)sender
{
    rowNum++;//注意，添加任务的时候，行数一定要增加
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    //调用编辑任务
    [self editTask:indexPath];
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
    
//    CGFloat taskTextFieldOrigin = CGRectGetMaxX(taskCell.taskImageView.frame) + betweenViewsMargin;
//    CGFloat taskTextFieldWidth = CGRectGetWidth(taskCell.frame) - taskTextFieldOrigin - taskCellRightMargin;
//    taskCell.taskNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(taskTextFieldOrigin, 0, taskTextFieldWidth, kTaskCellHeight)];
//    taskCell.taskNameTextField.delegate = self;
//    taskCell.taskNameTextField.textAlignment = NSTextAlignmentCenter;
//    taskCell.taskNameTextField.returnKeyType = UIReturnKeyDone;
//    [taskCell.myContentView addSubview:taskCell.taskNameTextField];
//    //把要编辑的视图变成第一响应者
//    [taskCell.taskNameTextField becomeFirstResponder];
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Header View Delegate Method
- (void)toggleHeaderViewFrame{
    [UIView animateWithDuration:0.8 animations:^{
        
        self.headerView.isExpanded = !self.headerView.isExpanded;
        if (self.headerView.isExpanded) {
            //视图处于展开的状态，tableView要移动到合适的位置
            self.tableView.contentOffset = CGPointMake(0, -64.0);
            //当头视图处展开状态的时候，右边的添加任务按钮不可用
            self.navigationItem.rightBarButtonItem.enabled = NO;
        }else{
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }
        [self.headerView updateFrame:self.headerView.isExpanded ? CGRectMake(0, self.tableView.contentOffset.y, self.view.frame.size.width, self.view.frame.size.height) : HEADER_INIT_FRAME];
        
    } completion:^(BOOL finished){
        //表视图的头视图展开后，禁止表视图滚动
        [self.tableView setScrollEnabled:!self.headerView.isExpanded];
    }];
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
        [UIView animateWithDuration:0.5 animations:^{
            [self setNeedsStatusBarAppearanceUpdate];
        }];
    }else if (scrollView.contentOffset.y < self.preContentOffsetY){
        self.hideStatusBar = NO;
        [UIView animateWithDuration:0.5 animations:^{
            [self setNeedsStatusBarAppearanceUpdate];
        }];
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.preContentOffsetY = scrollView.contentOffset.y;
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kTaskCellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return rowNum;//[self.Tasks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"生成任务单元");
    WLJTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:kWLJTaskCellIdentifier forIndexPath:indexPath];
    
    //设置任务单元的内容
    if (1) {
        //任务是重要的
        
        //设置图像
        
        //设置任务标题
        
    }else{
        //设置任务标题
        
    }
    
    //保存任务单元的索引
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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //完成任务，即要删除任务
//        [self.Tasks removeObjectAtIndex:indexPath.row];
        //删除表视图中的任务单元
        rowNum -= 1;
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

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //弹出详细任务单
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
        [self ReEditinga:ReName :(WLJTaskCell *)cell];
        
        //点击编辑按钮，弹出编辑视图
        
    }else{
        [self swipeableCellDidClose:cell];
        [cell closeCell:YES];
        [self ReEditinga:BeImportant :(WLJTaskCell *)cell];
        
        //点击重要按钮,给任务表单添加重要图标，调整任务标题的位置
    }
}

//编辑任务：包括设置为重点任务和改变任务的名称
- (void) ReEditinga:(RE_EDITING_TYPE)editingType : (WLJTaskCell *)taskCell{
    switch (editingType) {
        case ReName:
            [taskCell.taskNameTextField becomeFirstResponder];
            break;
        case BeImportant:
            if ([taskCell.taskImageView.image isEqual:[UIImage imageNamed:@"important"]]) {
                taskCell.taskImageView.image = [UIImage imageNamed:@"unimportant"];
                taskCell.taskNameTextField.textColor = [UIColor purpleColor];
            }else{
                taskCell.taskImageView.image = [UIImage imageNamed:@"important"];
                taskCell.taskNameTextField.textColor = [UIColor redColor];
            }

            break;
            
        default:
            break;
    }
}

- (void)swipeableCellDidOpen:(DNSSwipeableCell *)cell{
    //添加正在编辑的单元索引到编辑单元数组中
    [self.taskCellsCurrentlyEditing addObject:cell.indexPath];
}

- (void)swipeableCellDidClose:(DNSSwipeableCell *)cell{
    //从编辑单元数组中移除指定的单元索引
    [self.taskCellsCurrentlyEditing removeObject:cell.indexPath];
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

@end
