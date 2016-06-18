//
//  PackageInfo.h
//  StickerSDKDemo
//
//  Created by mike on 13-11-6.
//  Copyright (c) 2013年 dong mike. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "StickerConst.h"

@interface PackageInfo : NSObject

+ (PackageInfo *)packedPackageWith:(NSDictionary *)packageInfo;
+ (PackageInfo *)downloadedPackageWith:(NSDictionary *)packageInfo;
+ (PackageInfo *)onlinePackageWith:(NSDictionary *)packageInfo;
+ (PackageInfo *)hotPackageWith:(NSDictionary *)packageInfo;

@property (readonly) PackageType packageType;
@property (readonly) NSString   *packageID;
@property (readonly) NSString   *packageName;
@property (readonly) UIImage    *packageThumb;
@property (readonly) NSString   *packageThumbURL;       // 表情缩略图URL，只对在线表情包有效
@property (readonly) NSString   *packageURL;            // 表情包URL，只对在线表情包有效
@property (readonly) NSString   *packageBannerURL;      // 表情包banner URL，只对在线表情包有效
@property (readonly) NSString   *packagePreviewURL;     // 表情包预览 URL，只对在线表情包有效
@property (readonly) NSString   *packageDescription;    // 表情包banner URL，只对在线表情包有效
@property (readonly) NSArray    *gifs;
@property (readonly) NSArray    *names;

@end

