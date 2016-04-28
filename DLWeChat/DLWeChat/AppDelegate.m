//
//  AppDelegate.m
//  DLWeChat
//
//  Created by FT_David on 16/4/18.
//  Copyright © 2016年 FT_David. All rights reserved.
//

#import "AppDelegate.h"
#import "DLXMPPTool.h"
@interface AppDelegate ()



@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //如果用户已经登录过在这里设置自动登录
    [[DLXMPPTool shareXMPPTool] XMPPLogin:nil];
   
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


@end
