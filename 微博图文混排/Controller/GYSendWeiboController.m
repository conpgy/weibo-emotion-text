//
//  GYSendWeiboController.m
//  微博图文混排
//
//  Created by 彭根勇 on 14-7-19.
//  Copyright (c) 2014年 conpgy. All rights reserved.
//

#import "GYSendWeiboController.h"
#import "GYEmotionTextView.h"
#import "GYComposeToolBar.h"
#import "GYEmotionKeyboard.h"

@interface GYSendWeiboController ()<UITextViewDelegate, GYComposeToolBarDelegate>

@property (weak, nonatomic) GYEmotionTextView *composeView;

@property (nonatomic, weak) GYComposeToolBar *toolbar;

@property (nonatomic, strong) GYEmotionKeyboard *emotionKeyboard;

/**
 *  是否正在键盘
 */
@property (nonatomic, assign, getter = isChangingKeyboard) BOOL changingKeyboard;

@end

@implementation GYSendWeiboController

#pragma mark - 懒加载

-(GYEmotionKeyboard *)emotionKeyboard
{
    if (!_emotionKeyboard) {
        _emotionKeyboard = [GYEmotionKeyboard keyboard];
        _emotionKeyboard.width = [UIScreen mainScreen].bounds.size.width;
        _emotionKeyboard.height = 216;
    }
    
    return _emotionKeyboard;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 设置导航栏
    [self setNavBar];
    
    // 添加编辑微博控件
    [self setupComposeView];
    
    // 添加工具条
    [self setupComposeToolBar];
    
    // 监听表情键盘表情的选中
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidSelected:) name:GYEmotionDidSelectedNotification object:nil];
    
    // 监听表情键盘删除按钮的点击
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDeleteButtonDidClick:) name:GYEmotionKeyboardDidClickDeleteButtonNotification object:nil];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.composeView becomeFirstResponder];
}

/**
 *  添加工具条
 */

- (void)setupComposeToolBar
{
    GYComposeToolBar *toolbar = [[GYComposeToolBar alloc] init];
    self.toolbar = toolbar;
    toolbar.delegate = self;
    
    // 设置frame
    toolbar.x = 0;
    toolbar.width = self.view.width;
    toolbar.height = 44;
    toolbar.y = self.view.height - toolbar.height;
    
    [self.view addSubview:toolbar];
}

/**
 *  设置编辑微博控件
 */

- (void)setupComposeView
{
    GYEmotionTextView *composeView = [[GYEmotionTextView alloc] init];
    composeView.delegate = self;
    self.composeView = composeView;
    [self.view addSubview:composeView];
    
    // 设置属性
    composeView.frame = self.view.bounds;
    composeView.placeholder = @"分享新鲜事...";
    composeView.alwaysBounceVertical = YES;
    
    // 监听键盘
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setNavBar
{
    self.title = @"发微博";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(send)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
}


/**
 *  监听发布微博按钮点击
 */
- (void)send
{
    // 发布微博
    [self sendStatus];
}

/**
 *  取消发布微博
 */
- (void)cancel
{
    NSLog(@"取消发送");
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  发布微博
 */
- (void)sendStatus
{
    // 发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:GYSendWeiboNotification object:nil userInfo:@{GYStatusContent: self.composeView.realText}];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD showSuccess:@"发送成功"];
    });
    
    // 再过1s关闭发微博控制器
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
    
}

#pragma mark - UITextViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing: YES];
}

- (void)textViewDidChange:(UITextView *)textView
{
    self.navigationItem.rightBarButtonItem.enabled = textView.hasText;
}

#pragma mark - GYComposeToolBarDelegate

-(void)composeToolBar:(GYComposeToolBar *)toolBar DidClickButton:(GYComposeToolBarButtonType)buttonType
{
    switch (buttonType) {
        case GYComposeToolBarButtonTypeCamera:
            break;
            
        case GYComposeToolBarButtonTypePicture:
            break;
            
        case GYComposeToolBarButtonTypeEmotion:
            [self openEmotion];
            break;
            
        default:
            break;
    }
}

/**
 *  显示表情页
 */

- (void)openEmotion
{
    self.changingKeyboard = YES;
    
    if (self.composeView.inputView) {
        self.composeView.inputView = nil;
    } else {
        self.composeView.inputView = self.emotionKeyboard;
    }
    
    [self.composeView resignFirstResponder];
    self.changingKeyboard = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.composeView becomeFirstResponder];
    });
}

#pragma mark - 监听键盘

/**
 *  键盘将要显示
 */
- (void)keyboardWillShow:(NSNotification *)note
{
    // 计算键盘弹出需要的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        // 取出键盘的高度
        CGRect keyboardF = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGFloat keyboardH = keyboardF.size.height;
        self.toolbar.transform = CGAffineTransformMakeTranslation(0, -keyboardH);
    }];
}

/**
 *  键盘即将隐藏
 */
- (void)keyboardWillHide:(NSNotification *)note
{
    // 计算键盘弹出需要的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    if (self.isChangingKeyboard) return;
    
    [UIView animateWithDuration:duration animations:^{
        self.toolbar.transform = CGAffineTransformIdentity;
    }];
}

#pragma mark - 监听表情选中

- (void)emotionDidSelected:(NSNotification *)note
{
    GYEmotion *emotion = note.userInfo[GYSelectedEmotion];
    [self.composeView appendEmotion:emotion];
    
    // 检测文字长度
    [self textViewDidChange:self.composeView];
}

- (void)emotionDeleteButtonDidClick:(NSNotification *)note
{
    [self.composeView deleteBackward];
}

@end
