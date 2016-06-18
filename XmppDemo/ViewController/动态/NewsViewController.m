
//
//  NewsViewController.m
//  XmppDemo
//
//  Created by 杨力 on 14/6/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "NewsViewController.h"
#import "ZCZBarViewController.h"
#import "AppDelegate.h"

@interface NewsViewController (){
    
    NSArray *imageArray;
}

@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTableView];
    
    [self reloadData];
}

-(void)reloadData{
    
    self.dataArray=[NSMutableArray arrayWithObjects:@"微空间",@"扫一扫",@"摇一摇",@"附近人",@"附近群",@"雷达",nil];
    imageArray = @[@"icon_beiguanzhu_1.png",@"icon_code.png",@"icon_phone.png",@"icon_near.png",@"icon_friend_1@2x.png",@"icon_tuijian_1.png"];
    
    [_tableView reloadData];
}

-(void)createTableView{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64-49) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.imageView.image = [UIImage imageNamed:imageArray[indexPath.row]];
    cell.textLabel.text = self.dataArray[indexPath.row];
    
    return cell;;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0:
            
            break;
        case 1:
            //扫一扫 zbarSdk
        {
            ZCZBarViewController * zBarSDk = [[ZCZBarViewController alloc]initWithBlock:^(NSString * qr, BOOL isSucceed) {
                zBarSDk.view.backgroundColor = [UIColor blackColor];
                if(isSucceed){
                    [[ZCXMPPManager sharedInstance]addSomeBody:qr Newmessage:nil];
                    
                    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:qr]];
                    
                }
            }];
            
            [self presentViewController:zBarSDk animated:YES completion:nil];
        }
            
            break;
        case 2:
            
            break;
        case 3:
            
            break;
        case 4:
            
            break;
        case 5:
            
            break;
            
        default:
            break;
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
