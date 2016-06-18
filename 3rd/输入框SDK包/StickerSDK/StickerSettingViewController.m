//
//  StickerSettingViewController.m
//  StickerSDKDemo
//
//  Created by mike on 13-11-19.
//  Copyright (c) 2013年 dong mike. All rights reserved.
//

#import "StickerSettingViewController.h"
#import "PackageInfo.h"
#import "StickerConfig.h"


#define iOS7                    (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0))
#define LEFT_BAR_ITEM_SPACE   (iOS7 ? -10 : 0)


@interface StickerSettingViewController ()

@property (retain) NSMutableArray * localStickers;
@property (retain) UITableView * packageTable;
@property (retain) PackageInfo * removePackage;
@property (retain) UIButton * backButton;
@property (retain) UIButton * editButton;

@end

@implementation StickerSettingViewController

@synthesize localStickers;
@synthesize packageTable;
@synthesize removePackage;
@synthesize backButton;
@synthesize editButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.localStickers = nil;
    self.packageTable = nil;
    self.removePackage = nil;
    self.backButton = nil;
    self.editButton = nil;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"管理表情"];
    
    // 返回
    {
        self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.backButton setImage:[UIImage imageNamed:@"sticker_back.png"] forState:UIControlStateNormal];
        self.backButton.frame = CGRectMake(0, 0, 40, 30);
        [self.backButton addTarget:self action:@selector(onClickBack) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                            initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                            target:nil action:nil] ;
        negativeSpacer.width = LEFT_BAR_ITEM_SPACE;
        [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, [[UIBarButtonItem alloc] initWithCustomView:self.backButton] , nil] animated:NO];
    }
    
    {
        self.editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.editButton setImage:[UIImage imageNamed:@"sticker_order.png"] forState:UIControlStateNormal];
        self.editButton.frame = CGRectMake(0, 0, 40, 30);
        [self.editButton addTarget:self action:@selector(onClickEdit) forControlEvents:UIControlEventTouchUpInside];
        
        [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:self.editButton]];
    }
    
    self.localStickers = [NSMutableArray arrayWithArray:[StickerConfig localPackages]];
    
    self.packageTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height - (iOS7 ? 0:64)) style:UITableViewStylePlain];
    self.packageTable.delegate = self;
    self.packageTable.dataSource = self;
    [self.view addSubview:self.packageTable];
    if ([self.packageTable respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.packageTable setSeparatorInset:UIEdgeInsetsZero];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLocalChanged:) name:kLocalPackagesUpdated object:nil];
}

- (void)viewDidUnload
{
    self.packageTable = nil;
    self.removePackage = nil;
    self.backButton = nil;
    self.editButton = nil;
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

- (void)onClickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onClickEdit
{
    if (self.packageTable.isEditing)
    {
        self.backButton.hidden = NO;
        [self.editButton setImage:[UIImage imageNamed:@"sticker_order.png"] forState:UIControlStateNormal];
    }
    else
    {
        self.backButton.hidden = YES;
        [self.editButton setImage:[UIImage imageNamed:@"sticker_complete.png"] forState:UIControlStateNormal];
    }
    
    [self.packageTable setEditing:!self.packageTable.editing];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onLocalChanged:(NSNotification *)noti
{
    self.localStickers = [NSMutableArray arrayWithArray:[StickerConfig localPackages]];
    [self.packageTable reloadData];
}


#pragma mark - tableview delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.localStickers.count;
}

- (UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PackageSettingCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil)
    {
        cell = [[PackageSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell" ];
        cell.backgroundColor = [UIColor clearColor];
        cell.delegate = self;
    }
    cell.package = [self.localStickers objectAtIndex:indexPath.row];
    return cell;
}

- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

- (BOOL) tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void) tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSInteger sourceRow = sourceIndexPath.row;
    NSInteger destRow = destinationIndexPath.row;
    id object = [self.localStickers objectAtIndex:sourceRow];
    
    [self.localStickers removeObjectAtIndex:sourceRow];
    [self.localStickers insertObject:object atIndex:destRow];
    
    [self.packageTable reloadData];
    
    [StickerConfig reorderPackage:self.localStickers];
}

- (void)onClickRemove:(PackageSettingCell *)cell
{
    self.removePackage = cell.package;
    
    NSString * strHint = [NSString stringWithFormat:@"确定要删除 %@ 表情包吗?", self.removePackage.packageName];
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:strHint delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
    alertView.tag = 0;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 0)
    {
        if (buttonIndex == 1 && self.removePackage != nil)
        {
            [StickerConfig deletePackage:self.removePackage];
        }
    }
    self.removePackage = nil;
}

@end
