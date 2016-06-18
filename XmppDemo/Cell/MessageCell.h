//
//  MessageCell.h
//  XmppDemo
//
//  Created by 杨力 on 18/6/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StickerImageView.h"//大表情
@interface MessageCell : UITableViewCell{
    
    //左边是自己
    UIImageView * leftHeaderImageView;//左边头像
    UIImageView * leftBubbleImageView;//左边气泡
    UILabel * leftMessageLabel;//左边文字
    UIImageView * leftPhoneImageView;//左边图片
    StickerImageView * leftStickerImageView;//左边大表情
    UIButton * leftVoiceButton;//左边语音

    
    //右边是对方
    UIImageView * rightHeaderImageView;//右边头像
    UIImageView * rightBubbleImageView;//右边气泡
    UILabel * rightMessageLabel;//右边文字
    UIImageView * rightPhoneImageView;//右边图片
    StickerImageView * rightStickerImageView;//右边大表情
    UIButton * rightVoiceButton;//右边语音
}

-(void)configFriendImage:(UIImage*)leftImage myImage:(UIImage*)rightImage message:(XMPPMessageArchiving_Message_CoreDataObject*)object;

@end
