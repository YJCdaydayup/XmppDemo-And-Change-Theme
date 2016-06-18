//
//  RegisterManager.h
//  XmppDemo
//
//  Created by 杨力 on 14/6/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegisterManager : NSObject

@property (nonatomic,copy) NSString * userName;
@property (nonatomic,copy) NSString * nickName;

@property (nonatomic,strong) UIImage * headerImage;
@property (nonatomic,copy) NSString * birthday;
@property (nonatomic,copy) NSString * sex;

@property (nonatomic,copy) NSString * phoneNumber;
@property (nonatomic,copy) NSString * passWord;

@property (nonatomic,copy) NSString * qmd;
@property (nonatomic,copy) NSString * address;

//单例
+(id)shareManager;


@end
