//
//  EmojiKeyBoardView.m
//  EmojiKeyBoard
//
//  Created by Ayush on 09/05/13.
//  Copyright (c) 2013 Ayush. All rights reserved.
//

#import "EmojiScrollView.h"
#import "EmojiPage.h"
#import "DDPageControl.h"
#import "EmojiInfo.h"
#import "UIConst.h"

#define BUTTON_WIDTH 45
#define BUTTON_HEIGHT 37

#define DEFAULT_SELECTED_SEGMENT 0
#define PAGE_CONTROL_INDICATOR_DIAMETER 6.0
#define RECENT_EMOJIS_MAINTAINED_COUNT 50


@interface EmojiScrollView () <UIScrollViewDelegate, EmojiPageDelegate>

@property (nonatomic, retain) DDPageControl *pageControl;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) NSMutableArray *pageViews;

@end

@implementation EmojiScrollView
@synthesize delegate = delegate_;
@synthesize pageControl = pageControl_;
@synthesize scrollView = scrollView_;
@synthesize emojis = emojis_;
@synthesize pageViews = pageViews_;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // initialize category
        self.backgroundColor = STICKER_BACKGROUND_COLOR;

        self.pageControl = [[DDPageControl alloc] initWithType:DDPageControlTypeOnFullOffFull];
        self.pageControl.onColor = [UIColor colorWithRed:0x8b/255.0 green:0x8c/255.0 blue:0x86/255.0 alpha:1.0];
        self.pageControl.offColor = [UIColor colorWithWhite:0xc2/255.0 alpha:1.0];
        self.pageControl.indicatorDiameter = PAGE_CONTROL_INDICATOR_DIAMETER;
        self.pageControl.hidesForSinglePage = YES;
        self.pageControl.currentPage = 0;
        self.pageControl.backgroundColor = [UIColor clearColor];
        CGSize pageControlSize = [self.pageControl sizeForNumberOfPages:3];
        NSUInteger numberOfPages = [self numberOfPagesInFrameSize:CGSizeMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - pageControlSize.height)];
        self.pageControl.numberOfPages = numberOfPages;
        pageControlSize = [self.pageControl sizeForNumberOfPages:numberOfPages];
        self.pageControl.frame = CGRectIntegral(CGRectMake((CGRectGetWidth(self.bounds) - pageControlSize.width) / 2,
                                                           CGRectGetHeight(self.bounds) - pageControlSize.height + 10,
                                                           pageControlSize.width,
                                                           pageControlSize.height));
        [self.pageControl addTarget:self action:@selector(pageControlTouched:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:self.pageControl];

        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                          0,
                                                                          CGRectGetWidth(self.bounds),
                                                                          CGRectGetHeight(self.bounds) - pageControlSize.height)];
        self.scrollView.pagingEnabled = YES;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.delegate = self;

        [self addSubview:self.scrollView];
    }
    return self;
}

- (void)dealloc
{
    self.pageControl = nil;
    self.scrollView = nil;
    self.emojis = nil;
    [self purgePageViews];
  
}

- (NSArray *)emojis
{
    return emojis_;
}

- (void)setEmojis:(NSArray *)arr
{
    if (emojis_ != arr)
    {
        emojis_ = arr;
    }
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    CGSize pageControlSize = [self.pageControl sizeForNumberOfPages:3];
    NSInteger numberOfPages = [self numberOfPagesInFrameSize:CGSizeMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - pageControlSize.height)];

    NSInteger currentPage = (self.pageControl.currentPage > numberOfPages) ? numberOfPages : self.pageControl.currentPage;

    // if (currentPage > numberOfPages) it is set implicitly to max pageNumber available
    self.pageControl.numberOfPages = numberOfPages;
    pageControlSize = [self.pageControl sizeForNumberOfPages:numberOfPages];
    self.pageControl.frame = CGRectIntegral(CGRectMake((CGRectGetWidth(self.bounds) - pageControlSize.width) / 2,
                                                     CGRectGetHeight(self.bounds) - pageControlSize.height + 10,
                                                     pageControlSize.width,
                                                     pageControlSize.height));

    self.scrollView.frame = CGRectMake(0, 0,
                                     CGRectGetWidth(self.bounds),
                                     CGRectGetHeight(self.bounds) - pageControlSize.height);
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.scrollView.bounds) * currentPage, 0);
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.bounds) * numberOfPages, CGRectGetHeight(self.scrollView.bounds));
    [self purgePageViews];
    self.pageViews = [NSMutableArray array];
    [self setPage:currentPage];
}

#pragma mark event handlers

- (void)pageControlTouched:(DDPageControl *)sender
{
    CGRect bounds = self.scrollView.bounds;
    bounds.origin.x = CGRectGetWidth(bounds) * sender.currentPage;
    bounds.origin.y = 0;
    [self.scrollView scrollRectToVisible:bounds animated:YES];
}

// Track the contentOffset of the scroll view, and when it passes the mid
// point of the current view’s width, the views are reconfigured.
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = CGRectGetWidth(scrollView.frame);
    NSInteger newPageNumber = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    if (self.pageControl.currentPage == newPageNumber)
    {
        return;
    }
    self.pageControl.currentPage = newPageNumber;
    [self setPage:self.pageControl.currentPage];
}

#pragma mark change a page on scrollView

// Check if setting pageView for an index is required
- (BOOL)requireToSetPageViewForIndex:(NSUInteger)index
{
    if (index >= self.pageControl.numberOfPages)
    {
        return NO;
    }
    for (EmojiPage *page in self.pageViews)
    {
        if ((page.frame.origin.x / CGRectGetWidth(self.scrollView.bounds)) == index)
        {
            return NO;
        }
    }
    return YES;
}

// Create a pageView and add it to the scroll view.
- (EmojiPage *)synthesizeEmojiPageView
{
    NSUInteger rows = [self numberOfRowsForFrameSize:self.scrollView.bounds.size];
    NSUInteger columns = [self numberOfColumnsForFrameSize:self.scrollView.bounds.size];
    EmojiPage *pageView = [[EmojiPage alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.scrollView.bounds), CGRectGetHeight(self.scrollView.bounds))
                                                       buttonSize:CGSizeMake(BUTTON_WIDTH, BUTTON_HEIGHT)
                                                             rows:rows
                                                          columns:columns] ;
    pageView.delegate = self;
    [self.pageViews addObject:pageView];
    [self.scrollView addSubview:pageView];
    return pageView;
}

// return a pageView that can be used in the current scrollView.
// look for an available pageView in current pageView-s on scrollView.
// If all are in use i.e. are of current page or neighbours
// of current page, we create a new one
- (EmojiPage *)usableEmojiPageView
{
    EmojiPage *pageView = nil;
    for (EmojiPage *page in self.pageViews)
    {
        NSUInteger pageNumber = page.frame.origin.x / CGRectGetWidth(self.scrollView.bounds);
        if (abs(pageNumber - self.pageControl.currentPage) > 1)
        {
            pageView = page;
            break;
        }
    }
    if (!pageView)
    {
        pageView = [self synthesizeEmojiPageView];
    }
    return pageView;
}

// Set emoji page view for given index.
- (void)setEmojiPageViewInScrollView:(UIScrollView *)scrollView atIndex:(NSUInteger)index
{
    if (self.emojis == nil)
        return;
    
  if (![self requireToSetPageViewForIndex:index])
  {
    return;
  }

  EmojiPage *pageView = [self usableEmojiPageView];

  NSUInteger rows = [self numberOfRowsForFrameSize:scrollView.bounds.size];
  NSUInteger columns = [self numberOfColumnsForFrameSize:scrollView.bounds.size];
  NSUInteger startingIndex = index * (rows * columns - 1);
  NSUInteger endingIndex = (index + 1) * (rows * columns - 1);
  NSMutableArray *buttonEmojis = [self emojisFromIndex:startingIndex
                                               toIndex:endingIndex];
  [pageView setButtonEmojis:buttonEmojis];
  pageView.frame = CGRectMake(index * CGRectGetWidth(scrollView.bounds), 10, CGRectGetWidth(scrollView.bounds), CGRectGetHeight(scrollView.bounds));
}

// Set the current page.
// sets neightbouring pages too, as they are viewable by part scrolling.
- (void)setPage:(NSInteger)page
{
    [self setEmojiPageViewInScrollView:self.scrollView atIndex:page - 1];
    [self setEmojiPageViewInScrollView:self.scrollView atIndex:page];
    [self setEmojiPageViewInScrollView:self.scrollView atIndex:page + 1];
}

- (void)purgePageViews
{
    for (EmojiPage *page in self.pageViews)
    {
        page.delegate = nil;
    }
    self.pageViews = nil;
}

#pragma mark data methods

- (NSUInteger)numberOfColumnsForFrameSize:(CGSize)frameSize
{
    return (NSUInteger)floor(frameSize.width / BUTTON_WIDTH);
}

- (NSUInteger)numberOfRowsForFrameSize:(CGSize)frameSize
{
    return (NSUInteger)floor(frameSize.height / BUTTON_HEIGHT);
}

// for a given frame size of scroll view, return the number of pages
// required to show all the emojis for a category
- (NSUInteger)numberOfPagesInFrameSize:(CGSize)frameSize
{
  NSUInteger emojiCount = self.emojis.count;
  NSUInteger numberOfRows = [self numberOfRowsForFrameSize:frameSize];
  NSUInteger numberOfColumns = [self numberOfColumnsForFrameSize:frameSize];
  NSUInteger numberOfEmojisOnAPage = (numberOfRows * numberOfColumns) - 1;

  NSUInteger numberOfPages = (NSUInteger)ceil((float)emojiCount / numberOfEmojisOnAPage);
  return numberOfPages;
}

// return the emojis for a category, given a staring and an ending index
- (NSMutableArray *)emojisFromIndex:(NSUInteger)start toIndex:(NSUInteger)end
{
    end = ([self.emojis count] > end)? end : [self.emojis count];
    NSIndexSet *index = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(start, end-start)] ;
    return [[self.emojis objectsAtIndexes:index] mutableCopy];
}


#pragma mark EmojiPageViewDelegate
// add the emoji to recents
- (void)emojiPageView:(EmojiPage *)emojiPageView didUseEmoji:(NSString *)emoji
{
    [self.delegate emojiKeyBoardView:self didUseEmoji:emoji];
}

- (void)emojiPageViewDidPressBackSpace:(EmojiPage *)emojiPageView
{
    [self.delegate emojiKeyBoardViewDidPressBackSpace:self];
}

@end
