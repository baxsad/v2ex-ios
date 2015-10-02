//
//  LISTObject.h
//  V2EXTop10
//
//  Created by iURCoder on 9/28/15.
//  Copyright © 2015 NYB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LISTObject : NSObject


@property (nonatomic, copy) NSString *userAvatar;

@property (nonatomic, copy) NSString *replayUrl;

@property (nonatomic, copy) NSString *articleTitle;

@property (nonatomic, copy) NSString *nodeUrl;

@property (nonatomic, copy) NSString *nodeName;

@property (nonatomic, copy) NSString *userMember;

@property (nonatomic, copy) NSString *userName;

@property (nonatomic, copy) NSString *createdDate;

@property (nonatomic, copy) NSString *lastReplayUserMember;

@property (nonatomic, copy) NSString *lastReplayUserName;

@property (nonatomic, copy) NSString *replayCount;

- (id)initWithUserAvatar:(NSString *)avatar rUrl:(NSString *)rurl ARTTitle:(NSString *)arttitle NUrl:(NSString *)nUrl NName:(NSString *)nname uMber:(NSString *)umember uName:(NSString *)uname crtDate:(NSString *)date lrum:(NSString *)lastrpUM lrun:(NSString *)lastrpUN RPC:(NSString *)replaycount;

@end
