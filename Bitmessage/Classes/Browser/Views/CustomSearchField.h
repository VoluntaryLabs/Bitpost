//
//  CustomSearchField.h
//  Bitmessage
//
//  Created by Steve Dekorte on 2/19/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CustomSearchField : NSSearchField <NSAnimationDelegate, NSTextFieldDelegate>

@property (assign, nonatomic) id searchDelegate;

@property (assign, nonatomic) BOOL isExpanded;
@property (strong, nonatomic) NSAnimation *expandAnimation;

@end
