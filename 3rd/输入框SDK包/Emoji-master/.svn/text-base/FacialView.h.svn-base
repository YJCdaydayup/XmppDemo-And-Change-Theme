//
//  FacialView.h
//  KeyBoardTest
//
//  Created by wangqiulei on 11-8-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmojiEmoticons.h"
#import "Emoji.h"
#import "EmojiMapSymbols.h"
#import "EmojiPictographs.h"
#import "EmojiTransport.h"
@protocol facialViewDelegate

-(void)selectedFacialView:(NSString*)str;

@end


@interface FacialView : UIView {

	id<facialViewDelegate>delegate;
	NSArray *faces;
}
@property(nonatomic,assign)id<facialViewDelegate>delegate;

-(void)loadFacialView:(int)page size:(CGSize)size;

@end
