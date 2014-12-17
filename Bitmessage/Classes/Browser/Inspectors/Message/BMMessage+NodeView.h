//
//  BMMessage+NodeView.h
//  Bitmessage
//
//  Created by Steve Dekorte on 2/27/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import <BitmessageKit/BitmessageKit.h>

@interface BMMessage (NodeView)

- (NSString *)nodeNote;

- (void)reply;
- (void)forward;

@end
