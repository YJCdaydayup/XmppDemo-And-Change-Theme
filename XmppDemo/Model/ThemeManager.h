//
//  ThemeManager.h
//  XmppDemo
//
//  Created by 杨力 on 16/6/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpDownLoadBlock.h"
@interface ThemeManager : NSObject

//下载调用的指针
@property (nonatomic,copy) void(^myBlock)(BOOL);
//记录当前数据源
@property (nonatomic,strong) NSDictionary * dict;
//主题名称
@property (nonatomic,copy) NSString * themeName;
//已经下载过的主题
@property (nonatomic,strong) NSMutableArray * dataArray;
//plist文件数据持久化的路径
@property (nonatomic,copy) NSString * plistPath;


//单例
+(instancetype)shareManager;
//下载的调用方法,BOOL值返回是已经下载过还是没有下载过
-(BOOL)themeDownloadData:(NSDictionary *)dict Block:(void(^)(BOOL))a;

@end
