//
//  AppDelegate.m
//  DDYScratchView
//
//  Created by SmartMesh on 2018/6/6.
//  Copyright © 2018年 com.smartmesh. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    [self.window setRootViewController:[[ViewController alloc] init]];
    return YES;
}

@end
