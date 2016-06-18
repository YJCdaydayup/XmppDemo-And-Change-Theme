//
//  StickerScrollView.m
//  StickerSDKDemo
//
//  Created by mike on 13-11-11.
//  Copyright (c) 2013年 dong mike. All rights reserved.
//

#import "StickerScrollView.h"
#import "DDPageControl.h"
#import "StickerInfo.h"
#import "StickerImageView.h"
#import "UIConst.h"

#define PAGE_CONTROL_INDICATOR_DIAMETER 6.0

#define STICKERS_COLUMN                 (int)([UIScreen mainScreen].bounds.size.width/70)
#define STICKERS_ROW                    2
#define STICKERS_LEFT_BORDER            7
#define STICKERS_TOP_BORDER             5
#define STICKERS_VERTICAL_GAP           10
#define STICKERS_HORIZONTAL_GAP         14
#define STICKERS_THUMB_WIDTH            65
#define STICKERS_THUMB_HEIGHT           72


@interface StickerScrollView ()

@property (retain) UIScrollView * scrollView;
@property (retain) DDPageControl * pageControl;
@property (readonly) UIImageView * floatingView;
@property (readonly) StickerImageView * floatingSticker;
@property (retain) NSMutableArray * thumbButtons;

@end

@implementation StickerScrollView

@synthesize scrollView;
@synthesize pageControl;
@synthesize thumbButtons;
@synthesize floatingView = _floatingView;
@synthesize floatingSticker = _floatingSticker;

@synthesize package = _package;

@synthesize delegate;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        
        self.backgroundColor = STICKER_BACKGROUND_COLOR;
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds] ;
        self.scrollView.pagingEnabled = YES;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.delegate = self;
        [self addSubview:self.scrollView];
        
        self.thumbButtons = [NSMutableArray array];
        
        self.pageControl = [[DDPageControl alloc] initWithType:DDPageControlTypeOnFullOffFull];
        self.pageControl.onColor = [UIColor colorWithRed:0x8b/255.0 green:0x8c/255.0 blue:0x86/255.0 alpha:1.0];
        self.pageControl.offColor = [UIColor colorWithWhite:0xc2/255.0 alpha:1.0];
        self.pageControl.indicatorDiameter = PAGE_CONTROL_INDICATOR_DIAMETER;
        self.pageControl.hidesForSinglePage = YES;
        self.pageControl.currentPage = 0;
        self.pageControl.backgroundColor = [UIColor clearColor];
        self.pageControl.frame = CGRectMake(0, frame.size.height - 20, frame.size.width, 20);
        [self.pageControl addTarget:self action:@selector(pageControlTouched:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:self.pageControl];
        
        UILongPressGestureRecognizer * recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress:)] ;
        [self addGestureRecognizer:recognizer];
    }
    return self;
}

- (void)pageControlTouched:(DDPageControl *)sender
{
    CGRect bounds = self.scrollView.bounds;
    bounds.origin.x = CGRectGetWidth(bounds) * sender.currentPage;
    bounds.origin.y = 0;
    [self.scrollView scrollRectToVisible:bounds animated:YES];
}

- (void)dealloc
{
    self.scrollView = nil;
    self.pageControl = nil;
    self.thumbButtons = nil;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.scrollView.frame = self.bounds;
    
    CGSize pageControlSize = [self.pageControl sizeForNumberOfPages:(self.thumbButtons.count + (STICKERS_ROW * STICKERS_COLUMN) - 1)/(STICKERS_ROW * STICKERS_COLUMN)];
    self.pageControl.frame = CGRectIntegral(CGRectMake((CGRectGetWidth(self.bounds) - pageControlSize.width) / 2,
                                                       CGRectGetHeight(self.bounds) - pageControlSize.height + 10,
                                                       pageControlSize.width,
                                                       pageControlSize.height));
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = CGRectGetWidth(self.scrollView.frame);
    NSInteger newPageNumber = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    if (self.pageControl.currentPage == newPageNumber)
    {
        return;
    }
    self.pageControl.currentPage = newPageNumber;
}

- (void)loadPackage:(PackageInfo *)p
{
    if (_package != p)
    {
        if (_package != nil)
        {
           
            _package = nil;
        }
        
        _package = p;
        
        for (int i = 0; i < self.thumbButtons.count; i++)
        {
            UIView * button = [self.thumbButtons objectAtIndex:i];
            [button removeFromSuperview];
        }
        
        [self.thumbButtons removeAllObjects];
        
        self.scrollView.contentOffset = CGPointZero;
        
        NSArray * stickers = [p gifs];
        for (int i = 0; i < stickers.count; i++)
        {
            int page = i / (STICKERS_COLUMN * STICKERS_ROW);
            int row = (i % (STICKERS_COLUMN * STICKERS_ROW)) / (STICKERS_COLUMN);
            int column = (i % (STICKERS_COLUMN * STICKERS_ROW)) % STICKERS_COLUMN;
            
            NSLog(@"%d~~%d~~%d",page,row,column);
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(page * self.scrollView.bounds.size.width + STICKERS_LEFT_BORDER + column * (STICKERS_HORIZONTAL_GAP + STICKERS_THUMB_WIDTH), STICKERS_TOP_BORDER + row * (STICKERS_VERTICAL_GAP + STICKERS_THUMB_HEIGHT), STICKERS_THUMB_WIDTH, STICKERS_THUMB_HEIGHT);
            [button addTarget:self action:@selector(onClickThumb:) forControlEvents:UIControlEventTouchUpInside];
            [self.scrollView addSubview:button];
            button.tag = i;
            button.backgroundColor = [UIColor clearColor];
            
            StickerInfo * sticker = [stickers objectAtIndex:i];
            UIImage * stickerThumb = [sticker stickerThumb];
            NSString * stickerName = [sticker stickerName];
            [button setImage:stickerThumb forState:UIControlStateNormal];
            [[button imageView] setContentMode:UIViewContentModeScaleAspectFill];
            if (stickerName)
            {
                [button setTitle:stickerName forState:UIControlStateNormal];
                [button setTitleColor:[UIColor colorWithWhite:0x63/255.0 alpha:1.0] forState:UIControlStateNormal];
                [[button titleLabel] setFont:[UIFont systemFontOfSize:11]];
                [button setTitleEdgeInsets:UIEdgeInsetsMake(65, -stickerThumb.size.width, 0, 0)];
                [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 12, 0)];
            }
            
            [self.thumbButtons addObject:button];
        }
        
        int page = (stickers.count + STICKERS_COLUMN* STICKERS_ROW - 1) / (STICKERS_COLUMN * STICKERS_ROW);
        
        self.scrollView.contentSize = CGSizeMake(page * self.scrollView.bounds.size.width, 0);
        
        self.pageControl.numberOfPages = page;
        
        CGSize pageControlSize = [self.pageControl sizeForNumberOfPages:(self.thumbButtons.count + (STICKERS_ROW * STICKERS_COLUMN) - 1)/(STICKERS_ROW * STICKERS_COLUMN)];
        self.pageControl.frame = CGRectIntegral(CGRectMake((CGRectGetWidth(self.bounds) - pageControlSize.width) / 2,
                                                           CGRectGetHeight(self.bounds) - pageControlSize.height + 10,
                                                           pageControlSize.width,
                                                           pageControlSize.height));
    }
}

- (void) onClickThumb:(id)sender
{
    UIButton * button = sender;
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(stickerScrollView:didSelctSticker:)])
    {
        [self.delegate stickerScrollView:self didSelctSticker:button.tag];
    }
}


#pragma mark - long press manage

- (void)onLongPress:(UILongPressGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        CGPoint pt = [recognizer locationInView:self.scrollView];
        int thumbIndex = [self thumbIndexWithPoint:pt];
        if (thumbIndex >= 0 && thumbIndex < self.package.gifs.count)
        {
            StickerInfo * sticker = [self.package.gifs objectAtIndex:thumbIndex];
            if (sticker != self.floatingSticker.sticker)
            {
                [self.floatingSticker setSticker:sticker];
            }
            
            UIButton * btn = [self.thumbButtons objectAtIndex:thumbIndex];
            CGRect rect = self.floatingView.frame;
            rect.origin = CGPointMake(btn.frame.origin.x - (rect.size.width - STICKERS_THUMB_WIDTH)/2, btn.frame.origin.y - rect.size.height);
            self.floatingView.frame = rect;
            self.floatingView.hidden = NO;
            
            self.scrollView.clipsToBounds = NO;
            self.clipsToBounds = NO;
            self.scrollView.scrollEnabled = NO;
            [self.scrollView bringSubviewToFront:self.floatingView];
        }
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged)
    {
        if (!self.floatingSticker.hidden)
        {
            CGPoint pt = [recognizer locationInView:self.scrollView];
            int thumbIndex = [self thumbIndexWithPoint:pt];
            if (thumbIndex >= 0 && thumbIndex < self.package.gifs.count)
            {
                StickerInfo * sticker = [self.package.gifs objectAtIndex:thumbIndex];
                if (sticker != self.floatingSticker.sticker)
                {
                    [self.floatingSticker setSticker:sticker];
                    
                    UIButton * btn = [self.thumbButtons objectAtIndex:thumbIndex];
                    CGRect rect = self.floatingView.frame;
                    rect.origin = CGPointMake(btn.frame.origin.x - (rect.size.width - STICKERS_THUMB_WIDTH)/2, btn.frame.origin.y - rect.size.height);
                    
                    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut animations:^
                     {
                         self.floatingView.frame = rect;
                     }completion:nil];
                }
            }
        }
    }
    else
    {
        self.floatingView.hidden = YES;
        self.scrollView.scrollEnabled = YES;
    }
}

- (int)thumbIndexWithPoint:(CGPoint)pt
{
    for (int i = 0; i < self.thumbButtons.count; i++)
    {
        UIView * v = [self.thumbButtons objectAtIndex:i];
        if (CGRectContainsPoint(v.frame, pt))
        {
            return i;
        }
    }
    return -1;
}


- (UIImageView *)floatingView
{
    if (_floatingView == nil)
    {
        _floatingView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 66 * 1.5, 71*1.5)];
        _floatingView.image = [UIImage imageNamed:@"sticker_floating_bg.png"];
        [self.scrollView addSubview:_floatingView];
    }
    return _floatingView;
}

- (StickerImageView *)floatingSticker
{
    if (_floatingSticker == nil)
    {
        _floatingSticker = [[StickerImageView alloc] initWithFrame:CGRectMake(5, 5, self.floatingView.bounds.size.width - 10, self.floatingView.bounds.size.width - 10)];
        [self.floatingView addSubview:_floatingSticker];
    }
    return _floatingSticker;
}

@end
