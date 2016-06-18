//
//  EmojiPageView.m
//  EmojiKeyBoard
//
//  Created by Ayush on 09/05/13.
//  Copyright (c) 2013 Ayush. All rights reserved.
//

#import "EmojiPage.h"


#import "EmojiInfo.h"


#define BACKSPACE_BUTTON_TAG 10
#define BUTTON_FONT_SIZE 32

@interface EmojiPage ()

@property (nonatomic, assign) CGSize buttonSize;
@property (nonatomic, retain) NSMutableArray *buttons;
@property (nonatomic, assign) NSUInteger columns;
@property (nonatomic, assign) NSUInteger rows;
@property (nonatomic, retain) NSArray * emojis;

@end

@implementation EmojiPage
@synthesize buttonSize = buttonSize_;
@synthesize buttons = buttons_;
@synthesize columns = columns_;
@synthesize rows = rows_;
@synthesize emojis;
@synthesize delegate = delegate_;

- (void)setButtonEmojis:(NSMutableArray *)emojis2
{
    self.emojis = emojis2;
  if (([self.buttons count] - 1) == [self.emojis count])
  {
      // just reset text on each button
      for (NSUInteger i = 0; i < [emojis count]; ++i)
      {
          EmojiInfo * info = [self.emojis objectAtIndex:i];
          if (info.emojiThumbName)
          {
              [self.buttons[i] setImage:[UIImage imageNamed:info.emojiThumbName] forState:UIControlStateNormal];
          }
          else
          {
              [self.buttons[i] setTitle:info.emojiValue forState:UIControlStateNormal];
          }
      }
  }
  else
  {
      [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
      self.buttons = nil;
      self.buttons = [NSMutableArray arrayWithCapacity:self.rows * self.columns];
      for (NSUInteger i = 0; i < [self.emojis count]; ++i)
      {
          UIButton *button = [self createButtonAtIndex:i];
//          [self.buttons addObject:button];
          self.buttons[i] = button;
          
          EmojiInfo * info = [self.emojis objectAtIndex:i];
          if (info.emojiThumbName)
          {
              [self.buttons[i] setImage:[UIImage imageNamed:info.emojiThumbName] forState:UIControlStateNormal];
              [self.buttons[i] setTitle:nil forState:UIControlStateNormal];
          }
          else
          {
              [self.buttons[i] setTitle:info.emojiValue forState:UIControlStateNormal];
              [self.buttons[i] setImage:nil forState:UIControlStateNormal];
          }
          [self addToViewButton:button];
      }
      UIButton *button = [self createButtonAtIndex:self.rows * self.columns - 1];
      [button setImage:[UIImage imageNamed:@"backspace_n.png"] forState:UIControlStateNormal];
      button.tag = BACKSPACE_BUTTON_TAG;
      [self addToViewButton:button];
  }
}

- (void)addToViewButton:(UIButton *)button
{
    NSAssert(button != nil, @"Button to be added is nil");

    [self.buttons addObject:button];
    [self addSubview:button];
}

// Padding is the expected space between two buttons.
// Thus, space of top button = padding / 2
// extra padding according to particular button's pos = pos * padding
// Margin includes, size of buttons in between = pos * buttonSize
// Thus, margin = padding / 2
//                + pos * padding
//                + pos * buttonSize

- (CGFloat)XMarginForButtonInColumn:(NSInteger)column
{
    CGFloat padding = ((CGRectGetWidth(self.bounds) - self.columns * self.buttonSize.width) / self.columns);
    return (padding / 2 + column * (padding + self.buttonSize.width));
}

- (CGFloat)YMarginForButtonInRow:(NSInteger)rowNumber
{
    CGFloat padding = ((CGRectGetHeight(self.bounds) - self.rows * self.buttonSize.height) / self.rows);
    return (padding / 2 + rowNumber * (padding + self.buttonSize.height));
}

- (UIButton *)createButtonAtIndex:(NSUInteger)index
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont fontWithName:@"Apple color emoji" size:BUTTON_FONT_SIZE];
    NSInteger row = (NSInteger)(index / self.columns);
    NSInteger column = (NSInteger)(index % self.columns);
    button.frame = CGRectIntegral(CGRectMake([self XMarginForButtonInColumn:column],
                                           [self YMarginForButtonInRow:row],
                                           self.buttonSize.width,
                                           self.buttonSize.height));
    button.tag = 100 + index;
    
//    NSLog(@"button %d: %.2f %.2f %.2f %.2f", index, button.frame.origin.x, button.frame.origin.y,
//          button.frame.size.width, button.frame.size.height);
    
    [button addTarget:self action:@selector(emojiButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (id)initWithFrame:(CGRect)frame buttonSize:(CGSize)buttonSize rows:(NSUInteger)rows columns:(NSUInteger)columns
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.buttonSize = buttonSize;
        self.columns = columns;
        self.rows = rows;
        self.buttons = [[NSMutableArray alloc] initWithCapacity:rows * columns] ;
    }
    return self;
}

- (void)emojiButtonPressed:(UIButton *)button
{
    if (button.tag == BACKSPACE_BUTTON_TAG)
    {
        [self.delegate emojiPageViewDidPressBackSpace:self];
        return;
    }
    
    int tag = button.tag - 100;
    if (tag >= 0 && tag < self.emojis.count)
    {
        EmojiInfo * info = [self.emojis objectAtIndex:tag];
        [self.delegate emojiPageView:self didUseEmoji:info.emojiValue];
    }
}

- (void)dealloc
{
    self.buttons = nil;
    self.emojis = nil;
}

@end
