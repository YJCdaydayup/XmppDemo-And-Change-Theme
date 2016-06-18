//
//  RegisterViewController2.m
//  XmppDemo
//
//  Created by 杨力 on 14/6/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "RegisterViewController2.h"
#import "RegisterViewController3.h"

@interface RegisterViewController2 ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>{
    
    //头像按钮
    UIButton * headerImageButton;
    //选择生日按钮
    UIControl * birthdayControl;
    //生日的图标
    UIImageView * birthdayImageView;
    //生日的日期
    UILabel * birthdayLabel;
    //生日的箭头
    UIImageView * birthdayRightImageView;
    //生日背景图
    UIView * birthdayView;
    //性别按钮
    UIControl * sexControl;
    //性别图表
    UIImageView * sexImageView;
    //性别结果
    UILabel * sexLabel;
    //性别的右箭头
    UIImageView * sexRightImageView;
    //性别的背景图
    UIView * sexView;
    
    //选择日期的滚筒控件
    UIDatePicker * _dataPicker;
    
    
    //记录是否有值
    BOOL isHeaderImage;
    BOOL isBirthday;
}

@end

@implementation RegisterViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"logo_bg_2@2x.png"]];
    
    //设置导航
    [self createNav];
    //设置页面
    [self createView];
    
}

#pragma mark - 隐藏picker
-(void)hidePicker{
    
    if(_dataPicker.frame.origin.y!=HEIGHT){
        
        [UIView animateWithDuration:0.3 animations:^{
            
            _dataPicker.frame = CGRectMake(0, HEIGHT, WIDTH, 216);
        }];
    }
}

#pragma mark - 页面设置
-(void)createView{
    
    headerImageButton=[ZCControl createButtonWithFrame:CGRectMake(WIDTH/2-50,74, 100, 100) ImageName:@"icon_register_camera@2x.png" Target:self Action:@selector(headerImageButtonClick) Title:nil];
    headerImageButton.backgroundColor=[UIColor whiteColor];
    //button切圆角
    headerImageButton.layer.cornerRadius=15;
    headerImageButton.layer.masksToBounds=YES;
    [self.view addSubview:headerImageButton];
    
    //生日的界面
    birthdayView=[ZCControl viewWithFrame:CGRectMake(0, 194, WIDTH, 40)];
    birthdayView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:birthdayView];
    //设置生日图片
    birthdayImageView=[ZCControl createImageViewWithFrame:CGRectMake(20, 10, 20, 20) ImageName:@"icon_register_birthday.png"];
    [birthdayView addSubview:birthdayImageView];
    //设置生日的label
    birthdayLabel=[ZCControl createLabelWithFrame:CGRectMake(60, 10, 200, 20) Font:10 Text:@"请选择你的生日"];
    birthdayLabel.textColor=[UIColor grayColor];
    [birthdayView addSubview:birthdayLabel];
    //设置右边的箭头
    birthdayRightImageView=[ZCControl createImageViewWithFrame:CGRectMake(WIDTH-50,10 , 20, 20) ImageName:@"btn_forward_disabled.png"];
    [birthdayView addSubview:birthdayRightImageView];
    //增加点击事件
    birthdayControl=[[UIControl alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
    [birthdayControl addTarget:self action:@selector(birthdayClick) forControlEvents:UIControlEventTouchUpInside];
    [birthdayView addSubview:birthdayControl];
    
    //性别
    sexView=[ZCControl viewWithFrame:CGRectMake(0, 235, WIDTH, 40)];
    sexView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:sexView];
    
    sexImageView=[ZCControl createImageViewWithFrame:CGRectMake(20, 10, 20, 20) ImageName:@"icon_register_gender.png"];
    [sexView addSubview:sexImageView];
    
    sexLabel=[ZCControl createLabelWithFrame:CGRectMake(60, 10, 200, 20) Font:10 Text:@"请选择性别"];
    sexLabel.textColor=[UIColor grayColor];
    [sexView addSubview:sexLabel];
    
    sexRightImageView=[ZCControl createImageViewWithFrame:CGRectMake(WIDTH-50, 10, 20, 20) ImageName:@"btn_forward_disabled.png"];
    [sexView addSubview:sexRightImageView];
    
    sexControl=[[UIControl alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
    [sexControl addTarget:self action:@selector(sexClick) forControlEvents:UIControlEventTouchUpInside];
    [sexView addSubview:sexControl];
    
    
    UILabel*infoLabel=[ZCControl createLabelWithFrame:CGRectMake(20, 280, WIDTH, 20) Font:10 Text:@"性别选择后，不允许修改，请谨慎操作"];
    infoLabel.textColor=[UIColor grayColor];
    [self.view addSubview:infoLabel];
    
    
}

#pragma mark - 上传头像
-(void)headerImageButtonClick{
    
    UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:@"提示" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机",@"相册", nil];
    sheet.tag = 100;
    [sheet showInView:self.view];
}

#pragma mark - 获取生日
-(void)birthdayClick{
    
    if(_dataPicker){
        
        //移动坐标
        [UIView animateWithDuration:0.3 animations:^{
            
            _dataPicker.frame = CGRectMake(0, HEIGHT-216, WIDTH, 216);
        }];
    }else{
        
        _dataPicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, HEIGHT, WIDTH, 216)];
        //设置最大值
        [_dataPicker setMaximumDate:[NSDate date]];
        //设置最小值
        NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate * minDate = [formatter dateFromString:@"1920-01-01"];
        [_dataPicker setMaximumDate:minDate];
        //设置滚筒模式
        _dataPicker.datePickerMode = UIDatePickerModeDate;
        //添加触发事件
        [_dataPicker addTarget:self action:@selector(datePickerClick:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:_dataPicker];
        
        [UIView animateWithDuration:0.3 animations:^{
            
            _dataPicker.frame = CGRectMake(0, HEIGHT-216, WIDTH, 216);
        }];
    }
}

#pragma mark - 滚筒事件
-(void)datePickerClick:(UIDatePicker *)picker{
    
    NSDate *date = picker.date;
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    birthdayLabel.text = [formatter stringFromDate:date];
}

#pragma mark - 获取性别
-(void)sexClick{
    
    UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:@"提示" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女", nil];
    sheet.tag = 101;
    [sheet showInView:self.view];
}

-(void)createNav{
    
    UIButton * leftNavButton = [ZCControl createButtonWithFrame:CGRectMake(0, 0, 60, 30) ImageName:@"header_leftbtn_black_nor@2x.png" Target:self Action:@selector(backAction) Title:@"返回"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftNavButton];
    
    UIButton * rightButton = [ZCControl createButtonWithFrame:CGRectMake(0, 0, 60, 30) ImageName:nil Target:self Action:@selector(rightClick) Title:@"下一步"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
}

#pragma mark - 右导航
-(void)rightClick{
    
    RegisterViewController3 * regisrerVc3 = [[RegisterViewController3 alloc]init];
    regisrerVc3.title = @"个人资料3/4";
    [self.navigationController pushViewController:regisrerVc3 animated:YES];
}

#pragma mark - 左导航
-(void)backAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 2){
        //取消
        return;
    }
    
    if(actionSheet.tag == 100){
        
        //从相机或者相册选择
        UIImagePickerController * picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        if(buttonIndex == 0){
            
            //相机，先判断相机是否可用
            if([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]){
                
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            }
        }
        
        [self presentViewController:picker animated:YES completion:nil];
    }else if (actionSheet.tag == 101){
        
        if(buttonIndex == 0){
            
            sexLabel.text = @"男";
            sexImageView.image = [UIImage imageNamed:@"icon_register_man.png"];
        }else{
            
            sexLabel.text = @"女";
            sexImageView.image = [UIImage imageNamed:@"icon_register_woman.png"];
        }
        
        //不用关心是男是女，只需要关心
        RegisterManager * manager = [RegisterManager shareManager];
        manager.sex = sexLabel.text;
        
    }
}

#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    //获取摄像头下的image
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [headerImageButton setBackgroundImage:image forState:UIControlStateNormal];
    
    //用于记录修改过
    isHeaderImage = YES;
    RegisterManager * manager = [RegisterManager shareManager];
    manager.headerImage = image;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 当遇到手势拦截时，用这种方法
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self hidePicker];
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
