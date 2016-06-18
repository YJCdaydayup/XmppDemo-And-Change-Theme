//
//  PackageTableCell.m
//  StickerSDKDemo
//
//  Created by mike on 13-11-12.
//  Copyright (c) 2013年 dong mike. All rights reserved.
//

#import "PackageTableCell.h"

#import "UIImageView+AFNetworking.h"

#import "StickerConfig.h"


@interface PackageTableCell ()

@property (retain) UIImageView * packageThumbView;
@property (retain) UILabel * nameLabel;
@property (retain) UIImageView * markImageView;
@property (retain) UIButton * downloadButton;
@property (retain) UIProgressView * downloadProgressView;

@end


@implementation PackageTableCell

@synthesize packageInfo = _packageInfo;
@synthesize delegate;

@synthesize packageThumbView;
@synthesize nameLabel;
@synthesize markImageView;
@synthesize downloadButton;
@synthesize downloadProgressView;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.packageThumbView = [[UIImageView alloc] initWithFrame:CGRectMake(9, 7, 66, 66)];
        [self.packageThumbView setContentMode:UIViewContentModeScaleAspectFit];
        [self addSubview:self.packageThumbView];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 32, 200, 20)];
        self.nameLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.nameLabel];
        
        self.markImageView = [[UIImageView alloc] initWithFrame:CGRectMake(260, 28, 27, 23)];
        self.markImageView.image = [UIImage imageNamed:@"sticker_downloaded.png"];
        [self addSubview:self.markImageView];
        
        self.downloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.downloadButton addTarget:self action:@selector(onClickDownload:) forControlEvents:UIControlEventTouchUpInside];
        [self.downloadButton setBackgroundImage:[UIImage imageNamed:@"sticker_download_normal.png"] forState:UIControlStateNormal];
        [self.downloadButton setBackgroundImage:[UIImage imageNamed:@"sticker_download_pressed.png"] forState:UIControlStateHighlighted];
        [self.downloadButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.downloadButton.frame = CGRectMake(240, 25, 68, 30);
        [self addSubview:self.downloadButton];
        
        self.downloadProgressView = [[UIProgressView alloc] init];
        self.downloadProgressView.progressImage = [[UIImage imageNamed:@"sticker_download_progress.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
        self.downloadProgressView.trackImage = [UIImage imageNamed:@"sticker_download_tracker.png"];
        self.downloadProgressView.frame = CGRectMake(241, 31, 65, 18);
        self.downloadProgressView.progress = 0;
        [self addSubview:self.downloadProgressView];
        
        self.backgroundColor = [UIColor clearColor];
//        self.contentView.backgroundColor = [UIColor colorWithRed:242/255.0 green:244/255.0 blue:248/255.0 alpha:1.0];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDownloadProgress:) name:kDownloadProgressUpdated object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.packageThumbView = nil;
    self.nameLabel = nil;
    self.markImageView = nil;
    self.downloadButton = nil;
    self.downloadProgressView = nil;
    
    
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (PackageInfo *)packageInfo
{
    return _packageInfo;
}

- (void)setPackageInfo:(PackageInfo *)info
{
    if (_packageInfo != info)
    {
        
        _packageInfo = nil;
        
        _packageInfo =info ;
        
        self.nameLabel.text = self.packageInfo.packageName;
       
        [self.packageThumbView setImageWithURL:[NSURL URLWithString:self.packageInfo.packageThumbURL]];
    }
    
    [self updateDownload];
}

- (void)updateDownload
{
    if ([StickerConfig isDownloaded:self.packageInfo.packageID]) // 如果不是在线表情，则显示下载完成
    {
        self.markImageView.hidden = NO;
        self.downloadButton.hidden = YES;
        self.downloadProgressView.hidden = YES;
    }
    else if ([StickerConfig downloadProgress:self.packageInfo.packageID] != nil)
    {
        self.markImageView.hidden = YES;
        self.downloadButton.hidden = YES;
        self.downloadProgressView.hidden = NO;
        self.downloadProgressView.progress = [[StickerConfig downloadProgress:self.packageInfo.packageID] floatValue];
    }
    else
    {
        self.markImageView.hidden = YES;
        self.downloadButton.hidden = NO;
        self.downloadProgressView.hidden = YES;
    }
}

- (void)onClickDownload:(id)sender
{
    if (self.delegate != nil)
    {
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(cellClickDownload:)])
        {
            [self.delegate cellClickDownload:self];
        }
    }
}

- (void)onDownloadProgress:(NSNotification *)noti
{
    [self updateDownload];
}

@end
