//
//  StickerScrollView.h
//  StickerSDKDemo
//
//  Created by mike on 13-11-11.
//  Copyright (c) 2013年 dong mike. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PackageInfo.h"


@protocol StickerScrollViewDelegate;


@interface StickerScrollView : UIView <UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (readonly) PackageInfo *package;
@property (assign) id <StickerScrollViewDelegate> delegate;

- (void)loadPackage:(PackageInfo *)package;

@end


@protocol StickerScrollViewDelegate <NSObject>

- (void)stickerScrollView:(StickerScrollView *)scrollView didSelctSticker:(int)index;

@end

