//
//  HttpDownLoadBlock.m
//  HttpRequestDemo1_1418
//
//  Created by zhangcheng on 14-8-28.
//  Copyright (c) 2014年 zhangcheng. All rights reserved.
//

#import "HttpDownLoadBlock.h"
#import "MyMD5.h"
#import "NSFileManager+Method.h"
@implementation HttpDownLoadBlock
-(id)initWithStrUrl:(NSString*)strUrl Block:(void(^)(BOOL,HttpDownLoadBlock*))a{
    if (self=[super init]) {
    //保存匿名函数指针
        self.httpDownLoad=a;
        if (strUrl==nil) {
            return self;
        }
        self.path=[NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),[MyMD5 md5:strUrl]];
        NSFileManager*manager=[NSFileManager defaultManager];
        if ([manager fileExistsAtPath:self.path]&&![manager timeOutWithPath:[MyMD5 md5:strUrl] timeOut:60*60]) {
            self.data=[NSData dataWithContentsOfFile:self.path];
            [self jsonValue];
            
        }else{
            //发起网络请求
            [self requestDownLoad:strUrl];
        }
        
        
        }
  
    return self;
}
//开始请求
-(void)requestDownLoad:(NSString*)strUrl{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    self.myConnection=[NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:strUrl]] delegate:self];
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //接收到数据，开始接收数据
    self.data=[NSMutableData dataWithCapacity:0];
    
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
//持续接收数据
    [self.data appendData:data];
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
//请求失败
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    UIAlertView*alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您的网络有问题，请检查网络" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
    if (self.httpDownLoad) {
        self.httpDownLoad(NO,self);
    }
    
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    //保存数据
    [self.data writeToFile:self.path atomically:YES];
    
    [self jsonValue];
}
-(void)jsonValue{
    id result=[NSJSONSerialization JSONObjectWithData:self.data options:NSJSONReadingMutableContainers error:nil];
    if ([result isKindOfClass:[NSArray class]]) {
        self.dataArray=result;
    }else{
        if ([result isKindOfClass:[NSDictionary class]]) {
            self.dataDic=result;
        }else{
            if (self.data) {
                self.dataImage=[UIImage imageWithData:self.data];
            }
        
        }
    
    }
    
    if (self.httpDownLoad) {
        self.httpDownLoad(YES,self);
    }
}
@end





