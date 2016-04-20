//
//  AppDelegate.m
//  DLWeChat
//
//  Created by FT_David on 16/4/18.
//  Copyright © 2016年 FT_David. All rights reserved.
//

#import "AppDelegate.h"
#import "XMPPFramework.h"
@interface AppDelegate ()<XMPPStreamDelegate>

/** 与服务器交互的核心 */
@property(nonatomic,strong)XMPPStream *xmppStream;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {

}

- (void)applicationDidEnterBackground:(UIApplication *)application {

}

- (void)applicationWillEnterForeground:(UIApplication *)application {

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {

}

#pragma mark - XMPPLogin
-(void)XMPPLogin
{
    //用户登录流程
    //1.初始化XMPPStream
    [self setupXMPPStream];
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
    self.xmppStream = [[XMPPStream alloc] init];
    //设置代理
    [self.xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    
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
}
//登录失败
-(void)xmppStream:(XMPPStream *)send didNotAuthenticate:(DDXMLElement *)error
{
    NSLog(@"%s--%@",__func__,error);
}

@end
