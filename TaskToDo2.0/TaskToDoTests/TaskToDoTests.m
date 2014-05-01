//
//  TaskToDoTests.m
//  TaskToDoTests
//
//  Created by 王 霖 on 14-4-1.
//  Copyright (c) 2014年 Jasper. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WLJTaskBL.h"
#import "WLJTask.h"

@interface TaskToDoTests : XCTestCase

@end

@implementation TaskToDoTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
//    WLJTaskBL *taskBL = [[WLJTaskBL alloc] init];
//    
//    //测试：添加任务到数据库
//    WLJTask *task = [[WLJTask alloc] init];
//    task.title = @"Create task test!";
//    task.isImportant = YES;
//    task.date = [NSDate date];
//    task.detail = @"Create task test detail";
//    [taskBL createTask:task];
//    
//    //测试：读取数据库内容
//    NSArray *array = [taskBL findAllTask];
//    NSLog(@"%d",[array count]);
//    for (WLJTask *t in array) {
//        NSLog(@"title:%@ \ndate:%@ \ndetail:%@",t.title,t.date,t.detail);
//        if (t.isImportant) {
//            NSLog(@"YES");
//        }else{
//            NSLog(@"NO");
//        }
//    }
//    
//    //测试：读取指定的数据内容
//    WLJTask *a = [[WLJTask alloc] init];
//    a.date = [[array lastObject] date];
//    WLJTask *b = [taskBL queryTask:a];
//    NSLog(@"读取数据：\n");
//    NSLog(@"title:%@ \ndate:%@ \ndetail:%@",b.title,b.date,b.detail);
//    if (b.isImportant) {
//        NSLog(@"YES");
//    }else{
//        NSLog(@"NO");
//    }
//    
//    //测试：数据库内容的修改
//    a.title = @"modify task test!";
//    a.isImportant = NO;
//    a.detail = @"modify task detail";
//    [taskBL modifyTask:a];
//    NSLog(@"修改数据后的结果：\n");
//    NSArray *arr = [taskBL findAllTask];
//    NSLog(@"%d",[arr count]);
//    for (WLJTask *t in arr) {
//        NSLog(@"title:%@ \ndate:%@ \ndetail:%@",t.title,t.date,t.detail);
//        if (t.isImportant) {
//            NSLog(@"YES");
//        }else{
//            NSLog(@"NO");
//        }
//    }
//    
//    //测试：删除数据库的内容
//    [taskBL removeTask:a];
//    
//    NSArray *arrayDel = [taskBL findAllTask];
//    NSLog(@"%d",[arrayDel count]);
//    for (WLJTask *t in arrayDel) {
//        NSLog(@"title:%@ \ndate:%@ \ndetail:%@",t.title,t.date,t.detail);
//        if (t.isImportant) {
//            NSLog(@"YES");
//        }else{
//            NSLog(@"NO");
//        }
//    }
//    
}

@end
