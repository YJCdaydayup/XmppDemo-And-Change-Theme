//
//  ZCFaceToolBar.m
//  text
//
//  Created by 张诚 on 14-10-6.
//  Copyright (c) 2014年 zhangcheng. All rights reserved.
//

#import "ZCFaceToolBar.h"
#import "Photo.h"
#import "ZCChatAVAdioPlay.h"
@implementation ZCFaceToolBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (NSArray *)weimiEmojis
{
    NSMutableArray * emojis = [NSMutableArray array];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"emojo"
                                                          ofType:@"plist"];
    NSArray *arr = [NSArray arrayWithContentsOfFile:plistPath];
    for (int i = 0; i < arr.count; i++)
    {
        NSDictionary * dic = [arr objectAtIndex:i];
        EmojiInfo * emoji = [[EmojiInfo alloc] init];
        emoji.emojiValue = [dic objectForKey:@"key"];
        emoji.emojiThumbName = [dic objectForKey:@"picture"];
        [emojis addObject:emoji];
    }
    
    return emojis;
}
-(void)themeNotification{
    self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    UIEdgeInsets insets = UIEdgeInsetsMake(40, 0, 40, 0);
    
    [self setBackgroundImage:[[self imageConfig:@"chat_bottom_bg@2x.png"] resizableImageWithCapInsets:insets] forToolbarPosition:0 barMetrics:0];
    [self setShadowImage:[self imageConfig:@"chat_bottom_shadow@2x.png"] forToolbarPosition:UIBarPositionAny];
    textView.textViewBackgroundImage.image=[self imageConfig:@"chat_bottom_textfield@2x.png"];
    
    
    if (!isOpenVoide) {
        [self viewWithTag:3981].hidden=NO;
        [voiceButton setBackgroundImage:[self imageConfig:@"chat_bottom_keyboard_nor@2x.png"] forState:UIControlStateNormal];
        textView.hidden=YES;
    }else{
        [voiceButton setBackgroundImage:[self imageConfig:@"chat_bottom_voice_nor@2x.png"] forState:UIControlStateNormal];
        
    }
    
    if (keyboardIsShow) {
        [faceButton setBackgroundImage:[self imageConfig:@"chat_bottom_keyboard_nor@2x.png"] forState:UIControlStateNormal];
    }else{
        
        [faceButton setBackgroundImage:[self imageConfig:@"chat_bottom_smile_nor@2x.png"] forState:UIControlStateNormal];
        
    }
    
    
    [sendButton setBackgroundImage:[self imageConfig:@"chat_bottom_up_nor@2x.png"] forState:UIControlStateNormal];
}
-(UIImage*)imageConfig:(NSString*)pathName{
    return [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@%@",self.path,pathName]];
}
-(id)initWithFrame:(CGRect)frame voice:(UIButton*)voice ViewController:(UIViewController*)vc Block:(void(^)(NSString*,NSString*))a{
    self.BlockValue=a;
    self = [super initWithFrame:CGRectMake(0, vc.view.bounds.size.height - toolBarHeight, vc.view.bounds.size.width, 45)];
    if (self) {
        //初始化为NO
        keyboardIsShow=NO;
        self.vc=vc;
        
        self.path=[NSString stringWithFormat:@"%@%@/",LIBPATH,[[NSUserDefaults standardUserDefaults] objectForKey:THEME]];
        //配置音频按钮
        UIImageView*imageView=[[UIImageView alloc]initWithFrame:CGRectMake(40, 12,[UIScreen mainScreen].bounds.size.width-110, 30)];
        imageView.image=[self imageConfig:@"chat_bottom_textfield@2x.png"];
        imageView.userInteractionEnabled=YES;
        imageView.tag=3981;
        imageView.hidden=YES;
        [self addSubview:imageView];
        UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(0, -10, 210, 45)];
        label.textAlignment=NSTextAlignmentCenter;
        label.font=[UIFont boldSystemFontOfSize:15];
        label.text=@"按住说话";
        label.textColor=[UIColor blueColor];
        label.tag=98;
        [imageView  addSubview:label];
        
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
            UILongPressGestureRecognizer*longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
            [imageView addGestureRecognizer:longPress];
            
            
        }else {
            UIAlertView*al=[[UIAlertView alloc]initWithTitle:@"提示" message:@"当前麦克风不可用" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [al show];
        }
        
        
        self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        UIEdgeInsets insets = UIEdgeInsetsMake(40, 0, 40, 0);
        [self setBackgroundImage:[[self imageConfig:@"chat_bottom_bg@2x.png"] resizableImageWithCapInsets:insets] forToolbarPosition:0 barMetrics:0];
        
        [self setShadowImage:[self imageConfig:@"chat_bottom_shadow@2x.png"] forToolbarPosition:UIBarPositionAny];
        [self setBarStyle:UIBarStyleBlack];
        
        //可以自适应高度的文本输入框
        textView = [[UIExpandingTextView alloc] initWithFrame:CGRectMake(40, 12, [UIScreen mainScreen].bounds.size.width-110,45)];
        textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(4.0f, 0.0f, 10.0f, 0.0f);
        [textView.internalTextView setReturnKeyType:UIReturnKeySend];
        textView.delegate = self;
        textView.tag=4798;
        textView.font=[UIFont systemFontOfSize:15];
        textView.autoresizingMask= UIViewAutoresizingNone;
        textView.maximumNumberOfLines=5;
        textView.internalTextView.autocapitalizationType=UITextAutocapitalizationTypeNone ;
        //chat_bottom_textfield@2x.png
        textView.textViewBackgroundImage.image=[self imageConfig:@"chat_bottom_textfield@2x.png"];
        [self addSubview:textView];
        //音频按钮
        voiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        voiceButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin;
        [voiceButton setBackgroundImage:[self imageConfig:@"chat_bottom_voice_nor@2x.png"] forState:UIControlStateNormal];
        [voiceButton addTarget:self action:@selector(voiceChange) forControlEvents:UIControlEventTouchUpInside];
        voiceButton.frame = CGRectMake(5,self.bounds.size.height-38.0f,buttonWh+2,buttonWh+2);
        [self addSubview:voiceButton];
        
        //表情按钮
        faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        faceButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin;
        [faceButton setBackgroundImage:[self imageConfig:@"chat_bottom_smile_nor@2x.png"] forState:UIControlStateNormal];
        faceButton.tag=6590;
        [faceButton addTarget:self action:@selector(disFaceKeyboard) forControlEvents:UIControlEventTouchUpInside];
        faceButton.frame = CGRectMake(self.bounds.size.width - 70.0f,self.bounds.size.height-38.0f,buttonWh,buttonWh);
        [self addSubview:faceButton];
        
        //表情按钮
        sendButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        // [sendButton setTitle:@"图片" forState:UIControlStateNormal];
        [sendButton setBackgroundImage:[self imageConfig:@"chat_bottom_up_nor@2x.png"] forState:UIControlStateNormal];
        sendButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin;
        [sendButton addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
        sendButton.frame = CGRectMake(self.bounds.size.width - 40.0f,self.bounds.size.height-38.0f,buttonWh+4,buttonWh);
        [self addSubview:sendButton];
        
        //给键盘注册通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(inputKeyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(inputKeyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
        
        //创建表情SDK
        //初始化
        [StickerConfig registerApp:@"45309e3410d69d7d" withSecret:@"534f62d20a540a95e2456aea9b9adbfc"];
        
        NSMutableArray * arr = [NSMutableArray array];
        [arr addObjectsFromArray:[self weimiEmojis]];
        [arr addObjectsFromArray:[EmojiInfo defualtEmojis]];
        stickerInputView = [[StickerInputView alloc] initWithEmoji:arr] ;
        stickerInputView.delegate = self;
    }
    return self;
    
    
}
#pragma mark -
-(void)longPress:(UILongPressGestureRecognizer*)longPress{
    if (longPress.state==UIGestureRecognizerStateBegan) {
        NSLog(@"已经按下");
        UILabel*temp= (UILabel*)[longPress.view viewWithTag:98];
        temp.textColor=[UIColor whiteColor];
        temp.text=@"松开发送";
        //开始录音
        
        [[ZCChatAVAdioPlay sharedInstance] startRecording];
    }
    if (longPress.state==UIGestureRecognizerStateEnded) {
        NSLog(@"已经松开");
        UILabel*temp=(UILabel*)[longPress.view viewWithTag:98];
        temp.textColor=[UIColor blueColor];
        temp.text=@"按住说话";
        
        //结束录音
        
        [  [ZCChatAVAdioPlay sharedInstance] endRecordingWithBlock:^(NSString *aa) {
            self.BlockValue(MESSAGE_VOICE,aa);
            // NSLog(@"amr转码base64，可以进行发送数据%@",aa);
        }];
        
    }
    
}


#pragma mark UIExpandingTextView delegate
//改变键盘高度
-(void)expandingTextView:(UIExpandingTextView *)expandingTextView willChangeHeight:(float)height
{
    /* Adjust the height of the toolbar when the input component expands */
    float diff = (textView.frame.size.height - height);
    CGRect r = self.frame;
    r.origin.y += diff;
    r.size.height -= diff;
    self.frame = r;
    if (expandingTextView.text.length>2) {
        NSLog(@"最后输入的是表情%@",[textView.text substringFromIndex:textView.text.length-2]);
        textView.internalTextView.contentOffset=CGPointMake(0,textView.internalTextView.contentSize.height-textView.internalTextView.frame.size.height );
    }
    
}
//return方法
- (BOOL)expandingTextViewShouldReturn:(UIExpandingTextView *)expandingTextView{
    if (textView.text.length>0) {
        self.BlockValue(MESSAGE_STR,textView.text);
        [textView clearText];
    }
    
    return YES;
}
//文本是否改变
-(void)expandingTextViewDidChange:(UIExpandingTextView *)expandingTextView
{
    
}

#pragma mark 选择相册相机
-(void)sendAction{
    [self dismissKeyBoard];
    //发送图片
    LXActivity*lx=[[LXActivity alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"cancel" ShareButtonTitles:@[@"相机",@"相册"] withShareButtonImagesName:@[@"icon_code.png",@"icon_phone.png"]];
    // [lx showInView:self.vc.view];
    [self.vc.view addSubview:lx];
    
}
#pragma mark - LXActivityDelegate

- (void)didClickOnImageIndex:(NSInteger *)imageIndex
{
    NSLog(@"%d",(int)imageIndex);
    
    UIImagePickerController*picker=[[UIImagePickerController alloc]init];
    if (imageIndex) {
        BOOL isOpen=[UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
        if (isOpen) {
            picker.sourceType=UIImagePickerControllerSourceTypeCamera;
        }
    }
    picker.delegate=self;
    [self.vc presentViewController:picker animated:YES completion:nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage*image=[info objectForKey:UIImagePickerControllerOriginalImage];
    //图片转文字
    NSString*str=[Photo image2String:image];
    self.BlockValue(MESSAGE_IMAGESTR,str);
    [self.vc dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.vc dismissViewControllerAnimated:YES completion:nil];
}

- (void)didClickOnCancelButton
{
    NSLog(@"didClickOnCancelButton");
}

-(void)voiceChange{
    //3981
    if (!isOpenVoide) {
        [self viewWithTag:3981].hidden=NO;
        [voiceButton setBackgroundImage:[self imageConfig:@"chat_bottom_keyboard_nor@2x.png"] forState:UIControlStateNormal];
        textView.hidden=YES;
    }else{
        
        [self viewWithTag:3981].hidden=YES;
        [voiceButton setBackgroundImage:[self imageConfig:@"chat_bottom_voice_nor@2x.png"] forState:UIControlStateNormal];
        textView.hidden=NO;
    }
    
    [self dismissKeyBoard];
    isOpenVoide=!isOpenVoide;
}
-(void)disFaceKeyboard{
    //如果直接点击表情，通过toolbar的位置来判断
    if (self.frame.origin.y== self.vc.view.bounds.size.height - toolBarHeight&&self.frame.size.height==toolBarHeight) {
        //在下面时候上来
        [UIView animateWithDuration:Time animations:^{
            self.frame = CGRectMake(0, self.vc.view.frame.size.height-keyboardHeight-toolBarHeight,  self.vc.view.bounds.size.width,toolBarHeight);
        }];
        [UIView animateWithDuration:Time animations:^{
            [stickerInputView showInView:self.vc.view emojiReceiver:textView.internalTextView viewController:self.vc animated:YES];
        }];
        [faceButton setBackgroundImage:[self imageConfig:@"chat_bottom_keyboard_nor@2x.png"] forState:UIControlStateNormal];
        return;
    }
    
    
    if (!keyboardIsShow) {
        //如果键盘没有显示，把表情隐藏掉
        [UIView animateWithDuration:Time animations:^{
            
            [stickerInputView showInView:self.vc.view emojiReceiver:textView.internalTextView viewController:self.vc animated:YES];
        }];
        [textView becomeFirstResponder];
        
    }else{
        [textView resignFirstResponder];
        self.frame = CGRectMake(0, self.vc.view.frame.size.height-keyboardHeight-self.frame.size.height,  self.vc.view.bounds.size.width,self.frame.size.height);
        //键盘显示的时候，toolbar需要还原到正常位置，并显示表情
        [UIView animateWithDuration:Time animations:^{
            [stickerInputView showInView:self.vc.view emojiReceiver:textView.internalTextView viewController:self.vc animated:YES];
        }];
        
    }
    
}
#pragma mark 隐藏键盘
-(void)dismissKeyBoard{
    //键盘显示的时候，toolbar需要还原到正常位置，并显示表情
    [UIView animateWithDuration:Time animations:^{
        self.frame = CGRectMake(0, self.vc.view.frame.size.height-self.frame.size.height,  self.vc.view.bounds.size.width,self.frame.size.height);
    }];
    
    [textView resignFirstResponder];
    [faceButton setBackgroundImage:[self imageConfig:@"chat_bottom_smile_nor@2x.png"] forState:UIControlStateNormal];
    
    [stickerInputView dismiss];
    keyboardIsShow=NO;
    
}
#pragma mark 监听键盘的显示与隐藏
-(void)inputKeyboardWillShow:(NSNotification *)notification{
    //键盘显示，设置toolbar的frame跟随键盘的frame
    CGFloat animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:animationTime animations:^{
        CGRect keyBoardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        if (self.frame.size.height>45) {
            self.frame = CGRectMake(0, keyBoardFrame.origin.y-20-self.frame.size.height-[ZCControl isIOS7],  self.vc.view.bounds.size.width,self.frame.size.height);
        }else{
            self.frame = CGRectMake(0, keyBoardFrame.origin.y-45-[ZCControl isIOS7],  self.vc.view.bounds.size.width,toolBarHeight);
        }
    }];
    [faceButton setBackgroundImage:[self imageConfig:@"chat_bottom_smile_nor@2x.png"] forState:UIControlStateNormal];
    keyboardIsShow=YES;
}
-(void)inputKeyboardWillHide:(NSNotification *)notification{
    [faceButton setBackgroundImage:[self imageConfig:@"chat_bottom_keyboard_nor@2x.png"] forState:UIControlStateNormal];
    keyboardIsShow=NO;
}
-(void)stickerInputView:(StickerInputView *)inputView didSelectSticker:(StickerInfo *)stickerInfo
{
    self.BlockValue(MESSAGE_BIGIMAGESTR,[stickerInfo stickerID]);
}

-(void)dealloc{
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
   
    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
