//
//  DLAccount.h
//  DLWeChat
//
//  Created by FT_David on 16/4/27.
//  Copyright © 2016年 FT_David. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DLAccount : NSObject

@property(nonatomic,copy)NSString *user;
@property(nonatomic,copy)NSString *password;
@property(nonatomic,assign,getter=didLogin)BOOL login;

+(instancetype)shareAcction;
@end
