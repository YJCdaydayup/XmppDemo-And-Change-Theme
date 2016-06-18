//
//  FriendCell.h
//  XmppDemo
//
//  Created by 杨力 on 17/6/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendCell : UITableViewCell
{
    //头像
    UIImageView * headerImageView;
    //昵称
    UILabel * nickName;
    //签名
    UILabel * qmdLabel;
    
}

@property (nonatomic,copy) NSString * userName;

//设置方法
-(void)config:(XMPPUserCoreDataStorageObject *)obj;

@end
