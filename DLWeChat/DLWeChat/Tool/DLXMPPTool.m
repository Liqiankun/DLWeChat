//
//  DLXMPPTool.m
//  DLWeChat
//
//  Created by FT_David on 16/4/28.
//  Copyright © 2016年 FT_David. All rights reserved.
//

#import "DLXMPPTool.h"
#import "XMPPFramework.h"
@interface DLXMPPTool ()<XMPPStreamDelegate>
#import "XMPPvCardTempModule.h"
#import "XMPPvCardCoreDataStorage.h"
/** 与服务器交互的核心 */
@property(nonatomic,strong)XMPPStream *xmppStream;
/** 电子名片模块 */
@property(nonatomic,strong)XMPPvCardTempModule *xmppVCard;
/** 电子名片数据存储 */
@property(nonatomic,strong)XMPPvCardCoreDataStorage *xmppVCardStorage;
/** 电子名片头像模块 */
@property(nonatomic,strong)XMPPvCardAvatarModule *xmppVCardAvatar;
@property(nonatomic,copy)XMPPLoginResultBlock loginResultBlock;
@property(nonatomic,copy)XMPPRegisterResultBlock registerResultBlock;

@end

@implementation DLXMPPTool

+(instancetype)shareXMPPTool
{
    static DLXMPPTool *_tool = nil;
    static dispatch_once_t requestManager;
    
    dispatch_once(&requestManager, ^{
        if (!_tool) {
            _tool = [[DLXMPPTool alloc] init];
        }
    });
    return _tool;
}

#pragma mark - XMPPLogin
-(void)XMPPLogin:(XMPPLoginResultBlock)loginResultBlock
{
    self.loginResultBlock = loginResultBlock;
    //用户登录流程
//    //1.初始化XMPPStream
//    [self setupXMPPStream];
#warning 断开之前的链接
    [self.xmppStream disconnect];
    //2.链接服务器(传一个jid)
    [self connectToHost];
    //3.链接成功发送密码(在代理方法中调用)
    //4.发送一个在线请求给服务器
}

#pragma mark - XMPPRegister
-(void)XMPPRegister:(XMPPRegisterResultBlock)registerResultBlock
{
    self.registerResultBlock = registerResultBlock;
    //发送一个"注册的JID"给服务器请求一个长链接
    [self.xmppStream disconnect];
    //2.链接服务器(传一个jid)
    [self connectToHost];
    //链接成功，发送注册密码
    
}

#pragma mark - private
//1.初始化XMPPStream
-(void)setupXMPPStream
{
    //创建XMPPStream对象
    if (!_xmppStream) {
        self.xmppStream = [[XMPPStream alloc] init];
        //设置代理 在子线程
        [self.xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    }
    
    if (!_xmppVCard) {
        self.xmppVCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
        self.xmppVCard = [[XMPPvCardTempModule alloc] initWithvCardStorage:self.xmppVCardStorage];
        //激活
        [self.xmppVCard activate:self.xmppStream];
    }
    
    if (!_xmppVCardAvatar) {
        self.xmppVCardAvatar = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:self.xmppVCard];
        //激活
        [self.xmppVCardAvatar activate:self.xmppStream];
    }

    
}
//2.链接服务器(传一个jid)
-(void)connectToHost
{
    //1.初始化XMPPStream
    [self setupXMPPStream];
    
    XMPPJID *myJid = nil;
    if (self.registerOperation) {//设置注册的Jib
        //设置jid
        //resource本机设备类型
        myJid = [XMPPJID jidWithUser:@"davidlee" domain:@"localhost" resource:@"iPhone"];
    }else{//设置登录的Jib
        //设置jid
        //resource本机设备类型
        myJid = [XMPPJID jidWithUser:@"davidlee" domain:@"localhost" resource:@"iPhone"];
    }
  
    self.xmppStream.myJID = myJid;
    //设置主机地址
    self.xmppStream.hostName = @"localhost";
    //设置主机端口号(默认是5222,可以不用)
    self.xmppStream.hostPort = 5222;
    //发送链接
    NSError *error = nil;
    [self.xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error];
    
    if (error) {
        NSLog(@"发起连接失败");
    }else{
        NSLog(@"发起连接成功");
    }
}

//3.链接成功发送密码
-(void)sendPWDToHost
{
    NSError *error = nil;
    
    if (self.registerOperation) {//发送注册的密码
        [self.xmppStream authenticateWithPassword:@"123456" error:&error];
    }else{//发送登录的密码
        [self.xmppStream authenticateWithPassword:@"123456" error:&error];
    }
    
    if (error) {
        NSLog(@"登录失败");
    }else{
        NSLog(@"登录成功");
    }
}

//4.发送在线的请求
-(void)sendOnLine
{
    XMPPPresence *presence = [XMPPPresence presence];
    [self.xmppStream sendElement:presence];
}

#pragma mark - XMPPStreamDelegate
#pragma mark LoginDelegate
//连接建立成功
- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
    //连接成功发送密码
    [self sendPWDToHost];
}
//登录成功
-(void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    [self sendOnLine];
    __weak typeof(self) weakSelf = self;
    //回到主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        if (weakSelf.loginResultBlock) {
            weakSelf.loginResultBlock(XMPPLoginResultSuccess);
        }
    });
    
}
//登录失败
-(void)xmppStream:(XMPPStream *)send didNotAuthenticate:(DDXMLElement *)error
{
    NSLog(@"%s--%@",__func__,error);
    
    __weak typeof(self) weakSelf = self;
    //回到主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        if (weakSelf.loginResultBlock) {
            weakSelf.loginResultBlock(XMPPLoginResultFailure);
        }
    });
}
#pragma mark RegisterDelegate

//注册成功
-(void)xmppStreamDidRegister:(XMPPStream *)sender
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (weakSelf.registerResultBlock) {
            weakSelf.registerResultBlock(XMPPRegisterResultSuccess);
        }
    });
}

//注册失败
-(void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (weakSelf.registerResultBlock) {
            weakSelf.registerResultBlock(XMPPRegisterResultFailure);
        }
    });
}


#pragma mark - XMPPLogout
-(void)XMPPLogout
{
    //发送离线消息
    [self sendOffLine];
    //从服务器断开连接
    [self.xmppStream disconnect];
    
}

//发送离线消息
-(void)sendOffLine
{
    XMPPPresence *offline = [XMPPPresence presenceWithType:@"unavailable"];
    [self.xmppStream sendElement:offline];
}



@end
