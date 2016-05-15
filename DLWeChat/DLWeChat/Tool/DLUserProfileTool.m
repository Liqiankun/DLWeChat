//
//  DLUserProfileTool.m
//  DLWeChat
//
//  Created by FT_David on 16/5/15.
//  Copyright © 2016年 FT_David. All rights reserved.
//

#import "DLUserProfileTool.h"


@implementation DLUserProfileTool


-(XMPPvCardTemp*)getCurrentUserModule
{
    //返回当前登录用户的信息模型
   return [DLXMPPTool shareXMPPTool].xmppVCard.myvCardTemp;
}


@end
