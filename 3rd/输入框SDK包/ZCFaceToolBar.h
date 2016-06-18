//
//  ZCFaceToolBar.h
//  text
//
//  Created by 张诚 on 14-10-6.
//  Copyright (c) 2014年 zhangcheng. All rights reserved.
//
/*版本说明  iOS研究院 305044955
1.3 修改了部分iOS8适配问题
 
1.2更名为ZCFaceToolBar，并且增加了部分类支持ARC
 如果是xcode6会报x86_64的错误，需要在build setting中设置 valid Architectures去除掉arm64，并且把Build Active Architecture only改为NO
1.1faceToolBar
 添加了表情输入和选择照片
1.0faceToolBar
 实现了文字语音输入
 
 集成说明：
 需要添加系统库
 libz quartzCore AVFoundation  如果你的xcode还在5.0，请添加imageIO
 由于万恶的jsonkit不支持ARC，所以我们需要把jsonkit标记一下-fno-objc-arc
 示例代码
 ZCFaceToolBar*toolBar=[[ZCFaceToolBar alloc]initWithFrame:CGRectMake(0, 100, 320, 44) voice:nil ViewController:self Block:^(NSString *xx, NSString *xx1) {
 
 }];
 [self.view addSubview:toolBar];
 
 */

#define Time  0.25

#define  keyboardHeight 216
#define  toolBarHeight 45
#define  choiceBarHeight 35
#define  facialViewWidth 300
#define facialViewHeight 170
#define  buttonWh 34


#import <UIKit/UIKit.h>
#import "UIExpandingTextView.h"
/****表情SDK***/
#import "StickerInputView.h"
#import "StickerImageView.h"
#import "StickerInfo.h"
#import "EmojiInfo.h"
#import "StickerConfig.h"
#import "LXActivity.h"
@interface ZCFaceToolBar : UIToolbar<UIExpandingTextViewDelegate,UIScrollViewDelegate,StickerInputViewDelegate,LXActivityDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIExpandingTextView *textView;//文本输入框
    UIButton *faceButton ;
    UIButton *voiceButton;
    UIButton *sendButton;
    BOOL keyboardIsShow;//键盘是否显示
    
    BOOL isOpenVoide;
    
    //表情SDK的输入界面
    StickerInputView * stickerInputView;
    
}
//传值的block 第一个参数是标示[1]  第二个参数是内容
@property(nonatomic,copy)void(^BlockValue)(NSString*,NSString*);
@property(nonatomic,assign)UIViewController*vc;
//记录图片路径
@property(nonatomic,copy)NSString*path;

-(void)dismissKeyBoard;
-(id)initWithFrame:(CGRect)frame voice:(UIButton*)voice ViewController:(UIViewController*)vc Block:(void(^)(NSString*,NSString*))a;
@end
