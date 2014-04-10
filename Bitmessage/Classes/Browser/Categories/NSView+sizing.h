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
- (CGFloat)maxXOfSubviews;
- (CGFloat)minXOfSubviews;


- (CGFloat)maxY;
- (CGFloat)maxYOfSubviews;
- (CGFloat)minYOfSubviews;

- (void)centerXInSuperview;
- (void)centerYInSuperview;

- (void)centerSubviewsX;
- (void)centerSubviewsY;

- (void)stackSubviewsRightToLeft;
- (void)stackSubviewsRightToLeftWithMargin:(CGFloat)margin;

- (void)stackSubviewsLeftToRightWithMargin:(CGFloat)margin;

- (void)stackSubviewsTopToBottom;
- (void)stackSubviewsTopToBottomWithMargin:(CGFloat)margin;
- (void)stackSubviewsBottomToTopWithMargin:(CGFloat)margin;

- (CGFloat)sumOfSubviewHeights;

- (void)centerStackedSubviewsY;

- (void)placeYAbove:(NSView *)aView margin:(CGFloat)margin;
- (void)placeYBelow:(NSView *)aView margin:(CGFloat)margin;
- (void)placeXRightOf:(NSView *)aView margin:(CGFloat)margin;
- (void)placeInTopOfSuperviewWithMargin:(CGFloat)margin;

- (void)adjustSubviewsX:(CGFloat)dx;
- (void)adjustSubviewsY:(CGFloat)dy;

// animation

- (void)animateUpFadeIn;
- (void)animateDownFadeOut;
- (void)animateFadeOut;
- (void)animateFadeIn;

// subviews

- (void)removeAllSubviews;

- (void)show;

- (void)sizeAndRepositionSubviewsToFit;

@end
