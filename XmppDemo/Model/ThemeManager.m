
//
//  ThemeManager.m
//  XmppDemo
//
//  Created by 杨力 on 16/6/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "ThemeManager.h"
#import "ZipArchive.h"
static ThemeManager * theme = nil;
@implementation ThemeManager

+(instancetype)shareManager{

   static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        theme = [[ThemeManager alloc]init];
    });
    
    return theme;
}

-(instancetype)init{
    if(self = [super init]){
        
        //读取本地数据持久化的plist文件
        self.plistPath = [NSString stringWithFormat:@"%@downloadThemePlist.plist",LIBPATH];
        self.dataArray = [NSMutableArray arrayWithContentsOfFile:self.plistPath];
        if(self.dataArray == nil){
            self.dataArray = [NSMutableArray arrayWithCapacity:0];
        }
    }
    return self;
}

-(BOOL)themeDownloadData:(NSDictionary *)dict Block:(void (^)(BOOL))a{
    
    //先记录数据
    self.dict = dict;
    //记录block指针
    self.myBlock = a;
    //记录主题
    self.themeName = dict[@"name"];
    //判断是否是已经下载的主题
    if([self.dataArray containsObject:self.themeName]){
        /*****************是已经下载的主题************************/
        NSUserDefaults * udf = [NSUserDefaults standardUserDefaults];
        [udf setObject:self.themeName forKey:THEME];
        [udf synchronize];
        //发送广播
        [[NSNotificationCenter defaultCenter]postNotificationName:THEME object:nil];
        return YES;
    }else{
        /*********************没有下载过的主题************************/
        //开始下载
        HttpDownLoadBlock *request = [[HttpDownLoadBlock alloc]initWithStrUrl:self.dict[@"url"] Block:^(BOOL isOK, HttpDownLoadBlock * block) {
            
            if(isOK){
                //下载成功
                //写入文件
                NSString * savaPath = [NSString stringWithFormat:@"%@com.zip",LIBPATH];
                [block.data writeToFile:savaPath atomically:YES];
                //解压缩
                NSString * unZipPath = [NSString stringWithFormat:@"%@%@",LIBPATH,self.themeName];
                ZipArchive * unZip = [[ZipArchive alloc]init];
                [unZip UnzipOpenFile:savaPath];
                [unZip UnzipFileTo:unZipPath overWrite:YES];
                [unZip CloseZipFile2];
                //记录主题
                NSUserDefaults * udf = [NSUserDefaults standardUserDefaults];
                [udf setObject:self.themeName forKey:THEME];
                [udf synchronize];
                //同步下载列表
                [self.dataArray addObject:self.themeName];
                [self.dataArray writeToFile:self.plistPath atomically:YES];
                //发送广播
                [[NSNotificationCenter defaultCenter]postNotificationName:THEME object:nil];
                if(self.myBlock){
                    self.myBlock(YES);
                }
                
            }else{
                //下载失败
                if(self.myBlock){
                    self.myBlock(NO);
                }
            }
            
            
        }];
        
        return NO;
    }
    
    
    
}

@end
