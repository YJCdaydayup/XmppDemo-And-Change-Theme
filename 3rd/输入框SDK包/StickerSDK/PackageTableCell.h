//
//  PackageTableCell.h
//  StickerSDKDemo
//
//  Created by mike on 13-11-12.
//  Copyright (c) 2013年 dong mike. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PackageInfo.h"


@protocol PackageTableCellDelegate;

@interface PackageTableCell : UITableViewCell

@property (retain) PackageInfo * packageInfo;
@property (assign) id <PackageTableCellDelegate> delegate;

@end


@protocol PackageTableCellDelegate <NSObject>

- (void)cellClickDownload:(PackageTableCell *)cell;

@end
