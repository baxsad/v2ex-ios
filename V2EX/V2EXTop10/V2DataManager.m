//
//  V2DataManager.m
//  V2EXTop10
//
//  Created by iURCoder on 9/30/15.
//  Copyright © 2015 NYB. All rights reserved.
//

#import "V2DataManager.h"

#import "ASIFormDataRequest.h"
#import "ASIDownloadCache.h"
#import "Reachability.h"

#import "SBJsonParser.h"

#import "TFHpple.h"

#import "LISTObject.h"
#import "ReplaceObject.h"

@interface V2DataManager()

{
    BOOL     isRequestChildNode;
    NSString *childNodeName;
}

@end

@implementation V2DataManager

+ (instancetype)shareManager {
    
    static V2DataManager   *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager         = [[V2DataManager alloc] init];
        manager.baseUrl = @"https://v2ex.com";
    });
    return manager;
    
}

#pragma mark GET - request

- (void)getArticleListWithNodeCode:(NSString *)code
                      codeName:(NSString *)name
                      requestChild:(BOOL)child
                              Page:(NSInteger)page
                           isCache:(BOOL)cache
                    isStorageCache:(BOOL)storageCache
                   V2RequestPolicy:(V2RequestPolicy )policy
                           Success:(void (^)(NSArray *listArray))success
                           failure:(void (^)(NSError *error))failure{
    
    childNodeName = name;
    
    NSURL *url;
    if (child) {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/go/%@?p=%li",_baseUrl,code,page]];
    }else{
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/?tab=%@",_baseUrl,code]];
    }
    
    /** 是否加载子节点 */
    isRequestChildNode = child;
    
    /** request */
    ASIHTTPRequest *request =[ASIHTTPRequest requestWithURL:url];
    
    /** 是否缓存 */
    if (cache) {
        [request setDownloadCache:[ASIDownloadCache sharedCache]];
    }
    
    /** 请求超时时间 */
    request.timeOutSeconds=20;
    
    /** 超时后 重复请求次数 */
    request.numberOfTimesToRetryOnTimeout=1;
    
    /** 开始异步请求 */
    [request startAsynchronous];
    
    /** 缓存策略 */
    switch (policy) {
        case V2FallUseCache:
            [request setCachePolicy:ASIFallbackToCacheIfLoadFailsCachePolicy];
            break;
         
        case V2AskServerIsUserCache:
            [request setCachePolicy:ASIAskServerIfModifiedWhenStaleCachePolicy];
            break;
            
        case V2OnlyUseCache:
            [request setCachePolicy:ASIOnlyLoadIfNotCachedCachePolicy];
            break;
        default:
            [request setCachePolicy:ASIUseDefaultCachePolicy];
            break;
    }
    
    /**
     * 把缓存数据永久保存在本地
     * 使用clearCachedResponsesForStoragePolicy来清空指定策略下的缓存数据
     */
    storageCache ? [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy] : NO;
    
    /** 设置是否按服务器在Header里指定的是否可被缓存或过期策略进行缓存 */
    [[ASIDownloadCache sharedCache ] setShouldRespectCacheControlHeaders:NO];
    
    /** 设置request缓存的有效时间 */
    [request setSecondsToCache:60*60*24*30];
    
    __block ASIHTTPRequest *blockRequest = request;
    __block V2DataManager *manager = self;
    
    [request setCompletionBlock:^{
    
        success([manager dataToObject:blockRequest.responseData]);
        
    }];
    
    [request setFailedBlock:^{
        failure(blockRequest.error);
    }];
}

#pragma mark Ecoding - object

- (NSArray *)dataToObject:(NSData *)data
{
    
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:data];
    
    NSArray *htmlElements;
    
    if (isRequestChildNode) {
        htmlElements  = [xpathParser searchWithXPathQuery:@"//div[@class='cell']"];
    }else{
        htmlElements  = [xpathParser searchWithXPathQuery:@"//div[@class='cell item']"];
    }

    
    NSMutableArray * articleDataArray = [NSMutableArray array];
    for (int i =0; i<htmlElements.count; i++) {
        
        TFHppleElement *element = [htmlElements objectAtIndex:i];
        
        /** avatar */
        
        NSArray *a = [element searchWithXPathQuery:@"//img[@class='avatar']"];
        NSString *avatar = [a[0] objectForKey:@"src"];
        
        /** title */
        NSArray *b = [element searchWithXPathQuery:@"//span[@class='item_title']/a"];
        NSString *artUrl = [[b objectAtIndex:0] objectForKey:@"href"];
        NSString *artTitle = [b[0] content];
        
        /** node */
        NSArray *c = [element searchWithXPathQuery:@"//a[@class='node']"];
        NSString *nodeUrl;
        NSString *nodeName;
        if (isRequestChildNode) {
            nodeName = childNodeName;
            nodeUrl = @"";
        }else{
            nodeName = [c[0] content];
            nodeUrl = [c[0] objectForKey:@"href"];
        }
        
        /** user */
        NSArray *d;
        NSString *userMember;
        NSString *userName;
        if (isRequestChildNode) {
            d = [element searchWithXPathQuery:@"//strong"];
            userMember = @"";
            userName = [d[0] content];
        }else{
            d = [element searchWithXPathQuery:@"//strong/a"];
            userMember = [d[0] objectForKey:@"href"];
            userName = [d[0] content];
        }
        
        /** date */
        NSArray *e = [element searchWithXPathQuery:@"//span[@class='small fade']"];
        
        NSString *dateStr;
        if (isRequestChildNode) {
            if ([[e[0] content] componentsSeparatedByString:@"•"].count == 3) {
                dateStr = [[e[0] content] componentsSeparatedByString:@"•"][2];
            }else{
                dateStr = [[e[0] content] componentsSeparatedByString:@"•"][1];
            }
        }else{
            dateStr = [[e[1] content] componentsSeparatedByString:@"•"][0];
        }
        
        //////////////////////
        
        NSString * lhref;
        NSString * lname;
        if (d.count == 2) {
            lhref = [d[0] objectForKey:@"href"];
            lname = [d[0] content];
        }else{
            lhref = @"";
            lname = @"";
        }
        
        /////////////////////
        
        NSArray *f = [element searchWithXPathQuery:@"//a[@class='count_livid']"];
        NSString * rpCount;
        
        
        if (f.count == 1) {
            
            rpCount = [f[0] content];
            
        }else{
            rpCount = @"0";
        }
        
        LISTObject *list = [[LISTObject alloc] initWithUserAvatar:avatar
                                                             rUrl:artUrl
                                                         ARTTitle:artTitle
                                                             NUrl:nodeUrl
                                                            NName:nodeName
                                                            uMber:userMember
                                                            uName:userName
                                                          crtDate:[dateStr stringByTrimmingCharactersInSet:
                                                                   [NSCharacterSet whitespaceAndNewlineCharacterSet]]
                                                             lrum:lhref
                                                             lrun:lname
                                                              RPC:rpCount];
        
        [articleDataArray addObject:list];
    }
    
    
    return articleDataArray;
    
}



- (void)getArticleReplayListWithPID:(NSString *)pid Success:(void (^)(NSArray *listArray))success failure:(void (^)(NSError *error))failure{
    
    
    NSURL *url;
    url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/replies/show.json?topic_id=%@",_baseUrl,pid]];
    
    
    /** request */
    ASIHTTPRequest *request =[ASIHTTPRequest requestWithURL:url];
    
    /** 缓存 */
    [request setDownloadCache:[ASIDownloadCache sharedCache]];
    
    
    /** 请求超时时间 */
    request.timeOutSeconds=20;
    
    /** 超时后 重复请求次数 */
    request.numberOfTimesToRetryOnTimeout=1;
    
    /** 开始异步请求 */
    [request startAsynchronous];
    
    /** 缓存策略 */
    [request setCachePolicy:ASIFallbackToCacheIfLoadFailsCachePolicy];
    
    
    
    /** 设置是否按服务器在Header里指定的是否可被缓存或过期策略进行缓存 */
    [[ASIDownloadCache sharedCache ] setShouldRespectCacheControlHeaders:NO];
    
    /** 设置request缓存的有效时间 */
    [request setSecondsToCache:60*60*24*30];
    
    __block ASIHTTPRequest *blockRequest = request;
    __block V2DataManager  *manager = self;
    
    [request setCompletionBlock:^{
        
        success([manager replayDataToObject:blockRequest.responseData]);
        
    }];
    
    [request setFailedBlock:^{
        failure(blockRequest.error);
    }];
    
}

- (NSArray *)replayDataToObject:(NSData *)data{
    
    NSMutableArray *infoDataArr = [NSMutableArray array];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSArray *replayDataArr = [parser objectWithString:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
    
    for (int i =0; i<replayDataArr.count; i++) {
        NSDictionary *dic  = [replayDataArr objectAtIndex:i];
        ReplaceObject *rp  = [[ReplaceObject alloc] init];
        rp.memberName      = dic[@"member"][@"username"];
        rp.memberAvatar    = dic[@"member"][@"avatar_normal"];
        rp.replayContent   = dic[@"content"];
        rp.replayDate      = [NSString stringWithFormat:@"%li",[dic[@"created"] longValue]];
        [infoDataArr addObject:rp];
    }
    
    return infoDataArr;
}

#pragma mark get content

- (void)getArticleContentWithPID:(NSString *)pid Success:(void (^)(NSArray *contentArr))success failure:(void (^)(NSError *error))failure{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://v2ex.com/api/topics/show.json?id=%@",pid]];
    
    /** 它对Get请求的响应数据进行缓存（被缓存的数据必需是成功的200请求） */
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    
    /** request */
    ASIHTTPRequest *request =[ASIHTTPRequest requestWithURL:url];
    
    
    
    /** 请求超时时间 */
    request.timeOutSeconds=10;
    
    /** 超时后 重复请求次数 */
    request.numberOfTimesToRetryOnTimeout=1;
    
    /** 开始异步请求 */
    [request startAsynchronous];
    
    /** 缓存策略 */
    [request setCachePolicy:ASIFallbackToCacheIfLoadFailsCachePolicy];
    
    /**
     * 把缓存数据永久保存在本地
     * 使用clearCachedResponsesForStoragePolicy来清空指定策略下的缓存数据
     */
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy ];
    
    /** 设置是否按服务器在Header里指定的是否可被缓存或过期策略进行缓存 */
    [[ASIDownloadCache sharedCache ] setShouldRespectCacheControlHeaders:NO];
    
    /** 设置request缓存的有效时间 */
    [request setSecondsToCache:60*60*24*30];
    
    
    
    __block ASIHTTPRequest *blockRequest = request;
    __block V2DataManager  *manager = self;
    
    [request setCompletionBlock:^{
        
        success([manager contentDataArr:blockRequest.responseData]);
        
    }];
    
    [request setFailedBlock:^{
        failure(blockRequest.error);
    }];



    
}

- (NSArray *)contentDataArr:(NSData *)data{
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSArray *arr = [parser objectWithString:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
    NSDictionary *dic = arr[0];
    
    NSString * content = [dic objectForKey:@"content"];
    NSString *createdTime = [self timesTamp:[NSString stringWithFormat:@"%li",[dic[@"created"] longValue]]];
    return @[content,createdTime];
    
}

#pragma mark 时间转换

-(NSString *)timesTamp:(NSString *)time
{
    
    NSString *time1970=[NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];
    long nowDate=[time1970 longLongValue];
    long YDate=[time longLongValue];
    
    
    NSDateFormatter *formeter=[[NSDateFormatter alloc] init];
    [formeter setDateFormat:@"MM-dd HH:mm:ss"];
    
    
    int cha=(int)(nowDate-YDate);
    
    if (cha<60) {
        return @"刚刚";
    }else if(cha<60*60){
        NSString *str=[NSString stringWithFormat:@"%i分钟前",cha/60];
        return str;
    }else if(cha<60*60*24){
        NSString *str=[NSString stringWithFormat:@"%i小时前",cha/(60*60)];
        return str;
    }else if(cha<60*60*24*3){
        NSString *str=[NSString stringWithFormat:@"%i天前",cha/(60*60*24)];
        return str;
    }else{
        NSDate *date=[NSDate dateWithTimeIntervalSince1970:[time doubleValue]];
        NSString *str=[formeter stringFromDate:date];
        return str;
    }
    
    return [NSString stringWithFormat:@"%i",cha];
}


@end
