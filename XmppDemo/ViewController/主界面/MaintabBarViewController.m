
//
//  MaintabBarViewController.m
//  XmppDemo
//
//  Created by 杨力 on 14/6/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "MaintabBarViewController.h"
#import "RecentlyViewController.h"
#import "FriendViewController.h"
#import "NewsViewController.h"

@interface MaintabBarViewController ()

@property (nonatomic,copy) NSString * path;

@end

@implementation MaintabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createViewController];
//
    [self createTabBarItem];
    
    //最后写接收主题变换通知,当主题theme发生改变，就再执行一下[self createTabBarItem]方法
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(themeChanged) name:THEME object:nil];
    
}

-(void)themeChanged{
    
    [self createTabBarItem];
}


#pragma mark - 创建tabbar的属性
-(void)createTabBarItem{
    
    //取出当前主题的名称
    NSString * theme = [[NSUserDefaults standardUserDefaults]objectForKey:THEME];
    //拼接主题图片路径
    self.path = [NSString stringWithFormat:@"%@%@/",LIBPATH,theme];
    //创建3个数组
    NSArray * titleArray = @[@"消息",@"联系人",@"动态"];
    NSArray * selectArray = @[@"tab_recent_press.png",@"tab_buddy_press.png",@"tab_qworld_press.png"];
    NSArray * unSelectArray = @[@"tab_recent_nor.png",@"tab_buddy_nor.png",@"tab_qworld_nor.png"];
    
    for(int i=0;i<titleArray.count;i++){
        
        //获取item
        UITabBarItem * item = self.tabBar.items[i];
        item = [item initWithTitle:titleArray[i] image:[self createImage:unSelectArray[i]] selectedImage:[self createImage:selectArray[i]]];
    }
    
    //设置item的字体颜色
    [[UITabBarItem appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]} forState:UIControlStateNormal];
    [[UITabBarItem appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateSelected];
    //设置tabbar的阴影线为隐藏
    UIImage * image = [[UIImage alloc]init];
    [self.tabBar setShadowImage:image];
    
    //设置背景色
    [self.tabBar setBackgroundImage:[self createImage:@"tabbar_bg.png"]];
}

//路径转化为图片的方法
-(UIImage *)createImage:(NSString *)imageName{
    
    //拼接imageName的路径
    NSString * imagePath = [NSString stringWithFormat:@"%@%@",self.path,imageName];
    //生成image
    UIImage * image = [UIImage imageWithContentsOfFile:imagePath];
    //处理阴影
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    return image;
}

#pragma mark - 创建界面
-(void)createViewController{
    
    RecentlyViewController * recentlyVc = [[RecentlyViewController alloc]init];
    //这个title成为了tabbarItem的文字
    recentlyVc.title = @"消息";
    UINavigationController * recentNvc = [[UINavigationController alloc]initWithRootViewController:recentlyVc];
    
    FriendViewController * friendVc = [[FriendViewController alloc]init];
    friendVc.title = @"联系人";
    UINavigationController * friendNcv = [[UINavigationController alloc]initWithRootViewController:friendVc];
    
    NewsViewController * newsVc = [[NewsViewController alloc]init];
    newsVc.title = @"动态";
    UINavigationController * newNVC = [[UINavigationController alloc]initWithRootViewController:newsVc];
    
    self.viewControllers =@[recentNvc,friendNcv,newNVC];
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
