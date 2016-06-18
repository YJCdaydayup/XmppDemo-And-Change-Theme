//
//  CategoryCell.h
//  GifShow
//
//  Created by mike on 13-8-30.
//  Copyright (c) 2013年 dong mike. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PackageInfo.h"


@protocol PackageSettingCellDelegate;


@interface PackageSettingCell : UITableViewCell

@property (retain) PackageInfo * package;

@property (assign) id <PackageSettingCellDelegate> delegate;

@end


@protocol PackageSettingCellDelegate <NSObject>

- (void)onClickRemove:(PackageSettingCell *)cell;

@end