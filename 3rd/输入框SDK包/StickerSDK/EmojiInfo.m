//
//  EmojiInfo.m
//  StickerSDKDemo
//
//  Created by dongmike on 13-11-22.
//  Copyright (c) 2013年 dong mike. All rights reserved.
//

#import "EmojiInfo.h"

@implementation EmojiInfo

@synthesize emojiThumbName;
@synthesize emojiValue;

- (void)dealloc
{
    self.emojiValue = nil;
    self.emojiThumbName = nil;
    
}

+ (NSArray *)defualtEmojis
{
    NSMutableArray * emojis = [NSMutableArray array];
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"EmojisList"
                                                          ofType:@"plist"];
    NSArray *arr = [NSArray arrayWithContentsOfFile:plistPath];
    
    for (int i = 0; i < arr.count; i++)
    {
        EmojiInfo * emoji =[[EmojiInfo alloc] init];
        emoji.emojiValue = [arr objectAtIndex:i];
        [emojis addObject:emoji];
    }
    
    return emojis;
}

@end
