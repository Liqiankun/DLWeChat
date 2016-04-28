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

/** 与服务器交互的核心 */
@property(nonatomic,strong)XMPPStream *xmppStream;
@property(nonatomic,copy)XMPPLoginResultBlock resultBlock;

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
-(void)XMPPLogin:(XMPPLoginResultBlock)resultBlock
{
    self.resultBlock = resultBlock;
    //用户登录流程
    //1.初始化XMPPStream
    [self setupXMPPStream];
#warning 断开之前的链接
    [self.xmppStream disconnect];
    //2.链接服务器(传一个jid)
    [self connectToHost];
    //3.链接成功发送密码(在代理方法中调用)
    //4.发送一个在线请求给服务器
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
    
}
//2.链接服务器(传一个jid)
-(void)connectToHost
{
    //设置jid
    //resource本机设备类型
    XMPPJID *myJid = [XMPPJID jidWithUser:@"davidlee" domain:@"localhost" resource:@"iPhone"];
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
    [self.xmppStream authenticateWithPassword:@"123456" error:&error];
    
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
        if (weakSelf.resultBlock) {
            weakSelf.resultBlock(XMPPLoginResultSuccess);
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
        if (weakSelf.resultBlock) {
            weakSelf.resultBlock(XMPPLoginResultFailure);
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
