//
//  MainSliderViewController.m
//  XmppDemo
//
//  Created by 杨力 on 14/6/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "MainSliderViewController.h"
#import "MaintabBarViewController.h"
#import "SettingViewController.h"

@interface MainSliderViewController ()

@end

@implementation MainSliderViewController

- (void)viewDidLoad {
    
    [self createViewController];
    
    [super viewDidLoad];
}

-(void)createViewController{
    
    //主页
    MaintabBarViewController * mainVc = [[MaintabBarViewController alloc]init];
    self.MainVC = mainVc;
    
    //左边：SettingViewController
    SettingViewController * leftVc = [[SettingViewController alloc]init];
    self.LeftVC = leftVc;
    
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
