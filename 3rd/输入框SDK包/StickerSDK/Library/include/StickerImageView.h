//
//  SCGIFImageView.h
//  TestGIF
//
//  Created by shichangone on 11-7-12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "StickerInfo.h"


@class StickerImageView;

@protocol StickerImageViewDelegate <NSObject>

- (void)stickerImageShowed:(StickerImageView *)imageview images:(NSArray *)images;

@end


@interface StickerImageView : UIImageView
{
}

@property (retain) StickerInfo * sticker;
@property (assign) id <StickerImageViewDelegate> delegate;

@end
