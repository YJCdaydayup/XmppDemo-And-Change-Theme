//
//  NSFileManager+Method.h
//  HttpRequestDemo1_1418
//
//  Created by zhangcheng on 14-8-29.
//  Copyright (c) 2014年 zhangcheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (Method)
-(BOOL)timeOutWithPath:(NSString*)path timeOut:(NSTimeInterval)time;
-(void)cacheClear;
@end










