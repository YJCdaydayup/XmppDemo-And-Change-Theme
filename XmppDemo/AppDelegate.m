//
//  AppDelegate.m
//  XmppDemo
//
//  Created by 杨力 on 14/6/2016.
//  Copyright © 2016 杨力. All rights reserved.
//欢迎随时咨询交流：qq：1012140802

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "MainSliderViewController.h"
#import "ZipArchive.h"

#define UmengKey @"57675eeb67e58efca1002b06"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    
    
    /********************************************/
    //设置初始button的字体颜色为黑色
    [[UIButton appearance]setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //状态条的颜色设置为白色，且需要再plist文件中添加一个key值
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    //
    [UITableView appearance].backgroundColor = [UIColor clearColor];
    [UITableViewCell appearance].backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.7];
    /********************************************/
    
    NSUserDefaults * udf = [NSUserDefaults standardUserDefaults];
    
    //判断程序是否是第一次运行，来判断解压
    if(![udf objectForKey:@"appFirst"]){
        
        //读取文件路径
        NSString * path = [[NSBundle mainBundle]pathForResource:@"com" ofType:@"zip"];
        //解压缩的路径:一定要写在Library下，自己生成的写在Documents下，程序自己使用的，写在lib下，临时文件写在temp下，但是需要注意的是：temp下是会不定期清空的，什么时候是清空，苹果不会告诉我们，有如下情况：程序当时不运行，但是2天或者1天后就崩溃了，原因就是temp下的文件没有了；
        //移动的路径
        NSString * movePath = [NSString stringWithFormat:@"%@com.zip",LIBPATH];
        //解压缩后保存的路径
        NSString * savaPath = [NSString stringWithFormat:@"%@绿色简约",LIBPATH];
        
        //读取文件
        NSData * data = [NSData dataWithContentsOfFile:path];
        //写入沙盒
        [data writeToFile:movePath atomically:YES];
        //创建解压缩工具
        ZipArchive * unZip = [[ZipArchive alloc]init];
        //设置解压缩文件路径
        [unZip UnzipOpenFile:movePath];
        //设置解压缩到哪里
        [unZip UnzipFileTo:savaPath overWrite:YES];
        //完成解压缩:需要注意的是，到这一步才算真正解压缩，把在缓存中的文件，写入成文件
        [unZip UnzipCloseFile];
        
        //记录默认的主题
        [udf setObject:@"绿色简约" forKey:THEME];
        //记录第一次启动完成，下次不在进入
        [udf setObject:@"appFirst" forKey:@"appFirst"];
        [udf synchronize];
    }
    
    //友盟反馈
    [UMFeedback setAppkey:UmengKey];
    
    
    
    
    /*
     判断用户是否登录过，登录后 直接界面主界面
     */
    if([udf objectForKey:isLogin]){
        
        MainSliderViewController * mainSlidervc = (MainSliderViewController *)[MainSliderViewController sharedSliderController];
        UINavigationController * nvc = [[UINavigationController alloc]initWithRootViewController:mainSlidervc];
        self.window.rootViewController = nvc;
        
    }else{
        LoginViewController * loginVc = [[LoginViewController alloc]init];
        self.window.rootViewController = loginVc;
    }
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
