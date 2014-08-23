//
//  BMClient+UI.h
//  Bitmessage
//
//  Created by Steve Dekorte on 4/17/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import <BitmessageKit/BitmessageKit.h>

@interface BMClient (NodeView)

- (void)compose;
- (void)composeBroadcast;

- (void)composeWithAddress:(NSString *)address;
- (void)export;
- (void)import;

@end
