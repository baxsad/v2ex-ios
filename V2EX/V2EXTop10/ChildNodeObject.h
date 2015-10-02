//
//  ChildNodeObject.h
//  V2EXTop10
//
//  Created by iURCoder on 9/28/15.
//  Copyright © 2015 NYB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChildNodeObject : NSObject

@property (nonatomic ,copy) NSString *childNodeName;
@property (nonatomic, copy) NSString *childNodeCode;

- (id)initWithChildNodeName:(NSString *)name CNode:(NSString *)code;

@end
