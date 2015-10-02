//
//  NODEObject.h
//  V2EXTop10
//
//  Created by iURCoder on 9/28/15.
//  Copyright © 2015 NYB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NODEObject : NSObject

@property (nonatomic, copy) NSString *nodeName;
@property (nonatomic, copy) NSString *nodeCode;
@property (nonatomic, copy) NSArray *childNodeArray;

- (id)initWithNodeName:(NSString *)name NodeCode:(NSString *)code;
@end
