//
//  MoreStickerViewController.m
//  StickerSDKDemo
//
//  Created by mike on 13-11-12.
//  Copyright (c) 2013年 dong mike. All rights reserved.
//

#import "MoreStickerViewController.h"
#import "PackageTableCell.h"
#import "PackageInfo.h"
#import "StickerConfig.h"
#import "StickerDetailViewController.h"
#import "StickerSettingViewController.h"
#import "UIImageView+AFNetworking.h"


#define iOS7                    (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0))
#define STATUS_BAR_HEIGHT       (iOS7?0:20)
#define LEFT_BAR_ITEM_SPACE   (iOS7 ? -10 : 0)


@interface MoreStickerViewController ()

@property (retain) UITableView * packageTableView;
@property (retain) NSArray * packageArray;
@property (retain) PackageInfo * bannerPackage;

@end

@implementation MoreStickerViewController

@synthesize packageTableView;
@synthesize packageArray;
@synthesize bannerPackage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.packageTableView = nil;
    self.packageArray = nil;
    self.bannerPackage = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor colorWithRed:242/255.0 green:244/255.0 blue:248/255.0 alpha:1.0];
    
    [self setTitle:@"更多表情"];
    
    // 返回
    {
        UIButton * b = [UIButton buttonWithType:UIButtonTypeCustom];
        [b setImage:[UIImage imageNamed:@"sticker_back.png"] forState:UIControlStateNormal];
        b.frame = CGRectMake(0, 0, 40, 30);
        [b addTarget:self action:@selector(onClickBack) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                            initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                            target:nil action:nil] ;
        negativeSpacer.width = LEFT_BAR_ITEM_SPACE;
        [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, [[UIBarButtonItem alloc] initWithCustomView:b], nil] animated:NO];
    }
    
    // 设置
    {
        UIButton * b = [UIButton buttonWithType:UIButtonTypeCustom];
        [b setImage:[UIImage imageNamed:@"sticker_setting.png"] forState:UIControlStateNormal];
        b.frame = CGRectMake(0, 0, 40, 30);
        [b addTarget:self action:@selector(onClickSetting) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:[[UIBarButtonItem alloc] initWithCustomView:b], nil] animated:NO];
    }
    
    int screenHeight = [UIScreen mainScreen].bounds.size.height;
    int screenWidth=[UIScreen mainScreen].bounds.size.width;
    self.packageTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, iOS7 ? screenHeight :(screenHeight - 64)) style:UITableViewStylePlain] ;
    [self.view addSubview:self.packageTableView];
    self.packageTableView.delegate = self;
    self.packageTableView.dataSource = self;
//    self.packageTableView.backgroundColor = [UIColor colorWithRed:242/255.0 green:244/255.0 blue:248/255.0 alpha:1.0];
    
    if ([self.packageTableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.packageTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDownloadStatusChanged:) name:kDownloadStatusUpdated object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onOnlinePackagesChanged:) name:kOnlinePackageUpdated object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLocalPackagesUpdated:) name:kLocalPackagesUpdated object:nil];
    
    self.packageArray = [StickerConfig onlinePackages];
    self.bannerPackage = [StickerConfig bannerPackage];
}

- (void)viewDidUnload
{
    self.packageTableView = nil;
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
        [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init] ];
        self.navigationController.navigationBar.clipsToBounds = YES;
    }
}

- (void)onClickBack
{
   
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)onClickSetting
{
    StickerSettingViewController * controller = [[StickerSettingViewController alloc] initWithNibName:@"StickerSettingViewController" bundle:nil] ;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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


#pragma mark - tableview delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return packageArray.count + (self.bannerPackage ? 1 : 0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 && self.bannerPackage != nil)
        return 160;
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int index = indexPath.row;
    if (index == 0 && self.bannerPackage)
    {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"banner"];
        if (cell == nil)
        {
            cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"banner"] ;
            
            UIImageView * bannerImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 160)];
            bannerImage.tag = 200;
            bannerImage.contentMode = UIViewContentModeScaleAspectFill;
            [cell addSubview:bannerImage];
        }
        
        UIImageView * bannerImage = (UIImageView *)[cell viewWithTag:200];
        [bannerImage setImageWithURL:[NSURL URLWithString:self.bannerPackage.packageBannerURL]];
        
        return cell;
    }
    
    if (self.bannerPackage)
        index--;
    
    PackageInfo * package = [self.packageArray objectAtIndex:index];
    PackageTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"packagecell"];
    if (cell == nil)
    {
        cell = [[PackageTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"packagecell"] ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.packageInfo = package;
    cell.delegate = self;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    int index = indexPath.row;
    if (index == 0 && self.bannerPackage)
    {
        StickerDetailViewController * controller = [[StickerDetailViewController alloc] initWithPackageInfo:self.bannerPackage] ;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else
    {
        if (self.bannerPackage)
            index--;
        
        StickerDetailViewController * controller = [[StickerDetailViewController alloc] initWithPackageInfo:[self.packageArray objectAtIndex:index]];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)cellClickDownload:(PackageTableCell *)cell
{
    [StickerConfig downloadPackage:cell.packageInfo];
}


#pragma mark - download status changed

- (void)onDownloadStatusChanged:(id)sender
{
    self.packageArray = [StickerConfig onlinePackages];
    self.bannerPackage = [StickerConfig bannerPackage];
    [self.packageTableView reloadData];
}

- (void)onOnlinePackagesChanged:(NSNotification *)noti
{
    self.packageArray = [StickerConfig onlinePackages];
    self.bannerPackage = [StickerConfig bannerPackage];
    [self.packageTableView reloadData];
}

- (void)onLocalPackagesUpdated:(NSNotification *)noti
{
    self.packageArray = [StickerConfig onlinePackages];
    self.bannerPackage = [StickerConfig bannerPackage];
    [self.packageTableView reloadData];
}

@end
