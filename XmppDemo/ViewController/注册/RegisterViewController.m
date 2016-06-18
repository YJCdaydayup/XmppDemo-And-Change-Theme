//
//  RegisterViewController.m
//  XmppDemo
//
//  Created by 杨力 on 14/6/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegisterViewController2.h"

@interface RegisterViewController (){
    
    //展现帐号的Label
    UILabel * userNameLabel;
    //备注
    UILabel * infoLabel;
    //输入框
    UITextField * nickNameTextfield;
    UITextField * passWordTextfield;
    
    //注册协议一定要有，免责声明
    UILabel * dutylabel;
    UIButton * dutyButton;
    
    //重试按钮
    UIButton * tryButton;
}

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"logo_bg_2@2x.png"]];
    
    //设置左右导航
    [self createNav];
    
    //设置界面
    [self configUI];
}

#pragma mark - 设置界面
-(void)configUI{
    
    userNameLabel=[ZCControl createLabelWithFrame:CGRectMake(50, 64, WIDTH-150, 40) Font:15 Text:[NSString stringWithFormat:@"您的数字账号为：%ld",DTAETIME]];
    [self.view addSubview:userNameLabel];
    infoLabel=[ZCControl createLabelWithFrame:CGRectMake(50, 100, WIDTH-50, 10) Font:5 Text:@"苍老师为您创建数字账号，不满意请点击重试来为您创建一个新的数字账号"];
    //设置文字的颜色
    infoLabel.textColor=[UIColor grayColor];
    [self.view addSubview:infoLabel];
    
    //创建输入框
    UIImageView*tempImageView=[ZCControl createImageViewWithFrame:CGRectMake(0, 0, 60, 40) ImageName:nil];
    UIImageView*nickNameImageView=[ZCControl createImageViewWithFrame:CGRectMake(20, 10, 20, 20) ImageName:@"icon_register_name.png"];
    [tempImageView addSubview:nickNameImageView];
    
    nickNameTextfield=[ZCControl createTextFieldWithFrame:CGRectMake(0, 114, WIDTH, 40) placeholder:@"请输入昵称" passWord:NO leftImageView:tempImageView rightImageView:nil Font:10 backgRoundImageName:nil];
    nickNameTextfield.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:nickNameTextfield];
    
    //免责声明
    dutylabel=[ZCControl createLabelWithFrame:CGRectMake(40, 160, 100, 10) Font:5 Text:@"注册即表示同意"];
    dutylabel.textColor=[UIColor grayColor];
    [self.view addSubview:dutylabel];
    
    dutyButton=[ZCControl createButtonWithFrame:CGRectMake(50, 160, 100, 10) ImageName:nil Target:self Action:@selector(dutyClick) Title:@"<微聊小圈免责声明>"];
    dutyButton.titleLabel.font=[UIFont systemFontOfSize:5];
    [dutyButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:dutyButton];
    
    //重试按钮
    tryButton=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-80, 70, 60, 30) ImageName:nil Target:self Action:@selector(tryClick) Title:@"重试"];
    [self.view addSubview:tryButton];
}

#pragma mark - 重试按钮
-(void)tryClick{
    
   userNameLabel.text = [NSString stringWithFormat:@"您的数字帐号为:%ld",DTAETIME];
}

#pragma mark - 进入免责声明
-(void)dutyClick{
    
    
}

#pragma mark － 导航按钮
-(void)createNav{
    
    UIButton * leftNavButton = [ZCControl createButtonWithFrame:CGRectMake(0, 0, 60, 30) ImageName:@"header_leftbtn_black_nor@2x.png" Target:self Action:@selector(backAction) Title:@"返回"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftNavButton];
    
    UIButton * rightNavButton = [ZCControl createButtonWithFrame:CGRectMake(0, 0, 60, 30) ImageName:nil Target:self Action:@selector(nextAction) Title:@"下一步"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightNavButton];
}

#pragma mark - 设置返回事件
-(void)backAction{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 下一个界面
-(void)nextAction{
    
    if(nickNameTextfield.text.length == 0){
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入昵称" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        return;
    }
    
    RegisterManager * manager = [RegisterManager shareManager];
    //获取用户名
    NSString * userName = [userNameLabel.text substringFromIndex:8];
    manager.userName = userName;
    //获取昵称
    manager.nickName = nickNameTextfield.text;
    
    RegisterViewController2 * registerVc = [[RegisterViewController2 alloc]init];
    registerVc.title = @"个人资料(2/4)";
    [self.navigationController pushViewController:registerVc animated:YES];
    
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
