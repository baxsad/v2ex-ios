//
//  V2DataManager.h
//  V2EXTop10
//
//  Created by iURCoder on 9/30/15.
//  Copyright © 2015 NYB. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, V2RequestPolicy) {
    V2FallUseCache,
    V2AskServerIsUserCache,
    V2OnlyUseCache
};

@interface V2DataManager : NSObject

@property (nonatomic, copy) NSString *baseUrl;

+ (instancetype)shareManager;

#pragma mark GET - request


- (void)getArticleListWithNodeCode:(NSString *)code codeName:(NSString *)name requestChild:(BOOL)child Page:(NSInteger)page isCache:(BOOL)cache isStorageCache:(BOOL)storageCache V2RequestPolicy:(V2RequestPolicy )policy Success:(void (^)(NSArray *listArray))success failure:(void (^)(NSError *error))failure;

- (void)getArticleReplayListWithPID:(NSString *)pid Success:(void (^)(NSArray *listArray))success failure:(void (^)(NSError *error))failure;

- (void)getArticleContentWithPID:(NSString *)pid Success:(void (^)(NSArray *contentArr))success failure:(void (^)(NSError *error))failure;

@end
