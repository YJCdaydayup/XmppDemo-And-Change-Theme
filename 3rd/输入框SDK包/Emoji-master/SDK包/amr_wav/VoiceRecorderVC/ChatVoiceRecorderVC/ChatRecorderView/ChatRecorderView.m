//
//  ChatRecorderView.m
//  Jeans
//
//  Created by Jeans on 3/24/13.
//  Copyright (c) 2013 Jeans. All rights reserved.
//

#import "ChatRecorderView.h"

#define kTrashImage1         [UIImage imageNamed:@"recorder_trash_can0.png"]
#define kTrashImage2         [UIImage imageNamed:@"recorder_trash_can1.png"]
#define kTrashImage3         [UIImage imageNamed:@"recorder_trash_can2.png"]

@interface ChatRecorderView(){
    NSArray         *peakImageAry;
    NSArray         *trashImageAry;
    BOOL            isPrepareDelete;
    BOOL            isTrashCanRocking;
}

@end

@implementation ChatRecorderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initilization];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initilization];
    }
    return self;
}

- (void)initilization{
    //初始化音量peak峰值图片数组
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 20)];
    label.text = @"手指移动到此，取消录音";
    label.font = [UIFont systemFontOfSize:12];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];

    peakImageAry = [[NSArray alloc]initWithObjects:
                    [UIImage imageNamed:@"speaker_0.png"],
                    [UIImage imageNamed:@"speaker_1.png"],
                    [UIImage imageNamed:@"speaker_2.png"],
                    [UIImage imageNamed:@"speaker_3.png"], nil];
    trashImageAry = [[NSArray alloc]initWithObjects:kTrashImage1,kTrashImage2,kTrashImage3,kTrashImage2, nil];
}



#pragma mark -还原显示界面
- (void)restoreDisplay{
    //还原录音图
    _peakMeterIV.image = [peakImageAry objectAtIndex:0];
    //停止震动
    [self rockTrashCan:NO];
    //还原倒计时文本
    _countDownLabel.text = @"";
}

#pragma mark - 是否准备删除
- (void)prepareToDelete:(BOOL)_preareDelete{
    if (_preareDelete != isPrepareDelete) {
        isPrepareDelete = _preareDelete;
        [self rockTrashCan:isPrepareDelete];
    }
}
#pragma mark - 是否摇晃垃圾桶
- (void)rockTrashCan:(BOOL)_isTure{
    if (_isTure != isTrashCanRocking) {
        isTrashCanRocking = _isTure;
        if (isTrashCanRocking) {
            //摇晃
            _trashCanIV.animationImages = trashImageAry;
            _trashCanIV.animationRepeatCount = 0;
            _trashCanIV.animationDuration = 1;
            [_trashCanIV startAnimating];
        }else{
            //停止
            if (_trashCanIV.isAnimating)
                [_trashCanIV stopAnimating];
            _trashCanIV.animationImages = nil;
            _trashCanIV.image = kTrashImage1;
        }
    }
}


#pragma mark - 更新音频峰值
- (void)updateMetersByAvgPower:(float)_avgPower{
    //-160表示完全安静，0表示最大输入值
    //
    NSInteger imageIndex = 0;
    if (_avgPower >= -40 && _avgPower < -30)
        imageIndex = 1;
    else if (_avgPower >= -30 && _avgPower < -25)
        imageIndex = 2;
    else if (_avgPower >= -25)
        imageIndex = 3;
    
    _peakMeterIV.image = [peakImageAry objectAtIndex:imageIndex];
}

@end
