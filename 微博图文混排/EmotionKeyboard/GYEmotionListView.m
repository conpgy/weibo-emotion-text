//
//  GYEmotionListView.m
//  全是微博
//
//  Created by 彭根勇 on 14-7-16.
//  Copyright (c) 2014年 conpgy. All rights reserved.
//

#import "GYEmotionListView.h"
#import "GYEmotion.h"
#import "GYEmotionGridView.h"

@interface GYEmotionListView ()<UIScrollViewDelegate>

/**
 *  scrollView用来展示表情
 */
@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, weak) UIPageControl *pageControl;


@property (nonatomic, strong) NSMutableArray *pagesView;

@end

@implementation GYEmotionListView

-(NSMutableArray *)pagesView
{
    if (!_pagesView) {
        _pagesView = [NSMutableArray array];
    }
    
    return _pagesView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 1.添加scrollView
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        scrollView.pagingEnabled = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.delegate = self;
        
        // 2. 添加UIPageControl
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        pageControl.hidesForSinglePage = YES;
        // 替换pageControl的图片
        [pageControl setValue:[UIImage imageWithName:@"compose_keyboard_dot_normal"] forKeyPath:@"_pageImage"];
        [pageControl setValue:[UIImage imageWithName:@"compose_keyboard_dot_selected"] forKeyPath:@"_currentPageImage"];
        [self addSubview:pageControl];
        self.pageControl = pageControl;
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置pageControl
    self.pageControl.width = self.width;
    self.pageControl.height = 30;
    self.pageControl.y = self.height - self.pageControl.height;
    
    // 设置scrollView
    self.scrollView.width = self.width;
    self.scrollView.height = self.pageControl.y;
    // 根据表情的数量来设置scrollView的contentSize
    self.scrollView.contentSize = CGSizeMake(self.width * self.pageControl.numberOfPages, 0);
    
    // 计算表情页View的frame
    for (int i = 0; i < self.pagesView.count; i++) {
        GYEmotionGridView *gridView = self.pagesView[i];
        gridView.size = self.scrollView.size;
        gridView.x = i * gridView.width;
    }
}

-(void)setEmotions:(NSArray *)emotions
{
    _emotions = emotions;
    
    // 显示的页数
    int pageCount = (emotions.count + PerPageMaxEmotions - 1) / PerPageMaxEmotions;
    self.pageControl.numberOfPages = pageCount;
    self.pageControl.currentPage = 0;
    
    // 添加单页表情视图
    for (int i = 0; i < pageCount; i++) {
        int count = self.emotions.count;
        int loc = i * PerPageMaxEmotions;
        int len = 20;
        if (loc + len > count) {
            len = self.emotions.count - loc;
        }
        NSRange range = NSMakeRange(loc, len);
        NSArray *subEmotions = [self.emotions subarrayWithRange:range];
        
        GYEmotionGridView *gridView = nil;
        if (i >= self.pagesView.count) {
            gridView = [[GYEmotionGridView alloc] init];
            [self.pagesView addObject:gridView];
            [self.scrollView addSubview:gridView];
        } else {
            gridView = self.pagesView[i];
        }
        gridView.emotions = subEmotions;
        
        gridView.hidden = NO;
    }
    
    // 隐藏没用到的gridView
    for (int i = pageCount; i < self.pagesView.count; i++) {
        GYEmotionGridView *gridView = self.pagesView[i];
        gridView.hidden = YES;
    }
    
    // 重新布局子控件
    [self setNeedsLayout];
    
    // 将scrollView移到第一页
    self.scrollView.contentOffset = CGPointZero;
    
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = (int)(self.scrollView.contentOffset.x / self.width + 0.5);
}

@end
