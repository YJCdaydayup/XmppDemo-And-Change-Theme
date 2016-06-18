//
//  RegisterManager.m
//  XmppDemo
//
//  Created by 杨力 on 14/6/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "RegisterManager.h"

@implementation RegisterManager

+(id)shareManager{
    
    static RegisterManager * manager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        manager = [[RegisterManager alloc]init];
    });
    
    return manager;
}


@end
