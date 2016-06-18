//
//  MyVcardViewController.m
//  XmppDemo
//
//  Created by 杨力 on 15/6/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "MyVcardViewController.h"

@interface MyVcardViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UIAlertViewDelegate>{
    
    //记录是否修改了
    BOOL isUpdate;
}

@property (nonatomic,assign) XMPPvCardTemp * myVcard;
@property (nonatomic,strong) NSMutableDictionary *dataDic;

@end

@implementation MyVcardViewController

-(void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBarHidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    
    self.navigationController.navigationBarHidden = YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTableView];
    
    [self loadData];
    
    //左导航按钮
    [self createLeftButton];
}

-(void)createLeftButton{
    
    UIButton * button = [ZCControl createButtonWithFrame:CGRectMake(0, 0, 60, 30) ImageName:nil Target:self Action:@selector(backClick) Title:@"返回"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
}

#pragma mark - 返回按钮
-(void)backClick{
    
    if(isUpdate){
        
        [[ZCXMPPManager sharedInstance]upData:self.myVcard];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 获取数据
-(void)loadData{
    
    //获取Vcard，并且记录
    [[ZCXMPPManager sharedInstance]getMyVcardBlock:^(BOOL isOk, XMPPvCardTemp *myVcard) {
        
        if(isOk){
            self.myVcard = myVcard;
            //组装数据
            //获取头像
            NSData * headerImageData;
            if(self.myVcard.photo){
                headerImageData = self.myVcard.photo;
            }else{
                
                headerImageData = UIImagePNGRepresentation([UIImage imageNamed:@"logo_2.png"]);
            }
            
            NSString * nickName;
            if(self.myVcard.nickname){
                nickName = self.myVcard.nickname;
            }else{
                nickName = [[NSUserDefaults standardUserDefaults]objectForKey:kXMPPmyJID];
            }
            
            NSString * qmd;
            qmd = [[self.myVcard elementForName:QMD]stringValue];
            if(qmd == nil){
                qmd = [[NSUserDefaults standardUserDefaults]objectForKey:QMD];
            }
            
            NSString * sex;
            sex = [[self.myVcard elementForName:SEX]stringValue];
            if(sex == nil){
                sex = @"无性别";
            }
            
            NSString * address;
            address = [[self.myVcard elementForName:ADDRESS]stringValue];
            if(address == nil){
                address = @"火星";
            }
            
            NSString * qr;
            qr = [[NSUserDefaults standardUserDefaults]objectForKey:kXMPPmyJID];
            
            NSString * phoneNumber;
            phoneNumber = [[self.myVcard elementForName:PHONENUM]stringValue];
            if(phoneNumber==nil){
                phoneNumber = @"你会有我电话的";
            }
            
            //初始化数组
            self.dataArray=[NSMutableArray arrayWithObjects:@"头像",@"昵称",@"签名",@"性别",@"地区",@"二维码",@"手机号", nil];
            
            self.dataDic=[NSMutableDictionary dictionaryWithObjectsAndKeys:headerImageData,@"头像",UNCODE(nickName),@"昵称",UNCODE(qmd),@"签名",UNCODE(sex),@"性别",UNCODE(address),@"地区",qr,@"二维码",UNCODE(phoneNumber),@"手机号", nil];
            
            [_tableView reloadData];
        }
    }];
}

#pragma mark - 创建表格
-(void)createTableView{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

#pragma mark - 表格代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell1"];
        cell.detailTextLabel.textColor = [UIColor grayColor];
        
        //创建一个ImageView装图片,这里写成重新生成，不要搞成全局变量
        UIImageView * imageView = [ZCControl createImageViewWithFrame:CGRectMake(WIDTH-60, 0, 40, 40) ImageName:nil];
        imageView.tag = 120;
        imageView.layer.cornerRadius = 20;
        imageView.clipsToBounds = YES;
        [cell.contentView addSubview:imageView];
    }
    
    cell.textLabel.text = self.dataArray[indexPath.row];
    
    //头像和二维码需要设置为图片
    cell.detailTextLabel.text = nil;
    //找到ImageView
    UIImageView * imageView = (UIImageView *)[cell.contentView viewWithTag:120];
    imageView.hidden = YES;
    if(indexPath.row == 0){
        
        //头像
        imageView.hidden = NO;
        imageView.image = [UIImage imageWithData:self.dataDic[self.dataArray[indexPath.row]]];
        
    }else if (indexPath.row == 5){
        
        //二维码
        imageView.hidden = NO;
        imageView.image = [UIImage imageNamed:@"menu_icon_QR@2x"];
        
    }else{
        cell.detailTextLabel.text = self.dataDic[self.dataArray[indexPath.row]];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //进行修改
    if(indexPath.row == 0){
        
        UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:@"提示" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册",@"相机", nil];
        [sheet showInView:self.view];
    }else{
        
        if(indexPath.row !=3 &&indexPath.row != 5){
            
            UITableViewCell * cell = [_tableView cellForRowAtIndexPath:indexPath];
            [self createAlertShowTitile:[NSString stringWithFormat:@"请输入%@",cell.textLabel.text] tag:indexPath.row];
        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //获取输入框
    UITextField * textfield = [alertView textFieldAtIndex:0];
    
    if(textfield.text.length == 0){
        return;
    }
    
    if(buttonIndex == 0){
        return;
    }
    switch (alertView.tag) {
        case 1:
            
            //昵称
            self.myVcard.nickname = CODE(textfield.text);
            [self.dataDic setObject:textfield.text forKey:@"昵称"];
            break;
        case 2:
            
            //签名
            [[ZCXMPPManager sharedInstance]customVcardXML:CODE(textfield.text) name:QMD myVcard:self.myVcard];
            [self.dataDic setObject:textfield.text forKey:@"签名"];
            break;
        case 4:
            
            //地区
            [[ZCXMPPManager sharedInstance]customVcardXML:CODE(textfield.text) name:ADDRESS myVcard:self.myVcard];
            [self.dataDic setObject:textfield.text forKey:@"地区"];

            break;
        case 6:
            
            //手机号
            [[ZCXMPPManager sharedInstance]customVcardXML:CODE(textfield.text) name:PHONENUM myVcard:self.myVcard];
            [self.dataDic setObject:textfield.text forKey:@"手机号"];
            break;
            
        default:
            break;
    }
    
    isUpdate = YES;
    [_tableView reloadData];
}

-(void)createAlertShowTitile:(NSString *)title tag:(NSInteger)tag{
    
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:title message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = tag;
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 2){
        
        return;
    }
    
    UIImagePickerController * picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    if(buttonIndex == 0){
        if([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]){
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
    }
    
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark -UIImagePickerControllerDeleagte
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    //获取图片
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self.dataDic setObject:UIImagePNGRepresentation(image) forKey:@"头像"];
    //同时修改数据源头像
    self.myVcard.photo = UIImageJPEGRepresentation(image, 0.1);
    //记录修改
    isUpdate = YES;
    [_tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
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
