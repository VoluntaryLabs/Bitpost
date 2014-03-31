//
//  BMRoundButtonView.m
//  Bitmessage
//
//  Created by Steve Dekorte on 3/30/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "BMRoundButtonView.h"
#import "NSView+sizing.h"

@implementation BMRoundButtonView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        _backgroundColor = [NSColor blackColor];
        _cornerRadius = 3;
        [self setTextColor:[NSColor whiteColor]];
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [self lockFocus];
    
    CGContextRef ctx = (CGContextRef)[[NSGraphicsContext currentContext]
                                  graphicsPort];
    
	CGRect frame = self.bounds;
    
	CGPathRef roundedRectPath = [self newPathForRoundedRect:frame radius:_cornerRadius];
    
	[self.backgroundColor set];
    
	CGContextAddPath(ctx, roundedRectPath);
	CGContextFillPath(ctx);
    
	CGPathRelease(roundedRectPath);

    
    NSDictionary *att = self.titleAttributes;
    //CGFloat fontSize = [(NSFont *)[att objectForKey:NSFontAttributeName] pointSize];
    
    CGFloat width = [[[NSAttributedString alloc] initWithString:self.title attributes:att] size].width;

    [self.title drawAtPoint:NSMakePoint(self.width/2.0 - width/2.0, 1)
                                        //-self.height/2.0)// + fontSize/2.0)
//     self.height/2.0 - fontSize/2.0 - 0)
        withAttributes:att];

    [self unlockFocus];
}



- (CGPathRef) newPathForRoundedRect:(CGRect)rect radius:(CGFloat)radius
{
	CGMutablePathRef retPath = CGPathCreateMutable();
    
	CGRect innerRect = CGRectInset(rect, radius, radius);
    
	CGFloat inside_right = innerRect.origin.x + innerRect.size.width;
	CGFloat outside_right = rect.origin.x + rect.size.width;
	CGFloat inside_bottom = innerRect.origin.y + innerRect.size.height;
	CGFloat outside_bottom = rect.origin.y + rect.size.height;
    
	CGFloat inside_top = innerRect.origin.y;
	CGFloat outside_top = rect.origin.y;
	CGFloat outside_left = rect.origin.x;
    
	CGPathMoveToPoint(retPath, NULL, innerRect.origin.x, outside_top);
    
	CGPathAddLineToPoint(retPath, NULL, inside_right, outside_top);
	CGPathAddArcToPoint(retPath, NULL, outside_right, outside_top, outside_right, inside_top, radius);
	CGPathAddLineToPoint(retPath, NULL, outside_right, inside_bottom);
	CGPathAddArcToPoint(retPath, NULL,  outside_right, outside_bottom, inside_right, outside_bottom, radius);
    
	CGPathAddLineToPoint(retPath, NULL, innerRect.origin.x, outside_bottom);
	CGPathAddArcToPoint(retPath, NULL,  outside_left, outside_bottom, outside_left, inside_bottom, radius);
	CGPathAddLineToPoint(retPath, NULL, outside_left, inside_top);
	CGPathAddArcToPoint(retPath, NULL,  outside_left, outside_top, innerRect.origin.x, outside_top, radius);
    
	CGPathCloseSubpath(retPath);
    
	return retPath;
}

@end
