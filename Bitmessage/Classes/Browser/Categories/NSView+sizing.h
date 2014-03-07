//
//  NSView+sizing.h
//  Bitmarket
//
//  Created by Steve Dekorte on 2/6/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSView (sizing)

- (void)setX:(CGFloat)x;
- (CGFloat)x;

- (void)setY:(CGFloat)y;
- (CGFloat)y;

- (void)setWidth:(CGFloat)w;
- (CGFloat)width;

- (void)setHeight:(CGFloat)h;
- (CGFloat)height;

- (CGFloat)maxX;
- (CGFloat)maxY;

- (void)centerXInSuperview;
- (void)centerYInSuperview;

- (void)centerSubviewsX;
- (void)centerSubviewsY;

- (void)stackSubviewsRightToLeft;
- (void)stackSubviewsTopToBottom;
- (void)stackSubviewsTopToBottomWithMargin:(CGFloat)margin;

- (CGFloat)sumOfSubviewHeights;

- (void)centerStackedSubviewsY;

- (void)placeYAbove:(NSView *)aView margin:(CGFloat)margin;
- (void)placeYBelow:(NSView *)aView margin:(CGFloat)margin;


// animation

- (void)animateUpFadeIn;
- (void)animateDownFadeOut;
- (void)animateFadeOut;
- (void)animateFadeIn;

@end
