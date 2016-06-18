//
//  RootViewController.m
//  XmppDemo
//
//  Created by 杨力 on 14/6/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "RootViewController.h"


@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createTheme];
    
    //接收通知，变更主题
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(themeChanged) name:THEME object:nil];
}

-(void)themeChanged{
    
    [self createTheme];
}

//到这里，主题更换就接近做完了
#pragma mark - 设置主题
-(void)createTheme{
    
    //读取当前主题
    NSString * theme = [[NSUserDefaults standardUserDefaults]objectForKey:THEME];
    //拼接路径
    self.path = [NSString stringWithFormat:@"%@%@/",LIBPATH,theme];
    //设置导航条的背景色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@header_bg.png",self.path]] forBarMetrics:UIBarMetricsDefault];
    //设置self.view的背景色
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@chat_bg_default.jpg",self.path] ]];
    
    //当子类也想接收主题变化通知，但不想重新这个方法,那么额外建立一个方法，并且为了方便字累重写该方法，需要再.h文件中声明，如果子类想接收主题变化的通知，就重写这个方法即可：如左右导航按钮的主题变化
    [self createNotificationTheme];
    
}

-(void)createNotificationTheme{
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
