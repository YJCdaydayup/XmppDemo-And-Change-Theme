//
//  RootViewController.h
//  XmppDemo
//
//  Created by 杨力 on 14/6/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import <UIKit/UIKit.h>
//只用于为设置主题做了标准
@interface RootViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    
    UITableView * _tableView;
}

@property (nonatomic,copy) NSString * path;
@property (nonatomic,strong) NSMutableArray * dataArray;
-(void)createNotificationTheme;
@end
