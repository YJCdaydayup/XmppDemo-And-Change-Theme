//
//  StickerDetailViewController.m
//  StickerSDKDemo
//
//  Created by mike on 13-11-14.
//  Copyright (c) 2013年 dong mike. All rights reserved.
//

#import "StickerDetailViewController.h"

#import <QuartzCore/QuartzCore.h>
#import "StickerConfig.h"
#import "UIImageView+AFNetworking.h"

#define iOS7                    (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0))
#define LEFT_BAR_ITEM_SPACE   (iOS7 ? -10 : 0)

@interface StickerDetailViewController ()

@property (retain) PackageInfo * package;

@property (retain) UIScrollView * contentScrollView;
@property (retain) UIImageView * bannerImage;
@property (retain) UILabel * descLabel;
@property (retain) UIButton * downloadButton;
@property (retain) UIImageView * previewImage;

@end

@implementation StickerDetailViewController

@synthesize contentScrollView;
@synthesize bannerImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

-(id)initWithPackageInfo:(PackageInfo *)info
{
    self = [self initWithNibName:@"StickerDetailViewController" bundle:nil];
    if (self != nil)
    {
        self.package = info;
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.package = nil;
    self.contentScrollView = nil;
    self.bannerImage = nil;
    self.descLabel = nil;
    self.downloadButton = nil;
    self.previewImage = nil;
    
  
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:self.package.packageName];
    
    UIButton * b = [UIButton buttonWithType:UIButtonTypeCustom];
    [b setImage:[UIImage imageNamed:@"sticker_back.png"] forState:UIControlStateNormal];
    b.frame = CGRectMake(0, 0, 40, 30);
    [b addTarget:self action:@selector(onClickBack) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                        initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                        target:nil action:nil] ;
    negativeSpacer.width = LEFT_BAR_ITEM_SPACE;
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, [[UIBarButtonItem alloc] initWithCustomView:b], nil] animated:NO];
    
    self.contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height - (iOS7 ? 0:64))];
    [self.view addSubview:self.contentScrollView];
    self.contentScrollView.backgroundColor = [UIColor colorWithWhite:255/255.0 alpha:1.0];
    
    int startY = 10;
    self.bannerImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, startY, 300, 130) ];
    [self.bannerImage setImageWithURL:[NSURL URLWithString:self.package.packageBannerURL]];
    [self.contentScrollView addSubview:self.bannerImage];
    self.bannerImage.layer.cornerRadius = 10;
    self.bannerImage.layer.masksToBounds = YES;
    self.bannerImage.layer.borderColor = [UIColor colorWithWhite:0xb1/255.0 alpha:1.0].CGColor;
    self.bannerImage.layer.borderWidth = 1.0;
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bannerImage.frame.size.height - 30, 320, 30)];
    label.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:16];
    label.text = [NSString stringWithFormat:@"    %@", self.package.packageName];
    [self.bannerImage addSubview:label];
    
    startY += 140;
    
    UIFont * font = [UIFont systemFontOfSize:14];
    NSString * strDesc = self.package.packageDescription;
    CGSize newSize = [strDesc sizeWithFont:font
        constrainedToSize:CGSizeMake(300, 1000)
            lineBreakMode:NSLineBreakByWordWrapping];
    self.descLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, startY, 300, newSize.height + 10)];
    self.descLabel.backgroundColor = [UIColor clearColor];
    self.descLabel.font = font;
    self.descLabel.numberOfLines = 0;
    self.descLabel.font = [UIFont boldSystemFontOfSize:14];
    self.descLabel.textColor = [UIColor grayColor];
    self.descLabel.text = strDesc;
    [self.contentScrollView addSubview:self.descLabel];
    startY += (newSize.height + 20);
    
    self.downloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.downloadButton.frame = CGRectMake(7, startY, 305, 43);
    [self.contentScrollView addSubview:self.downloadButton];
    [self.downloadButton addTarget:self action:@selector(onClickDownload:) forControlEvents:UIControlEventTouchUpInside];
    startY += 48;
    [self updateDownloadButton];
    
    UIImageView * previewBg =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sticker_preview_bg"]];
    previewBg.frame = CGRectMake(7, startY, 305, 254);
    [self.contentScrollView addSubview:previewBg];
    
    self.previewImage =[[UIImageView alloc] initWithFrame:CGRectMake(10, startY + 25, 300, 222)];
    [self.previewImage setImageWithURL:[NSURL URLWithString:self.package.packagePreviewURL]];
    [self.previewImage setContentMode:UIViewContentModeScaleAspectFit];
    [self.contentScrollView addSubview:self.previewImage];
    
    self.contentScrollView.contentSize = CGSizeMake(0, startY + 270);
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDownloadStatusChanged:) name:kDownloadStatusUpdated object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onOnlinePackagesChanged:) name:kDownloadProgressUpdated object:nil];
}

- (void)viewDidUnload
{
    self.contentScrollView = nil;
    self.bannerImage = nil;
    self.descLabel = nil;
    self.downloadButton = nil;
    self.previewImage = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (iOS7)
    {
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithWhite:0x56/255.0 alpha:1.0];
    }
    else
    {
        [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setBackgroundColor:[UIColor colorWithWhite:0x56/255.0 alpha:1.0]];
        [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
        self.navigationController.navigationBar.clipsToBounds = YES;
    }
}

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    if (!titleView) {
        titleView = [[UILabel alloc] initWithFrame:CGRectZero];
        titleView.backgroundColor = [UIColor clearColor];
        titleView.font = [UIFont boldSystemFontOfSize:20.0];
        titleView.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        
        titleView.textColor = [UIColor whiteColor]; // Change to desired color
        
        self.navigationItem.titleView = titleView;
    }
    titleView.text = title;
    [titleView sizeToFit];
}

- (void)updateDownloadButton
{
    if ([StickerConfig downloadProgress:self.package.packageID])
    {
        [self.downloadButton setBackgroundImage:[UIImage imageNamed:@"sticker_downloaded_bg.png"] forState:UIControlStateNormal];
        float progress = [[StickerConfig downloadProgress:self.package.packageID] floatValue];
        [self.downloadButton setImage:nil forState:UIControlStateNormal];
        [self.downloadButton setTitle:[NSString stringWithFormat:@"下载中 %d%%", (int)(100 * progress)] forState:UIControlStateNormal];
        [self.downloadButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.downloadButton.enabled = NO;
        [[self.downloadButton titleLabel] setFont:[UIFont boldSystemFontOfSize:16]];
    }
    else if ([StickerConfig isDownloaded:self.package.packageID])
    {
        [self.downloadButton setBackgroundImage:[UIImage imageNamed:@"sticker_downloaded_bg.png"] forState:UIControlStateNormal];
        [self.downloadButton setImage:nil forState:UIControlStateNormal];
        [self.downloadButton setTitle:@"已下载" forState:UIControlStateNormal];
        [self.downloadButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.downloadButton.enabled = NO;
        [[self.downloadButton titleLabel] setFont:[UIFont boldSystemFontOfSize:16]];
    }
    else
    {
        [self.downloadButton setBackgroundImage:[UIImage imageNamed:@"sticker_download_bg.png"] forState:UIControlStateNormal];
        [self.downloadButton setTitle:@"下 载" forState:UIControlStateNormal];
        [self.downloadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [[self.downloadButton titleLabel] setFont:[UIFont boldSystemFontOfSize:16]];
    }
}

-(void)onDownloadStatusChanged:(NSNotification *)noti
{
    [self updateDownloadButton];
}

-(void)onOnlinePackagesChanged:(NSNotification *)noti
{
    [self updateDownloadButton];
}

- (void)onClickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onClickDownload:(id)sender
{
    [StickerConfig downloadPackage:self.package];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
