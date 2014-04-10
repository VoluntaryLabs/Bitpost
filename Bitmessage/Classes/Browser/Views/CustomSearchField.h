//
//  CustomSearchField.h
//  Bitmessage
//
//  Created by Steve Dekorte on 2/19/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol CustomSearchFieldDelegate <NSObject>
- (void)searchForString:(NSString *)aString;
@end

@interface CustomSearchField : NSSearchField <NSAnimationDelegate, NSTextFieldDelegate>

@property (assign, nonatomic) id <CustomSearchFieldDelegate> searchDelegate;

@property (assign, nonatomic) BOOL isExpanded;
@property (strong, nonatomic) NSAnimation *expandAnimation;
@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) float animationValue;
//@property (assign, nonatomic) NSTimeInterval timerPeriod;

- (void)setupCollapsed;
- (void)setupExpanded;
- (void)toggle;

@end
