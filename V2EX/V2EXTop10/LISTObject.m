//
//  LISTObject.m
//  V2EXTop10
//
//  Created by iURCoder on 9/28/15.
//  Copyright © 2015 NYB. All rights reserved.
//

#import "LISTObject.h"

@implementation LISTObject

- (id)initWithUserAvatar:(NSString *)avatar rUrl:(NSString *)rurl ARTTitle:(NSString *)arttitle NUrl:(NSString *)nUrl NName:(NSString *)nname uMber:(NSString *)umember uName:(NSString *)uname crtDate:(NSString *)date lrum:(NSString *)lastrpUM lrun:(NSString *)lastrpUN RPC:(NSString *)replaycount{
    
    self = [super init];
    if (self) {
        self.userAvatar = avatar;
        self.replayUrl = rurl;
        self.articleTitle = arttitle;
        self.nodeUrl = nUrl;
        self.nodeName = nname;
        self.userMember = umember;
        self.userName = uname;
        self.createdDate = date;
        self.lastReplayUserMember = lastrpUM;
        self.lastReplayUserName = lastrpUN;
        self.replayCount = replaycount;
    }
    
    return self;
    
}

@end
