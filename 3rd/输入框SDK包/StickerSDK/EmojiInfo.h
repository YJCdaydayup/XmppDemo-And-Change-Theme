//
//  EmojiInfo.h
//  StickerSDKDemo
//
//  Created by dongmike on 13-11-22.
//  Copyright (c) 2013年 dong mike. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EmojiInfo : NSObject

@property (copy) NSString * emojiThumbName;
@property (copy) NSString * emojiValue;

+ (NSArray *)defualtEmojis;

@end
