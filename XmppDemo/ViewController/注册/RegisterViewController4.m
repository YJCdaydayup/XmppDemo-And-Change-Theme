//
//  RegisterViewController4.m
//  XmppDemo
//
//  Created by 杨力 on 14/6/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "RegisterViewController4.h"
#import "MaintabBarViewController.h"
#import "MainSliderViewController.h"


@interface RegisterViewController4 ()<UITextFieldDelegate>
{
    UITextField*qmdTextField;
    UITextField*addressTextField;
    
    UIAlertView*alert;
}

@end

@implementation RegisterViewController4

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"logo_bg_2@2x.png"]];
    [self createNav];
    [self createView];
}

-(void)createView{
    UIImageView*tempQmdImageView=[ZCControl createImageViewWithFrame:CGRectMake(0, 0, 60, 40) ImageName:nil];
    UIImageView*qmdImageView=[ZCControl createImageViewWithFrame:CGRectMake(20, 10, 20, 20) ImageName:@"icon_edit.png"];
    [tempQmdImageView addSubview:qmdImageView];
    
    qmdTextField=[ZCControl createTextFieldWithFrame:CGRectMake(0, 128, WIDTH, 40) placeholder:@"起一个狂拽炫酷的签名" passWord:NO leftImageView:tempQmdImageView rightImageView:nil Font:15 backgRoundImageName:nil];
    qmdTextField.delegate=self;
    qmdTextField.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:qmdTextField];
    
    UIImageView*tempAddressImageView=[ZCControl createImageViewWithFrame:CGRectMake(0, 0, 60, 40) ImageName:nil];
    UIImageView*addressImageView=[ZCControl createImageViewWithFrame:CGRectMake(20, 10, 20, 20) ImageName:@"feed_loc_new.png"];
    [tempAddressImageView addSubview:addressImageView];
    
    addressTextField=[ZCControl createTextFieldWithFrame:CGRectMake(0, 169, WIDTH, 40) placeholder:@"请输入地址" passWord:NO leftImageView:tempAddressImageView rightImageView:nil Font:15 backgRoundImageName:nil];
    addressTextField.backgroundColor=[UIColor whiteColor];
    addressTextField.delegate=self;
    [self.view addSubview:addressTextField];
}

-(void)createNav{
    
    UIButton * leftNavButton = [ZCControl createButtonWithFrame:CGRectMake(0, 0, 60, 30) ImageName:@"header_leftbtn_black_nor@2x.png" Target:self Action:@selector(backAction) Title:@"返回"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftNavButton];
    
    UIButton*rightButton=[ZCControl createButtonWithFrame:CGRectMake(0, 0, 60, 30) ImageName:nil Target:self Action:@selector(doneClick) Title:@"完成"];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightButton];
}

#pragma mark - 返回
-(void)backAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 完成注册
-(void)doneClick{
    
    if(qmdTextField.text.length > 0&&addressTextField.text.length>0){
        
        RegisterManager * manager = [RegisterManager shareManager];
        manager.qmd = qmdTextField.text;
        manager.address = addressTextField.text;
        
        //注册
        NSUserDefaults * udf = [NSUserDefaults standardUserDefaults];
        [udf setObject:manager.userName forKey:kXMPPmyJID];
        [udf setObject:manager.passWord forKey:kXMPPmyPassword];
        [udf synchronize];
        
        [[ZCXMPPManager sharedInstance]registerMothod:^(BOOL isSucceed) {
            
            [alert dismissWithClickedButtonIndex:0 animated:YES];
            
            if(isSucceed){
                
                
                //登录
                [[ZCXMPPManager sharedInstance]connectLogin:^(BOOL isSucceed) {
                    if(isSucceed){
                        
                        //登录成功
                        [[ZCXMPPManager sharedInstance]getMyVcardBlock:^(BOOL isSucceed, XMPPvCardTemp *card) {
                            //获取个人信息资料Vcar，进行更新
                            if(isSucceed){
                                
                                //开始更新
                                if(manager.headerImage){
                                    
                                    card.photo = UIImageJPEGRepresentation(manager.headerImage, 0.1);
                                }
                                //Vcard不支持中文，中文需要转码，否则无法上传成功
                                
                                if(manager.nickName){
                                    card.nickname = CODE(manager.nickName);
                                }
                                //自定义的Vcard
                                if(manager.phoneNumber){
                                    
                                    [[ZCXMPPManager sharedInstance]customVcardXML:CODE(manager.phoneNumber) name:PHONENUM myVcard:card];
                                }
                                if (manager.address) {
                                    [[ZCXMPPManager sharedInstance]customVcardXML:CODE(manager.address) name:ADDRESS myVcard:card];
                                }
                                if (manager.birthday) {
                                    [[ZCXMPPManager sharedInstance]customVcardXML:CODE(manager.birthday) name:BYD myVcard:card];
                                }
                                if (manager.sex) {
                                    [[ZCXMPPManager sharedInstance]customVcardXML:CODE(manager.sex) name:SEX myVcard:card];
                                }
                                if (manager.qmd) {
                                    [[ZCXMPPManager sharedInstance]customVcardXML:CODE(manager.qmd) name:QMD myVcard:card];
                                }
                                
                                //更新在服务器上
                                [[ZCXMPPManager sharedInstance]upData:card];
                                
                                //跳转到主界面
                                MainSliderViewController*vc=(MainSliderViewController*)[MainSliderViewController sharedSliderController];
                                [self.navigationController pushViewController:vc animated:YES];
                            }
                            
                            
                        }];
                    }else{
                        
                        //登录失败
                    }
                    
                }];
                
                //进行Vcard更新，完善个人资料
                
            }else{
                
                //提示用户错误,为客户再次生成数字帐号
                manager.userName = [NSString stringWithFormat:@"%ld",DTAETIME];
                [self doneClick];
            }
            
            
        }];
        
    }else{
        
        
        
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
