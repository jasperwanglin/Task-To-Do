//
//  WLJHeaderView.h
//  TaskToDo
//
//  Created by 王 霖 on 14-4-1.
//  Copyright (c) 2014年 Jasper. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HeaderViewDelegate <NSObject>

@optional
- (void)toggleHeaderViewFrame;

@end

@interface WLJHeaderView : UIView <UIScrollViewDelegate>

@property (nonatomic, weak) id <HeaderViewDelegate> delegate;
@property (nonatomic, assign) BOOL isExpanded;
@property (nonatomic, assign) BOOL pageControlUsed;
@property (nonatomic, assign) NSInteger viewControllersNum;
@property (nonatomic, strong) NSMutableArray *viewControllers;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;

- (void)updateFrame:(CGRect)rect;

@end
