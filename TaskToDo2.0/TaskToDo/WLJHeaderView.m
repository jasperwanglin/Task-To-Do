//
//  WLJHeaderView.m
//  TaskToDo
//
//  Created by 王 霖 on 14-4-1.
//  Copyright (c) 2014年 Jasper. All rights reserved.
//

#import "WLJHeaderView.h"

@implementation WLJHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.viewControllersNum = 2;
        //头部视图中的滚动视图中的视图控制器数组初始化
        NSMutableArray *controllers = [[NSMutableArray alloc] init];
        for (unsigned i = 0; i < self.viewControllersNum; i++) {
            [controllers addObject:[NSNull null]];
        }
        self.viewControllers = controllers;
        
        //滚动视图控制器设置
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * self.viewControllersNum, self.scrollView.frame.size.height);
        self.scrollView.pagingEnabled = YES;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.scrollsToTop = NO;
        self.scrollView.autoresizesSubviews = YES;
        self.scrollView.delegate = self;
        self.scrollView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.scrollView];
        
        //当前滚动视图没有展开
        self.isExpanded = NO;
        
        UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap)];
        singleFingerTap.numberOfTapsRequired = 1;
        [self.scrollView addGestureRecognizer:singleFingerTap];
        
        
        //设置页面控制器
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 20, self.frame.size.width, 10)];
        self.pageControl.numberOfPages = self.viewControllersNum;
        self.pageControl.backgroundColor = [UIColor clearColor];
        [self.pageControl setUserInteractionEnabled:NO];
        [self.pageControl setPageIndicatorTintColor:[UIColor lightGrayColor]];
        [self.pageControl setCurrentPageIndicatorTintColor:[UIColor whiteColor]];
        if (self.viewControllersNum > 1) {
            [self addSubview:self.pageControl];
        }
        
        [self loadScrollViewWithPage:0];
        [self loadScrollViewWithPage:1];
    }
    return self;
}

#pragma mark - Public Methods
/**
 * 更新头视图的框架以及他包含的滚动视图
 * @param CGRect -传入的CGRect作为要更新的框架
 * @return 无返回值
 */
- (void)updateFrame:(CGRect)rect{
    self.scrollView.frame = rect;
    CGRect viewRect = CGRectMake(0, 0, self.frame.size.width, self.scrollView.frame.size.height);
    self.frame = viewRect;
    
    //调整页控制器的位置
    float pageControlY = self.frame.size.height + self.scrollView.frame.origin.y - 20.0f;
    self.pageControl.frame = CGRectMake(0.0f, pageControlY, self.frame.size.width, 10.0f);
}

#pragma mark - UITapGestureRecognizer
- (void)didTap{
    if ([self.delegate respondsToSelector:@selector(toggleHeaderViewFrame)]) {
        [self.delegate performSelector:@selector(toggleHeaderViewFrame)];
    }
}

#pragma mark - Load ScrollView Pages
- (void)loadScrollViewWithPage:(int)Page {
    if (Page < 0) return;
    if (Page >= self.viewControllersNum) return;
    
    //磨砂效果的视图
    UIView *view = [self.viewControllers objectAtIndex:Page];
    switch (Page) {
        case 0:
            if ((NSNull *)view == [NSNull null]) {
                view = [[UIView alloc] init];
                view.backgroundColor = [UIColor purpleColor];
                CGRect frame = self.scrollView.frame;
                frame.origin.x = frame.size.width * Page;
                frame.origin.y = 0;
                view.frame = frame;
                //注意下面这行代码
                [view setContentMode:UIViewContentModeScaleAspectFill];
                //保证了滚动视图的框架发生变化的时候，它调整到适合的位置
                view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
                [view.layer setMasksToBounds:YES];
                [self.scrollView addSubview:view];
                [self.viewControllers replaceObjectAtIndex:Page withObject:view];
                return;
            }
            case 1:
                if ((NSNull *)view == [NSNull null]) {
                    view = [[UIView alloc] init];
                    CGRect frame = self.scrollView.frame;
                    frame.origin.x = frame.size.width * Page;
                    frame.origin.y = 0;
                    view.frame = frame;
                    //注意下面这行代码
                    [view setContentMode:UIViewContentModeScaleAspectFill];
                    //保证了滚动视图的框架发生变化的时候，它调整到适合的位置
                    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                    [view.layer setMasksToBounds:YES];
                    [self.scrollView addSubview:view];
                    [view setBackgroundColor:[UIColor yellowColor]];
                    [self.viewControllers replaceObjectAtIndex:Page withObject:view];
                    return;
                }
            break;
            
        default:
            break;
    }
}

#pragma mark - ScrollView Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.pageControlUsed) {
        return;
    }
    
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.pageControlUsed = YES;
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    self.pageControlUsed = NO;
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
