//
//  ChildNodeObject.m
//  V2EXTop10
//
//  Created by iURCoder on 9/28/15.
//  Copyright © 2015 NYB. All rights reserved.
//

#import "ChildNodeObject.h"

@implementation ChildNodeObject


- (id)initWithChildNodeName:(NSString *)name CNode:(NSString *)code{
    self = [super init];
    if (self) {
        self.childNodeName = name;
        self.childNodeCode = code;
        
    }
    return self;
}

@end
