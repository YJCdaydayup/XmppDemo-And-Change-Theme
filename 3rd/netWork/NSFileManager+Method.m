//
//  NSFileManager+Method.m
//  HttpRequestDemo1_1418
//
//  Created by zhangcheng on 14-8-29.
//  Copyright (c) 2014年 zhangcheng. All rights reserved.
//

#import "NSFileManager+Method.h"

@implementation NSFileManager (Method)
-(BOOL)timeOutWithPath:(NSString*)path timeOut:(NSTimeInterval)time{
//传递进来是一个经过MD5加密过的文件名称，我们需要拼接路径
    NSString*_path=[NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),path];
    //获得文件的详细信息
    NSDictionary*dic=[[NSFileManager defaultManager]attributesOfItemAtPath:_path error:nil];
    //获取文件创建的时间
   NSDate*createDate= [dic objectForKey:NSFileCreationDate];
    
    //获得当前的时间
    NSDate*date=[NSDate date];
    
    //时间进行差值比较
    NSTimeInterval isTime=[date timeIntervalSinceDate:createDate];
    
    if (isTime>time) {
        //过期
        return YES;
    }else{
    //没过期
        return NO;
    
    }

}
//清除所有缓存
-(void)cacheClear{
//我们设定清除Documents下的所有文件
    NSString*path=[NSString stringWithFormat:@"%@/Documents",NSHomeDirectory()];
//获得Documents下的所有文件名称
    NSArray*fileNameArray=[[NSFileManager defaultManager]contentsOfDirectoryAtPath:path error:nil];
    
//3种遍历的方式
    //第一种
    for (NSString*fileName in fileNameArray) {
        //删除文件
        [[NSFileManager defaultManager]removeItemAtPath:[NSString stringWithFormat:@"%@/%@",path,fileName] error:nil];
        
    }
    
//    //第二种方式 把数组转换为枚举
//    
//    NSEnumerator*enumerator=[fileNameArray objectEnumerator];
//    NSString*str;
//    while (str=[enumerator nextObject]) {
//        [[NSFileManager defaultManager]removeItemAtPath:[NSString stringWithFormat:@"%@/%@",path,str] error:nil];
//        
//        
//    }
    
    //第三种方式 iOS4.0后开始的快速枚举，优点是不阻碍当前线程，方便大数据遍历,类似开辟了另外一条线程，属于异步遍历
//    [fileNameArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        //第一个参数，遍历到对象  第二个参数第几位 第三个参数是否继续遍历
//        
//        NSString*str=obj;
//        [[NSFileManager defaultManager]removeItemAtPath:[NSString stringWithFormat:@"%@/%@",path,str] error:nil];
//    }];
    
    
    
    
    


}



@end
