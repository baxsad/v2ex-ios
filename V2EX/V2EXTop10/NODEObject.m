//
//  NODEObject.m
//  V2EXTop10
//
//  Created by iURCoder on 9/28/15.
//  Copyright © 2015 NYB. All rights reserved.
//

#import "NODEObject.h"

@implementation NODEObject

- (id)initWithNodeName:(NSString *)name NodeCode:(NSString *)code{
    self = [super init];
    if (self) {
        self.nodeName = name;
        self.nodeCode = code;
    }
    return self;
}

@end
