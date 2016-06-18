//
//  FirendRequestViewController.m
//  XmppDemo
//
//  Created by 杨力 on 17/6/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "FirendRequestViewController.h"

@interface FirendRequestViewController ()

@end

@implementation FirendRequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self createTableView];
    [self loadData];
}

-(void)loadData{
    
    //获取好友添加请求列表
    self.dataArray = [ZCXMPPManager sharedInstance].subscribeArray;
    [_tableView reloadData];
}

-(void)createTableView{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

#pragma mark -表格代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        UIButton*agreeButton=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-120, 0, 60, 30) ImageName:nil Target:self Action:@selector(agreeButtonClick:) Title:@"同意"];
        [cell.contentView addSubview:agreeButton];
        UIButton*rejectButton=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-60, 0, 60, 30) ImageName:nil Target:self Action:@selector(rejectButtonClick:) Title:@"拒绝"];
        [cell.contentView addSubview:rejectButton];
    }
    
    //读取数据源
    XMPPPresence * presence = self.dataArray[indexPath.row];
    //获取账号
    cell.textLabel.text = presence.from.user;
    
    return cell;
}

#pragma mark - 同意添加
-(void)agreeButtonClick:(UIButton *)sender{
    
    //可以通过这个方法获取到父cell的indexPath.row
    XMPPPresence * persence = self.dataArray[sender.superview.tag];
    NSString * userName = persence.from.user;
    [[ZCXMPPManager sharedInstance]agreeRequest:userName];
    [self loadData];
}

#pragma mark - 拒绝添加
-(void)rejectButtonClick:(UIButton *)sender{
    
    XMPPPresence * presence = self.dataArray[sender.superview.tag];
    NSString * userName = presence.from.user;
    [[ZCXMPPManager sharedInstance]reject:userName];
    [self loadData];
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
