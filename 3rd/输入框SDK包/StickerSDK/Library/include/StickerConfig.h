//
//  StickerConfig.h
//  StickerSDKDemo
//
//  Created by mike on 13-11-4.
//  Copyright (c) 2013年 dong mike. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "StickerConst.h"

@class StickerInfo;
@class PackageInfo;


@interface StickerConfig : NSObject

// 注册app
+ (void)registerApp:(NSString *)strAppID withSecret:(NSString *)secret;
+ (NSString *)appID;
+ (NSString *)appSecret;

// 本地表情包，包括已下载的表情包
+ (NSArray *)localPackages;

// 在线表情包
+ (NSArray *)onlinePackages;

// 下载表情包
+ (void)downloadPackage:(PackageInfo *)package;

// 删除表情包
+ (void)deletePackage:(PackageInfo *)package;

// 表情包重新排序
+ (void)reorderPackage:(NSArray *)packages;

// 获取表情包下载进度
+ (NSNumber *)downloadProgress:(NSString *)packageID;

// 获取是否下载完毕
+ (BOOL)isDownloaded:(NSString *)packageID;

// banner栏显示的表情包
+ (PackageInfo *)bannerPackage;

+ (void)didSendSticker:(StickerInfo *)stickerInfo;

@end
