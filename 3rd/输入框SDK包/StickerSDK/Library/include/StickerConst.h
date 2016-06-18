//
//  StickerConst.h
//  StickerSDKDemo
//
//  Created by mike on 13-11-9.
//  Copyright (c) 2013年 dong mike. All rights reserved.
//


// 定义表情包类型
typedef enum
{
    kPackedPackage,             // 自带打包表情
    kDownloadedPackage,         // 下载的表情
    kOnlinePackage,             // 在线表情
    kHotPackage,                // 热门表情
    kPackageUnknown,            // 未知表情
}PackageType;


#define kPackageID                  @"id"
#define kPackageName                @"name"
#define kPackageThumbUrl            @"thumb_url"
#define kPackageUrl                 @"zip_url"
#define kPackageJsonUrl             @"json_url"
#define kPackageBannerUrl           @"banner_url"
#define kPackageDescription         @"description"
#define kPackagePreviewURL          @"preview_url"


#define kLocalPackagesUpdated       @"kLocalPackagesUpdated"
#define kOnlinePackageUpdated       @"kOnlinePackageUpdated"
#define kDownloadProgressUpdated    @"kDownloadProgressUpdated"
#define kDownloadStatusUpdated      @"kDownloadStatusUpdated"


#define __VERSION_STICKER__     @"0.1.0"
