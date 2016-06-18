//
//  FriendCell.m
//  XmppDemo
//
//  Created by 杨力 on 17/6/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "FriendCell.h"

@implementation FriendCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
        [self createView];
    }
    
    return self;
}

-(void)createView{
    
    
    
    headerImageView=[ZCControl createImageViewWithFrame:CGRectMake(10, 10, 40, 40) ImageName:@"logo_2.png"];
    headerImageView.layer.cornerRadius=20;
    headerImageView.layer.masksToBounds=YES;
    [self.contentView addSubview:headerImageView];
    
    nickName=[ZCControl createLabelWithFrame:CGRectMake(60, 10, 200, 20) Font:15 Text:nil];
    [self.contentView addSubview:nickName];
    
    qmdLabel=[ZCControl createLabelWithFrame:CGRectMake(60, 30, 200, 20) Font:10 Text:nil];
    qmdLabel.textColor=[UIColor grayColor];
    [self.contentView addSubview:qmdLabel];
    
}

-(void)config:(XMPPUserCoreDataStorageObject *)obj{
    
    //获取账号
    self.userName = obj.jidStr;
    
    //获取本地上次取出来的用户头像
    UIImage * image = [[ZCXMPPManager sharedInstance]avatarForUser:obj];
    if(image){
        headerImageView.image = image;
    }
    nickName.text = self.userName;
    qmdLabel.text = nil;
    
    //获取用户Vcard
    NSString * str = [[self.userName componentsSeparatedByString:@"@"]firstObject];
    [[ZCXMPPManager sharedInstance]friendsVcard:str Block:^(BOOL isOk, XMPPvCardTemp *vCard) {
        
        if(vCard.photo){
            headerImageView.image = [UIImage imageWithData:vCard.photo];
        }
        if(vCard.nickname){
            nickName.text = CODE(vCard.nickname);
        }else{
            nickName.text = self.userName;
        }
        NSString * qmd = [[vCard elementForName:QMD]stringValue];
        if(qmd){
            qmdLabel.text = CODE(qmd);
        }else{
            qmdLabel.text = @"nothing";
        }
        
    }];
    
    
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
