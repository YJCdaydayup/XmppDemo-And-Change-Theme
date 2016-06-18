
//
//  SettingViewController.m
//  XmppDemo
//
//  Created by 杨力 on 14/6/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "SettingViewController.h"
#import "AppDelegate.h"
#import "MainSliderViewController.h"
#import "LoginViewController.h"
#import "MyVcardViewController.h"
#import "ThemeViewController.h"

@interface SettingViewController (){
    
    //上面的大图
    UIImageView * headerImageView;
    //头像
    UIImageView * myHeaderImageView;
    //签名
    UILabel * qmdLabel;
    //昵称
    UILabel * nickName;
}

@property (nonatomic,strong) NSArray * imageArray;

@end

@implementation SettingViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [self createMyVcard];
    [_tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loginAgain];
    
    [self createView];
    
    [self createTableView];
    
    [self loadData];
}

-(void)loginAgain{
    
    NSUserDefaults * udf = [NSUserDefaults standardUserDefaults];
    //判断是否有值,登录过，需要再次进行登录
    if([udf objectForKey:isLogin]){
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"" message:@"重新登录..." delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [[ZCXMPPManager sharedInstance] connectLogin:^(BOOL isSucceed) {
            
            [alert dismissWithClickedButtonIndex:0 animated:YES];
            if(isSucceed){
                
                NSLog(@"登录成功");
                [self createMyVcard];
            }else{
                
                
            }
        }];
    }else{
        
        //从注册或者登录界面过来，不需要再次登录，但是需要记录isLogin的值
        [self createMyVcard];
        [udf setObject:isLogin forKey:isLogin];
        [udf synchronize];
    }
}

#pragma mark - 获取名片
-(void)createMyVcard{
    
    [[ZCXMPPManager sharedInstance]getMyVcardBlock:^(BOOL isSucceed, XMPPvCardTemp *card) {
        
        if(card.photo){
            
            myHeaderImageView.image = [UIImage imageWithData:card.photo];
        }
        if(card.nickname){
            
            nickName.text = UNCODE(card.nickname);
        }
        NSString * qmd = [[card elementForName:QMD]stringValue];
        if(qmd){
            qmdLabel.text = UNCODE(qmd);
        }
    }];
}

#pragma mark - 创建数据
-(void)loadData{
    
    self.dataArray = [[NSMutableArray alloc]initWithObjects:@"个人资料",@"主题设置",@"气泡设置",@"聊天背景",@"关于我们",@"反馈",nil];
    self.imageArray = @[@"buddy_header_icon_circle_small.png",@"found_icons_readcenter.png",@"circle_schoolmate.png",@"file_icon_picture.png",@"buddy_header_icon_troopGroup_small.png",@"buddy_header_icon_discussGroup_small.png"];
    [_tableView reloadData];
}

#pragma mark - 创建表格
-(void)createTableView{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, HEIGHT/4.0, WIDTH/2.0, HEIGHT/4*3) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

#pragma mark - 表格代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:self.imageArray[indexPath.row
                                                               ]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIButton*logOutButton=[ZCControl createButtonWithFrame:CGRectMake(0, 10, 160, 30) ImageName:nil Target:self Action:@selector(logOut) Title:@"退出当前账号"];
    
    logOutButton.backgroundColor=[UIColor redColor];
    [logOutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //圆角
    logOutButton.layer.cornerRadius=10;
    logOutButton.layer.masksToBounds=YES;
    UIView*view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
    [view addSubview:logOutButton];
    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MainSliderViewController * mainVc = (MainSliderViewController *)[MainSliderViewController sharedSliderController];
    
    switch (indexPath.row) {
        case 0:
            //个人资料
        {
            MyVcardViewController * vCardVc = [[MyVcardViewController alloc]init];
            //关闭动画之后，就跳转
            [mainVc closeSideBarWithAnimate:YES complete:^(BOOL finished) {
                //找到MainSliderViewController，才能进行跳转
                [self.navigationController pushViewController:vCardVc animated:YES];
            }];
        }
            
            break;
        case 1:
            
            //主题设置
        {
            ThemeViewController * themeVc = [[ThemeViewController alloc]init];
            [mainVc closeSideBarWithAnimate:YES complete:^(BOOL finished) {
                [self.navigationController pushViewController:themeVc animated:YES];
            }];
        }
            
            break;
        case 2:
            
            //气泡设置
            
            break;
        case 3:
            
            //聊天背景
            
            break;
        case 4:
            
            //关于我们
            
            break;
        case 5:
            
            //反馈
            
            break;
            
        default:
            break;
    }
}

//子类收到广播
-(void)createNotificationTheme{
    
    NSString * imagePath = [NSString stringWithFormat:@"%@header_bg.png",self.path];
    headerImageView.image = [UIImage imageWithContentsOfFile:imagePath];
}

#pragma mark - 界面设置
-(void)createView{
    
    NSString * imagePath = [NSString stringWithFormat:@"%@header_bg.png",self.path];
    headerImageView = [ZCControl createImageViewWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT/4.0) ImageName:imagePath];
    [self.view addSubview:headerImageView];
    
    //头像
    myHeaderImageView=[ZCControl createImageViewWithFrame:CGRectMake(20, HEIGHT/4-84, 64, 64) ImageName:@"logo_2.png"];
    myHeaderImageView.layer.cornerRadius=32;
    myHeaderImageView.layer.masksToBounds=YES;
    [headerImageView addSubview:myHeaderImageView];
    //用户的昵称
    nickName=[ZCControl createLabelWithFrame:CGRectMake(94, HEIGHT/4-84, 100, 20) Font:15 Text:@"昵称"];
    nickName.textColor=[UIColor whiteColor];
    [headerImageView addSubview:nickName];
    //签名
    qmdLabel=[ZCControl createLabelWithFrame:CGRectMake(20, HEIGHT/4-20, 200, 20) Font:10 Text:nil];
    qmdLabel.textColor=[UIColor grayColor];
    [headerImageView addSubview:qmdLabel];}

#pragma mark - 注销，先切断网络连接，如果不切换就替换UI，会造成网络数据回来赋值给了野指针
-(void)logOut{
    
    [[ZCXMPPManager sharedInstance]disconnect];
    
    //找到app代理类
    AppDelegate * app = [UIApplication sharedApplication].delegate;
    //找到侧滑指针
    MainSliderViewController * vca = (MainSliderViewController *) [MainSliderViewController sharedSliderController];
    
    //找到登录界面的指针
    LoginViewController * loginVc = [[LoginViewController alloc]init];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        app.window.rootViewController = loginVc;
        
    } completion:^(BOOL finished) {
        
        //释放掉
        [vca releaseClick];
        
        //在这里一定要将记录清除掉，不然会崩溃
        NSUserDefaults * udf = [NSUserDefaults standardUserDefaults];
        [udf removeObjectForKey:isLogin];
    }];
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
