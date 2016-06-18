//
//  StickerImage.h
//  StickerSDK
//
//  Created by dongmike on 13-12-30.
//  Copyright (c) 2013年 dong mike. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface StickerImage : UIImage

@property (nonatomic, readonly) NSTimeInterval *frameDurations;
@property (nonatomic, readonly) NSTimeInterval totalDuration;
@property (nonatomic, readonly) NSUInteger loopCount;

@property (nonatomic, readonly, getter = isPartial) BOOL partial;

@end