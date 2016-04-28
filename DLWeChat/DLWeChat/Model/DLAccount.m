//
//  DLAccount.m
//  DLWeChat
//
//  Created by FT_David on 16/4/27.
//  Copyright © 2016年 FT_David. All rights reserved.
//

#import "DLAccount.h"

@implementation DLAccount


+(instancetype)shareAcction
{
    static DLAccount *_manager = nil;
    static dispatch_once_t requestManager;
    
    dispatch_once(&requestManager, ^{
        if (!_manager) {
            _manager = [[DLAccount alloc] init];
        }
    });
    return _manager;
}

-(BOOL)didLogin
{
    if (self.user && self.password) {
        return YES;
    }else{
        return NO;
    }
}


@end