//
//  LoginViewController.m
//  XmppDemo
//
//  Created by 杨力 on 14/6/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "MainSliderViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>
{
    //背景图
    UIView*bgView;
    //logo
    UIImageView*logoImageView;
    //承载2个输入框
    UIImageView*textImageView;
    //用户名
    UITextField*userNameTextField;
    //密码
    UITextField*passWordTextField;
}


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建背景图和logo
    [self createView];
    //创建输入框
    [self createTextfield];
    
    //观察键盘的弹出和回收
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //给bgView添加手势
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyBoard)];
    [bgView addGestureRecognizer:tap];
}

-(void)hideKeyBoard{
    
    [self.view endEditing:YES];
}

#pragma mark - textfield代理方法
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if(textField == userNameTextField){
        
        [passWordTextField becomeFirstResponder];
        [userNameTextField resignFirstResponder];
        
    }else{
        
        [userNameTextField resignFirstResponder];
        [passWordTextField resignFirstResponder];
        
        [self loginClick];
    }
    
    return YES;
}

#pragma mark - 键盘的监听事件
-(void)keyboardShow:(NSNotification *)notice{
    //计算键盘高度
    //    float height = [[notice.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue].size.height;
    [UIView animateWithDuration:0.5 animations:^{
        
        bgView.transform = CGAffineTransformMakeTranslation(0, -110);
        logoImageView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    }];
    
}
-(void)keyboardWillHide:(NSNotification *)notice{
    
    [UIView animateWithDuration:0.5 animations:^{
        
        bgView.transform = CGAffineTransformIdentity;
        logoImageView.transform = CGAffineTransformIdentity;
    }];
}

-(void)createTextfield{
    
    //临时的View
    UIImageView * userTempImageView = [ZCControl createImageViewWithFrame:CGRectMake(0, 0, 50, 40) ImageName:nil];
    UIImageView * userImageView = [ZCControl createImageViewWithFrame:CGRectMake(20, 10, 20, 20) ImageName:@"userName.png"];
    [userTempImageView addSubview:userImageView];
    
    userNameTextField = [ZCControl createTextFieldWithFrame:CGRectMake(0, 15, WIDTH-20, 40) placeholder:@"请输入用户名" passWord:NO leftImageView:userTempImageView rightImageView:nil Font:15 backgRoundImageName:nil];
    userNameTextField.delegate = self;
    [textImageView addSubview:userNameTextField];
    
    //临时的View
    UIImageView * passTempImageView = [ZCControl createImageViewWithFrame:CGRectMake(0, 0, 50, 40) ImageName:nil];
    UIImageView * passImageView = [ZCControl createImageViewWithFrame:CGRectMake(20, 10, 20, 20) ImageName:@"passWord.png"];
    [passTempImageView addSubview:passImageView];
    
    
    passWordTextField = [ZCControl createTextFieldWithFrame:CGRectMake(0, 70, WIDTH-20, 40) placeholder:@"请输入密码" passWord:YES leftImageView:passTempImageView rightImageView:nil Font:15 backgRoundImageName:nil];
    passWordTextField.delegate = self;
    [textImageView addSubview:passWordTextField];
}

-(void)createView{
    
    //背景图
    bgView=[ZCControl viewWithFrame:self.view.frame];
    //设置颜色
    bgView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"logo_bg_2@2x.png"]];
    [self.view addSubview:bgView];
    
    //创建logo 预计是120*120
    logoImageView=[ZCControl createImageViewWithFrame:CGRectMake(WIDTH/2-60, 44, 120, 120) ImageName:@"logo_2.png"];
    //圆
    logoImageView.layer.cornerRadius=60;
    logoImageView.layer.masksToBounds=YES;
    [bgView addSubview:logoImageView];
    //输入框的图片
    textImageView=[ZCControl createImageViewWithFrame:CGRectMake(0, 0, WIDTH-20, 120) ImageName:@"login@2x.png"];
    //设置中心点
    textImageView.center=CGPointMake(WIDTH/2, 230);
    [bgView addSubview:textImageView];
    //设置登陆按钮
    
    UIButton*registerButton=[ZCControl createButtonWithFrame:CGRectMake(WIDTH/2-80, 340, 60, 30) ImageName:@"btn_login_bg_2.png" Target:self Action:@selector(registerClick) Title:@"注册"];
    [registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bgView addSubview:registerButton];
    
    UIButton*loginButton=[ZCControl createButtonWithFrame:CGRectMake(WIDTH/2+20, 340, 60, 30) ImageName:@"btn_login_bg_2.png" Target:self Action:@selector(loginClick) Title:@"登陆"];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bgView addSubview:loginButton];
    
}

#pragma mark - 注册事件
-(void)registerClick{
    
    RegisterViewController * registerVc = [[RegisterViewController alloc]init];
    //默认动画
    registerVc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    registerVc.title = @"请输入昵称";
    UINavigationController * nvc = [[UINavigationController alloc]initWithRootViewController:registerVc];
    
    //从这个界面开始有导航条
    [self presentViewController:nvc animated:YES completion:nil];
}
#pragma mark - 登录事件
-(void)loginClick{
    
    //收回键盘
    [self.view endEditing:YES];
    
    if(userNameTextField.text.length > 0&&passWordTextField.text.length > 0){
        
        //执行登录
        
        NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
        [user setObject:userNameTextField.text forKey:kXMPPmyJID];
        [user setObject:passWordTextField.text forKey:kXMPPmyPassword];
        [user synchronize];
        
        //执行XMPP的登录功能
        [[ZCXMPPManager sharedInstance]connectLogin:^(BOOL isSucceed) {
            
            if(isSucceed){
                
                MainSliderViewController * mainVc = [[MainSliderViewController alloc]init];
                UINavigationController * nvc = [[UINavigationController alloc]initWithRootViewController:mainVc];
                nvc.modalTransitionStyle  = UIModalTransitionStyleCrossDissolve;
                [self presentViewController:nvc animated:YES completion:nil];
                
            }else{
                
                //创建控制视图对象
                UIAlertController * alertView = [UIAlertController alertControllerWithTitle:@"提示" message:@"用户名或密码错误" preferredStyle:UIAlertControllerStyleAlert];
                //使用present展示出视图
                [self presentViewController:alertView animated:YES completion:nil];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertView dismissViewControllerAnimated:YES completion:nil];
                });

            }
            
        }];
        
        
    }else{
        //创建控制视图对象
        UIAlertController * alertView = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入用户名或密码" preferredStyle:UIAlertControllerStyleAlert];
        //使用present展示出视图
        [self presentViewController:alertView animated:YES completion:nil];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [alertView dismissViewControllerAnimated:YES completion:nil];
        });
    }
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
