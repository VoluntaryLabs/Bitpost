//
//  MKMessage.h
//  Bitmessage
//
//  Created by Steve Dekorte on 3/17/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "BMNode.h"

@interface MKMessage : BMNode

@property (strong, nonatomic) NSString *msgid;

+ (MKMessage *)withDict:(NSMutableDictionary *)dict;

@end
