
//
//  RecentlyViewController.m
//  XmppDemo
//
//  Created by 杨力 on 14/6/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "RecentlyViewController.h"
#import "ZCMessageObject.h"
#import "ChatViewController.h"


@interface RecentlyViewController ()

@end

@implementation RecentlyViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createTableView];
    [self reloadData];
}

-(void)reloadData{
    
    self.dataArray = [ZCMessageObject fetchRecentChatByPage:20];
    [_tableView reloadData];
}

-(void)createTableView{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64-49) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    NSArray * array = self.dataArray[indexPath.row];
    cell.textLabel.text = array[2];
    NSString * str = [array firstObject];
    
    //判断类型
    if ([str hasPrefix:MESSAGE_STR]) {
        cell.detailTextLabel.text=[str substringFromIndex:3];
    }else{
        if ([str hasPrefix:MESSAGE_IMAGESTR]) {
            cell.detailTextLabel.text=@"[图片]";
        }else{
            if ([str hasPrefix:MESSAGE_BIGIMAGESTR]) {
                cell.detailTextLabel.text=@"[表情]";
            }else{
                if ([str hasPrefix:MESSAGE_VOICE]) {
                    cell.detailTextLabel.text=@"[语音]";
                }else{
                    cell.detailTextLabel.text=@"未知消息";
                }
            }
            
        }
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //获取数据源
    NSArray*array=self.dataArray[indexPath.row];
    if ([[array lastObject] isEqualToString:@"[1]"]) {
        //单聊
        ChatViewController*vc=[[ChatViewController alloc]init];
        vc.hidesBottomBarWhenPushed=YES;
        vc.friendJid=[NSString stringWithFormat:@"%@@%@",array[2],DOMAIN];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        //群聊
        
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
