//
//  CategoryCell.m
//  GifShow
//
//  Created by mike on 13-8-30.
//  Copyright (c) 2013年 dong mike. All rights reserved.
//

#import "PackageSettingCell.h"

#import "UIImageView+AFNetworking.h"


@interface PackageSettingCell ()

@property (retain) UIImageView * thumbView;
@property (retain) UIButton * removeButton;
@property (retain) UILabel * label;

@end

@implementation PackageSettingCell

@synthesize thumbView;
@synthesize removeButton;

@synthesize delegate;

@synthesize package = _package;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.thumbView = [[UIImageView alloc] initWithFrame:CGRectMake(13, 3, 40 * 1.4, 32 * 1.4)];
        [self.thumbView setContentMode:UIViewContentModeScaleAspectFit];
        [self addSubview:self.thumbView];
        
        self.label =[[UILabel alloc] initWithFrame:CGRectMake(65, 12, 200, 32)];
        self.label.backgroundColor = [UIColor clearColor];
        self.label.textColor = [UIColor blackColor];
        self.label.font = [UIFont boldSystemFontOfSize:14];
        [self addSubview:self.label];
        
        self.removeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.removeButton.frame = CGRectMake(243, 12, 68, 30);
        [self.removeButton setBackgroundImage:[UIImage imageNamed:@"sticker_delete.png"] forState:UIControlStateNormal];
        [self.removeButton addTarget:self action:@selector(onClickRemove) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.removeButton];
    }
    return self;
}

- (void)setPackage:(PackageInfo *)info
{
    if (_package != info)
    {
        _package = nil;
        _package = info;
        
        if (_package != nil)
        {
            UIImage * image = [_package packageThumb];
            if (image)
            {
                [self.thumbView setImage:image];
            }
            else
            {
                [self.thumbView setImageWithURL:[NSURL URLWithString:_package.packageThumbURL]];
            }
            self.label.text = _package.packageName;
        }
        
        if (_package.packageType == kPackedPackage)
        {
            self.removeButton.hidden = YES;
        }
        else
        {
            self.removeButton.hidden = NO;
        }
    }
}

- (PackageInfo *)package
{
    return _package;
}

- (void)onClickRemove
{
    if (self.delegate != nil)
    {
        [self.delegate onClickRemove:self];
    }
}

- (void)dealloc
{
    self.thumbView = nil;
    self.removeButton = nil;
    self.label = nil;
    self.package = nil;
    
  
}

- (void)setEditing:(BOOL)editing
{
    [super setEditing:editing];
    
    if (self.package.packageType != kPackedPackage)
    {
        [self.removeButton setHidden:editing];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.textLabel.hidden = YES;
    if (self.package.packageType != kPackedPackage)
    {
        [self.removeButton setHidden:self.editing];
    }
    self.label.frame = CGRectMake(80, 12, 200, 32);
}

@end
