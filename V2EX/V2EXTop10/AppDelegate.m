//
//  AppDelegate.m
//  V2EXTop10
//
//  Created by iURCoder on 9/24/15.
//  Copyright © 2015 NYB. All rights reserved.
//

#import "AppDelegate.h"
#import "Reachability.h"
#import "MSGStatusToast.h"
#import "UIColor+V2Color.h"

#import "HomeViewController.h"
#import "LeftMenuViewController.h"

#import "MMDrawerController.h"

@interface AppDelegate ()
{
    
    MMDrawerController *_homeDrawerController;
    
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    
    
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    
    
    
    UINavigationController *navNV = [[UINavigationController alloc] initWithRootViewController:homeVC];
    UINavigationBar *appearance = [UINavigationBar appearance];
    [appearance setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [appearance setShadowImage:[[UIImage alloc] init]];
    [appearance setTranslucent:NO];
    [appearance setBarStyle:UIBarStyleBlackOpaque];
    [appearance setBarTintColor:[UIColor V2NavBackgroundColor]];
    [appearance setTintColor:[UIColor whiteColor]];
    [appearance setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:15],NSFontAttributeName, nil]];
    
    LeftMenuViewController *leftMenuVC = [[LeftMenuViewController alloc] init];
    
   
    _homeDrawerController = [[MMDrawerController alloc]
                             initWithCenterViewController:navNV
                             leftDrawerViewController:leftMenuVC
                             rightDrawerViewController:nil];
    
    [_homeDrawerController setMaximumLeftDrawerWidth:90.0];
    [_homeDrawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window addSubview:_homeDrawerController.view];
    self.window.rootViewController=_homeDrawerController;
    [_window makeKeyAndVisible];
    return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
