//
//  StickerInputView.m
//  StickerSDKDemo
//
//  Created by mike on 13-11-4.
//  Copyright (c) 2013年 dong mike. All rights reserved.
//

#import "StickerInputView.h"

#import "StickerConfig.h"
#import "PackageInfo.h"
#import "EmojiInfo.h"
#import "DDPageControl.h"
#import "CRNavigationController.h"
#import "MoreStickerViewController.h"


#define HEIGHT_INPUTVIEW     216
#define HEIGHT_TABVIEW       36
#define HEIGHT_CONTENTVIEW   (HEIGHT_INPUTVIEW - HEIGHT_TABVIEW)

#define WIDTH_TAB            51


@interface StickerInputView ()

@property (retain) UIScrollView * tabScrollView;            // tab选择栏
@property (retain) NSMutableArray * tabButtons;
@property (retain) UIView * tabSeprator;

@property (retain) EmojiScrollView * emojiKeyboard;       // emoji键盘
@property (retain) id <UIKeyInput> emojiReceiver;

@property (retain) StickerScrollView * stickerScrollView;

@property (retain) NSArray * localPackages;
@property (assign) UIViewController * viewController;

@end


@implementation StickerInputView

@synthesize delegate;

@synthesize tabScrollView;
@synthesize tabButtons = _tabButtons;
@synthesize tabSeprator;

@synthesize emojiKeyboard;
@synthesize emojiReceiver;

@synthesize stickerScrollView;

@synthesize viewController;
@synthesize localPackages;
//320
#define WIDTH1 [UIScreen mainScreen].bounds.size.width
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        NSLog(@"%f",WIDTH1);
        
        self.localPackages = [StickerConfig localPackages];
        
        self.tabScrollView = [[UIScrollView alloc] init];
        self.tabScrollView.frame = CGRectMake(0, HEIGHT_CONTENTVIEW, WIDTH1, HEIGHT_TABVIEW);
        self.tabScrollView.backgroundColor = [UIColor colorWithWhite:219/255.0 alpha:1.0];
        self.tabScrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:self.tabScrollView];
        
        self.tabSeprator = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT_CONTENTVIEW, WIDTH1, 2)];
        [self addSubview:self.tabSeprator];
        self.tabSeprator.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sticker_tab_seprator.png"]];
        
        self.emojiKeyboard = [[EmojiScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH1, HEIGHT_CONTENTVIEW)] ;
        self.emojiKeyboard.delegate = self;
        self.emojiKeyboard.emojis = [EmojiInfo defualtEmojis];
        [self addSubview:self.emojiKeyboard];
        
        self.stickerScrollView = [[StickerScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH1, HEIGHT_CONTENTVIEW)];
        self.stickerScrollView.delegate = self;
        [self addSubview:self.stickerScrollView];
        
        [self loadTabButtons];
        
        [self loadEmoji];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLocalPackagesUpdated:) name:kLocalPackagesUpdated object:nil];
    }
    return self;
}

- (id)initWithEmoji:(NSArray *)emoji
{
    self = [self initWithFrame:CGRectZero];
    if (self != nil)
    {
        if (emoji)
        {
            self.emojiKeyboard.emojis = emoji;
        }
        else
        {
            self.emojiKeyboard.emojis = [EmojiInfo defualtEmojis];
        }
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.tabScrollView = nil;
    self.tabButtons = nil;
    self.tabSeprator = nil;
    
    self.stickerScrollView = nil;
    
    self.emojiKeyboard = nil;
    self.emojiReceiver = nil;
    
    self.localPackages = nil;
    self.viewController = nil;
    self.delegate = nil;
    
}

- (void)loadTabButtons
{
    for (int i = 0; i < self.tabButtons.count; i++)
    {
        UIButton * button = [self.tabButtons objectAtIndex:i];
        [button removeFromSuperview];
    }
    
    self.tabButtons = [NSMutableArray array];
    
    UIButton * emojiButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [emojiButton setImage:[UIImage imageNamed:@"sticker_tab_emoji.png"] forState:UIControlStateNormal];
    [[emojiButton imageView] setContentMode:UIViewContentModeScaleAspectFit];
    emojiButton.frame = CGRectMake(0, 0, WIDTH_TAB, HEIGHT_TABVIEW);
    [emojiButton setBackgroundImage:[UIImage imageNamed:@"sticker_tab_normal.png"] forState:UIControlStateNormal];
    [emojiButton setBackgroundImage:[UIImage imageNamed:@"sticker_tab_selected.png"] forState:UIControlStateSelected];
    [emojiButton addTarget:self action:@selector(onClickEmoji:) forControlEvents:UIControlEventTouchUpInside];
    [self.tabScrollView addSubview:emojiButton];
    [self.tabButtons addObject:emojiButton];
    
    for (int i = 0; i < self.localPackages.count; i++)
    {
        PackageInfo * package = [self.localPackages objectAtIndex:i];
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [[button imageView] setContentMode:UIViewContentModeScaleAspectFit];
        [button setImageEdgeInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
        button.frame = CGRectMake((i + 1) * WIDTH_TAB, 0, WIDTH_TAB, HEIGHT_TABVIEW);
        button.tag = i + 1;
        [button setBackgroundImage:[UIImage imageNamed:@"sticker_tab_normal.png"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"sticker_tab_selected.png"] forState:UIControlStateSelected];
        [button setImage:package.packageThumb forState:UIControlStateNormal];
        [self.tabScrollView addSubview:button];
        [button addTarget:self action:@selector(onClickTab:) forControlEvents:UIControlEventTouchUpInside];
        [self.tabButtons addObject:button];
    }
    
    UIButton * moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreButton setImage:[UIImage imageNamed:@"sticker_tab_more.png"] forState:UIControlStateNormal];
    [[moreButton imageView] setContentMode:UIViewContentModeScaleAspectFit];
    moreButton.frame = CGRectMake((self.localPackages.count + 1) * WIDTH_TAB, 0, WIDTH_TAB, HEIGHT_TABVIEW);
    [moreButton addTarget:self action:@selector(onClickMore:) forControlEvents:UIControlEventTouchUpInside];
    [self.tabScrollView addSubview:moreButton];
    [self.tabButtons addObject:moreButton];
    
    self.tabScrollView.contentSize = CGSizeMake(MAX((self.localPackages.count + 2) * WIDTH_TAB, self.tabScrollView.bounds.size.width + 1), 0);
}

- (void)onClickEmoji:(id)sender
{
    [self loadEmoji];
}

- (void)loadEmoji
{
    self.stickerScrollView.hidden = YES;
    self.emojiKeyboard.hidden = NO;
    
    [self setButtonSelected:0];
}

- (void)onClickTab:(id)sender
{
    UIButton * button = sender;
    int index = button.tag - 1;
    if (index >= 0 && index < self.localPackages.count)
    {
        [self loadPackage:[self.localPackages objectAtIndex:index]];
    }
    
    [self setButtonSelected:button.tag];
}

- (void)loadPackage:(PackageInfo *)package
{
    self.emojiKeyboard.hidden = YES;
    self.stickerScrollView.hidden = NO;
    
    [self.stickerScrollView loadPackage:package];
}

- (void)setButtonSelected:(int)index
{
    for (int i = 0; i < _tabButtons.count; i++)
    {
        UIButton * button = [_tabButtons objectAtIndex:i];
        [button setSelected:(i == index)];
        if (i == index)
        {
            [self.tabScrollView bringSubviewToFront:button];
        }
    }
}

- (void)onClickMore:(id)sender
{
    MoreStickerViewController * controller = [[MoreStickerViewController alloc] initWithNibName:@"MoreStickerViewController" bundle:nil];
    CRNavigationController * navController = [[CRNavigationController alloc] initWithRootViewController:controller] ;

    [self.viewController presentViewController:navController animated:YES completion:nil];
}

- (void)showInView:(UIView *)view emojiReceiver:(id<UIKeyInput>)receiver viewController:(UIViewController *)controller animated:(BOOL)animated
{
    self.emojiReceiver = nil;
    
    if(!view)
    {
        UIWindow* keyWindow = [UIApplication sharedApplication].keyWindow;
        if ([keyWindow respondsToSelector:@selector(rootViewController)])
        {
            view = keyWindow.rootViewController.view;
        }
        if (view == nil)
        {
            view = keyWindow;
        }
    }
    
    if (view != nil)
    {
        self.viewController = controller;
        self.emojiReceiver = receiver;
        
        [view addSubview:self];
        
        CGPoint origin = [view convertPoint:CGPointMake(0, [UIScreen mainScreen].bounds.size.height - HEIGHT_INPUTVIEW) fromView:nil];
        if (animated)
        {
            self.frame = CGRectMake(origin.x, origin.y+HEIGHT_INPUTVIEW, WIDTH1, HEIGHT_INPUTVIEW);
            [UIView animateWithDuration:0.3 animations:^
             {
                 self.frame = CGRectMake(origin.x, origin.y, WIDTH1, HEIGHT_INPUTVIEW);
             }];
        }
        else
        {
            self.frame = CGRectMake(origin.x, origin.y, WIDTH1, HEIGHT_INPUTVIEW);
        }
    }
    else
    {
        NSLog(@"warning!!! stickerinputview's parent view is null!");
    }
}

- (void)dismiss
{
    [self removeFromSuperview];
}

- (void)onLocalPackagesUpdated:(NSNotification *)noti
{
    self.localPackages = [StickerConfig localPackages];
    [self loadTabButtons];
}


#pragma mark - emoji keyboard delegate

- (void)emojiKeyBoardView:(EmojiScrollView *)emojiKeyBoardView didUseEmoji:(NSString *)emoji
{
    if (self.emojiReceiver != nil)
    {
        [self.emojiReceiver insertText:emoji];
    }
}

- (void)emojiKeyBoardViewDidPressBackSpace:(EmojiScrollView *)emojiKeyBoardView
{
    BOOL needMatchEmoji = NO;
    NSString * strPrefix = nil;
    NSString * strSuffix = nil;
    if (self.emojiKeyboard.emojis.count > 0)
    {
        EmojiInfo * emojiInfo = [self.emojiKeyboard.emojis objectAtIndex:0];
        if (emojiInfo.emojiThumbName != nil
            && emojiInfo.emojiValue.length >= 3
            && [self.emojiReceiver isKindOfClass:[UITextView class]])
        {
            needMatchEmoji = YES;
            strPrefix = [emojiInfo.emojiValue substringWithRange:NSMakeRange(0, 1)];
            strSuffix = [emojiInfo.emojiValue substringWithRange:NSMakeRange(emojiInfo.emojiValue.length - 1, 1)];
        }
    }
    
    if (needMatchEmoji)
    {
        UITextView * textview = (UITextView *)self.emojiReceiver;
        NSRange range = [textview selectedRange];
        NSString * strText = textview.text;
        int start = range.location;
        if (start > 0 && start <= strText.length)
        {
            start--;
            NSString * str = [strText substringWithRange:NSMakeRange(start, 1)];
            if ([str isEqualToString:strSuffix])
            {
                BOOL foundEmojo = NO;
                int minStart = start - 5;
                for (start--; start >= 0 && start >= minStart; start--)
                {
                    if ([[strText substringWithRange:NSMakeRange(start, 1)] isEqualToString:strPrefix])
                    {
                        foundEmojo = YES;
                        break;
                    }
                }
                
                if (foundEmojo)
                {
                    int len = range.location - start;
                    if (self.emojiReceiver != nil)
                    {
                        while (len > 0)
                        {
                            [self.emojiReceiver deleteBackward];
                            len--;
                        }
                    }
                }
                else
                {
                    if (self.emojiReceiver != nil)
                    {
                        [self.emojiReceiver deleteBackward];
                    }
                }
            }
            else
            {
                if (self.emojiReceiver != nil)
                {
                    [self.emojiReceiver deleteBackward];
                }
            }
        }
        else
        {
            if (self.emojiReceiver != nil)
            {
                [self.emojiReceiver deleteBackward];
            }
        }
    }
    else
    {
        if (self.emojiReceiver != nil)
        {
            [self.emojiReceiver deleteBackward];
        }
    }
}

- (void)stickerScrollView:(StickerScrollView *)scrollView didSelctSticker:(int)index
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(stickerInputView:didSelectSticker:)])
    {
        StickerInfo * sticker = [scrollView.package.gifs objectAtIndex:index];
        [self.delegate stickerInputView:self didSelectSticker:sticker];
        [StickerConfig didSendSticker:sticker];
    }
}

@end
