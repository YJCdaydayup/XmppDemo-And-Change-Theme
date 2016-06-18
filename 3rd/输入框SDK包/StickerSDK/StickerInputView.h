//
//  StickerInputView.h
//  StickerSDKDemo
//
//  Created by mike on 13-11-4.
//  Copyright (c) 2013年 dong mike. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EmojiScrollView.h"
#import "StickerScrollView.h"

@class StickerInfo;

@protocol StickerInputViewDelegate;

@interface StickerInputView : UIView <EmojiScrollViewDelegate, StickerScrollViewDelegate>

@property (assign) id <StickerInputViewDelegate> delegate;

- (id)initWithEmoji:(NSArray *)emoji;

- (void)showInView:(UIView *)view emojiReceiver:(id<UIKeyInput>)emojiReceiver viewController:(UIViewController *)controller animated:(BOOL)animated;
- (void)dismiss;

@end


@protocol StickerInputViewDelegate <NSObject>

@required
- (void)stickerInputView:(StickerInputView *)inputView didSelectSticker:(StickerInfo *)stickerInfo;

@end
