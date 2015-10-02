//
//  NewsInfo.m
//  V2EXTop10
//
//  Created by iURCoder on 9/24/15.
//  Copyright © 2015 NYB. All rights reserved.
//

#import "NewsInfo.h"

@implementation NewsInfo

- (id)initDataWithNewsID:(long )nID NewsTitle:(NSString *)nTitle NewsUrl:(NSString *)nUrl NewsContent:(NSString *)nContent NewsContrntRendered:(NSString *)nContrntRendered NewsReplies:(long )nReplies MemberID:(long )mID MenmberName:(NSString *)mName MemberAvatar:(NSString *)mAvatar NodeID:(long )ndID NodeName:(NSString *)ndName NodeTitle:(NSString *)ndTitle NodeUrl:(NSString *)ndUrl NodeTopics:(long )ndTopics NodeAvatar:(NSString *)ndAvatar NewsCreated:(long )nCreated NewsLastModified:(long )nLastModified NewsLastTouched:(long )nLastTouched{
    
    self = [super init];
    if (self) {
        
        self.newsID = [NSString stringWithFormat:@"%li",nID];
        self.newsTitle = nTitle;
        self.newsUrl = nUrl;
        self.newsContent = nContent;
        self.newsContentRendered = nContrntRendered;
        self.newsReplies = [NSString stringWithFormat:@"%li",nReplies];
        self.memberID = [NSString stringWithFormat:@"%li",mID];
        self.memberName = mName;
        self.memberAvatar = mAvatar;
        self.nodeID = [NSString stringWithFormat:@"%li",ndID];
        self.nodeName = ndName;
        self.nodeTitle = ndTitle;
        self.nodeUrl = ndUrl;
        self.nodeTopics = [NSString stringWithFormat:@"%li",ndTopics];
        self.nodeAvatar = ndAvatar;
        self.newsCrated = [NSString stringWithFormat:@"%li",nCreated];
        self.newsLastModified = [NSString stringWithFormat:@"%li",nLastModified];
        self.newsLastTouched = [NSString stringWithFormat:@"%li",nLastTouched];
        
    }
    return self;
}

@end
