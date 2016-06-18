//
//  StickerInfo.h
//  StickerSDKDemo
//
//  Created by mike on 13-11-6.
//  Copyright (c) 2013年 dong mike. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "StickerConst.h"

@interface StickerInfo : NSObject


+ (StickerInfo *)localStickerInPackage:(NSString *)packageID stickerID:(NSString *)stickerID name:(NSString *)name;
+ (StickerInfo *)downloadStickerInPackage:(NSString *)packageID stickerID:(NSString *)stickerID name:(NSString *)name;
+ (StickerInfo *)stickerWithID:(NSString *)stickerID;

- (NSString *)stickerID;
- (UIImage *)stickerThumb;
- (NSData *)stickerData;
- (NSString *)stickerName;
- (NSString *)packageID;


@end

