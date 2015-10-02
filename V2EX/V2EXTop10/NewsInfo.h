//
//  NewsInfo.h
//  V2EXTop10
//
//  Created by iURCoder on 9/24/15.
//  Copyright © 2015 NYB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsInfo : NSObject

@property (nonatomic, copy) NSString * newsID;

@property (nonatomic, copy) NSString * newsTitle;

@property (nonatomic, copy) NSString * newsUrl;

@property (nonatomic, copy) NSString * newsContent;

@property (nonatomic, copy) NSString * newsContentRendered;

@property (nonatomic, copy) NSString * newsReplies;

@property (nonatomic, copy) NSString * memberID;

@property (nonatomic, copy) NSString * memberName;

@property (nonatomic, copy) NSString * memberAvatar;

@property (nonatomic, copy) NSString * nodeID;

@property (nonatomic, copy) NSString * nodeName;

@property (nonatomic, copy) NSString * nodeTitle;

@property (nonatomic, copy) NSString * nodeUrl;

@property (nonatomic, copy) NSString * nodeTopics;

@property (nonatomic, copy) NSString * nodeAvatar;

@property (nonatomic, copy) NSString * newsCrated;

@property (nonatomic, copy) NSString * newsLastModified;

@property (nonatomic, copy) NSString * newsLastTouched;

- (id)initDataWithNewsID:(long )nID NewsTitle:(NSString *)nTitle NewsUrl:(NSString *)nUrl NewsContent:(NSString *)nContent NewsContrntRendered:(NSString *)nContrntRendered NewsReplies:(long )nReplies MemberID:(long )mID MenmberName:(NSString *)mName MemberAvatar:(NSString *)mAvatar NodeID:(long )ndID NodeName:(NSString *)ndName NodeTitle:(NSString *)ndTitle NodeUrl:(NSString *)ndUrl NodeTopics:(long )ndTopics NodeAvatar:(NSString *)ndAvatar NewsCreated:(long )nCreated NewsLastModified:(long )nLastModified NewsLastTouched:(long )nLastTouched;







@end
