//
//  AppDelegate.h
//  DLWeChat
//
//  Created by FT_David on 16/4/18.
//  Copyright © 2016年 FT_David. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,XMPPLoginResultType){
    XMPPLoginResultSuccess,
    XMPPLoginResultFailure
};

typedef void (^XMPPLoginResultBlock)(XMPPLoginResultType reslut);

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

-(void)XMPPLogin:(XMPPLoginResultBlock)resultBlock;

@end

