//
//  DLUserProfileTool.h
//  DLWeChat
//
//  Created by FT_David on 16/5/15.
//  Copyright © 2016年 FT_David. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DLXMPPTool.h"
@interface DLUserProfileTool : NSObject

/** 获取当前用户的电子名片信息*/
-(XMPPvCardTemp*)getCurrentUserModule;

@end
