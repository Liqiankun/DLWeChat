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
    
    //2.链接服务器(传一个jid)
    
    //3.链接成功发送密码
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
}

//3.链接成功发送密码
-(void)sendPWDToHost
{
    NSError *error = nil;
    [self.xmppStream authenticateWithPassword:@"123456" error:&error];
}

#pragma mark - XMPPDelegate
- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
    
}

@end
