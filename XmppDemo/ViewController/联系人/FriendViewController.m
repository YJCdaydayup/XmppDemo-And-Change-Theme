
//
//  FriendViewController.m
//  XmppDemo
//
//  Created by 杨力 on 14/6/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "FriendViewController.h"
#import "FirendRequestViewController.h"
#import "FriendCell.h"
#import "ChatViewController.h"

@interface FriendViewController ()<UIAlertViewDelegate>{
    
    int isOpen[4];//装4个BOOL值
    
    UIButton * tableViewHeaderButton;//表头;
}

@end

@implementation FriendViewController

-(void)viewWillAppear:(BOOL)animated{
    
        [self reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatTableView];
    
    [self createNav];
}

#pragma mark - 子类改变主题的通知
-(void)createNotificationTheme{
    
    [self createNav];
}

-(void)createNav{
    
    UIButton * button = [ZCControl createButtonWithFrame:CGRectMake(0, 0, 44, 44) ImageName:nil Target:self Action:@selector(rightAction) Title:nil];
    [button setImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@header_icon_add.png",self.path]] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex !=0){
        
        UITextField * textfield = [alertView textFieldAtIndex:0];
        if(textfield.text.length > 0){
            //添加好友
            [[ZCXMPPManager sharedInstance]addSomeBody:textfield.text Newmessage:nil];
        }
        
    }
}


#pragma mark - 添加好友
-(void)rightAction{
    
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"请输入对方账号" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

-(void)reloadData{
    
    //读取好友信息
    NSArray * array = [[ZCXMPPManager sharedInstance]friendsList:^(BOOL isOK) {
       
        [self reloadData];
    }];
    
    self.dataArray = [NSMutableArray arrayWithArray:array];
    [_tableView reloadData];
    
    //获取好友请求的数量
    NSInteger i = [ZCXMPPManager sharedInstance].subscribeArray.count;
    if(i>0){
        [tableViewHeaderButton setTitle:[NSString stringWithFormat:@"您有%d好友请求",i] forState:UIControlStateNormal];
    }else{
        [tableViewHeaderButton setTitle:@"没有好友请求消息" forState:UIControlStateNormal];
    }
}

-(void)creatTableView{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64-49) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    tableViewHeaderButton = [ZCControl createButtonWithFrame:CGRectMake(0, 0, WIDTH, 30) ImageName:nil Target:self Action:@selector(headerAction) Title:nil];
    
    _tableView.tableHeaderView = tableViewHeaderButton;
    [self.view addSubview:_tableView];
}

#pragma mark -显示好友请求的按钮
-(void)headerAction{
    
    FirendRequestViewController*vc=[[FirendRequestViewController alloc]init];
    vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 表格代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(isOpen[section]){
        
        return [self.dataArray[section]count];
    }else{
        return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FriendCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil){
        cell = [[FriendCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    //获取数据
    NSArray * array = self.dataArray[indexPath.section];
    XMPPUserCoreDataStorageObject * obj = array[indexPath.row];
    
    [cell config:obj];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
    
    return 30;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSArray*array=@[@"好友",@"关注",@"被关注",@"陌生人"];
    UIButton*button=[ZCControl createButtonWithFrame:CGRectMake(0, 0, WIDTH, 30) ImageName:nil Target:self Action:@selector(headerClick:) Title:array[section]];
    button.tag=section;
    return button;
}

#pragma mark -判断是否收起
-(void)headerClick:(UIButton *)sender{
    
    isOpen[sender.tag] = !isOpen[sender.tag];
    
    //刷新指定的某一段
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:sender.tag] withRowAnimation:UITableViewRowAnimationBottom];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //获取数据源
    XMPPUserCoreDataStorageObject * obj = [self.dataArray objectAtIndex:indexPath.section][indexPath.row];
    
    ChatViewController * chatVc = [[ChatViewController alloc]init];
    chatVc.friendJid = obj.jidStr;
    chatVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatVc animated:YES];
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
