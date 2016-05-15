//
//  DLXMPPTool.h
//  DLWeChat
//
//  Created by FT_David on 16/4/28.
//  Copyright © 2016年 FT_David. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"

typedef NS_ENUM(NSUInteger,XMPPLoginResultType){
    XMPPLoginResultSuccess,
    XMPPLoginResultFailure
};

typedef NS_ENUM(NSUInteger,XMPPRegisterResultType){
    XMPPRegisterResultSuccess,
    XMPPRegisterResultFailure
};

typedef void (^XMPPLoginResultBlock)(XMPPLoginResultType reslut);
typedef void (^XMPPRegisterResultBlock)(XMPPRegisterResultType reslut);

@interface DLXMPPTool : NSObject

/** 用于判断是注册还是登录 */
@property(nonatomic,assign)BOOL registerOperation;
/** 电子名片模块 */
@property(nonatomic,strong)XMPPvCardTempModule *xmppVCard;
/** 电子名片数据存储 */
@property(nonatomic,strong)XMPPvCardCoreDataStorage *xmppVCardStorage;
/** 电子名片头像模块 */
@property(nonatomic,strong)XMPPvCardAvatarModule *xmppVCardAvatar;



/**
 *  创建单利
 */
+(instancetype)shareXMPPTool;


/**
 *  XMPP登录方法
 *
 *  @param resultBlock 登录结果的Block
 */
-(void)XMPPLogin:(XMPPLoginResultBlock)resultBlock;

/**
 *  XMPP注册方法
 *
 *  @param resultBlock 注册结果的Block
 */
-(void)XMPPRegister:(XMPPRegisterResultBlock)resultBlock;
/**
 *  XMPP注销的方法
 */
-(void)XMPPLogout;

@end
