//
//  ThemeViewController.m
//  XmppDemo
//
//  Created by 杨力 on 15/6/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "ThemeViewController.h"
#import "HttpDownLoadBlock.h"
#import "UIImageView+AFNetworking.h"
#import "ThemeManager.h"


@interface ThemeViewController ()

@end

@implementation ThemeViewController
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=NO;
}
-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTableView];
    [self loadData];
}

-(void)createTableView{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

-(void)loadData{
    HttpDownLoadBlock*request=[[HttpDownLoadBlock alloc]initWithStrUrl:@"http://imgcache.qq.com/club/item/theme/json/data_4.6+_3.json?callback=json" Block:^(BOOL isSucceed, HttpDownLoadBlock *http) {
        //需要注意的是这个地址不是常规地址，无法获得解析结果，需要进行对字符串进行操作，之后才能解析
        [self jsonValue:http];
    }];
}

-(void)jsonValue:(HttpDownLoadBlock *)http{
    
    //获取的数据转化为字符串
    NSString * str = [[NSString alloc]initWithData:http.data encoding:NSUTF8StringEncoding];
    NSRange range = [str rangeOfString:@"("];
    NSRange range1 = [str rangeOfString:@")"];
    str = [str substringWithRange:NSMakeRange(range.location+1, range1.location-range.location-1)];
    //解析数据
    NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    NSDictionary * dict1 = [dict objectForKey:@"detailList"];
    //获取字典中的所有键值对
    self.dataArray = [[NSMutableArray alloc]initWithArray:[dict1 allValues]];
    [_tableView reloadData];
}

#pragma mark - 表格代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
        UIImageView*imageView=[ZCControl createImageViewWithFrame:CGRectMake(10, 0, 80, 45) ImageName:@"logo_2.png"];
        imageView.tag=200;
        [cell.contentView addSubview:imageView];
        
        UILabel*label=[ZCControl createLabelWithFrame:CGRectMake(100,5, 100, 30) Font:15 Text:nil];
        label.tag=300;
        [cell.contentView addSubview:label];
    }
    
    //数据源
    NSDictionary * dict = self.dataArray[indexPath.row];
    //获取id值
    NSString * idStr = [dict objectForKey:@"id"];
    NSString * num = [NSString stringWithFormat:@"%d",[idStr intValue]%10];
    //拼接图片的网络地址
    NSString*imageUrlStr=[NSString stringWithFormat:@"http://i.gtimg.cn/club/item/theme/img/%@/%@/mobile_list.jpg?max_age=31536000&t=0",num,idStr];
//    [cell.imageView setImageWithURL:[NSURL URLWithString:imageUrlStr]];//AFNetworking也有
    //寻找200和300的控件
    UIImageView*imageView=(UIImageView*)[cell.contentView viewWithTag:200];
    UILabel*label=(UILabel*)[cell.contentView viewWithTag:300];
    [imageView setImageWithURL:[NSURL URLWithString:imageUrlStr] placeholderImage:[UIImage imageNamed:@"logo_2.png"]];
    label.text=dict[@"name"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //获取数据源
    NSDictionary * dict = self.dataArray[indexPath.row];
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"正在下载中..." delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];

    ThemeManager * manager = [ThemeManager shareManager];
    
    NSLog(@"能执行这句demo吗");
    BOOL isOk = [manager themeDownloadData:dict Block:^(BOOL isOK) {
       
        [alert dismissWithClickedButtonIndex:0 animated:YES];
    }];
    
    if(!isOk){
           [alert show];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
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
