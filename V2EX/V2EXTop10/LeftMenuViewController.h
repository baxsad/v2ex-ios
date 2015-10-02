//
//  LeftMenuViewController.h
//  V2EXTop10
//
//  Created by iURCoder on 9/25/15.
//  Copyright © 2015 NYB. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol nodeSelectDelegate <NSObject>

- (void)nodeSelectAtIndex:(NSString *)code Name:(NSString *)name Index:(NSInteger)index;

@end

@interface LeftMenuViewController : UIViewController

@property (nonatomic, assign) id<nodeSelectDelegate>delegate;

@end
