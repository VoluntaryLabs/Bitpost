//
//  NavRowView.m
//  Bitmessage
//
//  Created by Steve Dekorte on 2/23/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "NavRowView.h"
#import "NSView+sizing.h"

@implementation NavRowView

- (BOOL)isHighlighted
{
    return [self.tableView selectedRow] == self.rowIndex;
}

- (BOOL)wantsDefaultClipping
{
    return NO;
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.leftMarginRatio = 0.5;
        [self setAutoresizesSubviews:YES];
        [self setAutoresizingMask:NSViewHeightSizable | NSViewWidthSizable];
        self.selectionHighlightStyle = NSTableViewSelectionHighlightStyleNone;
    }
    return self;
}

- (NSColor *)textColorActive
{
    if ([self.node respondsToSelector:@selector(textColorActive)])
    {
        NSColor *color = [(id)self.node textColorActive];
        if (color)
        {
            return color;
        }
    }
    
    return [NSColor whiteColor];
}

- (NSColor *)textColor
{
    if ([self isHighlighted])
    {
        return self.textColorActive;
    }
    else
    {
        if ([self.node respondsToSelector:@selector(textColor)])
        {
            NSColor *color = [(id)self.node textColor];
            if (color)
            {
                return color;
            }
        }
    }
    
	return [self isHighlighted] ?
    [NSColor whiteColor] :
    [NSColor colorWithCalibratedWhite:071.0/255.0 alpha:1.0];
}

- (NSColor *)bgColorActive
{
    if ([self.node respondsToSelector:@selector(bgColorActive)])
    {
        NSColor *color = [(id)self.node bgColorActive];
        if (color)
        {
            return color;
        }
    }
    
    return [NSColor colorWithCalibratedWhite:023.0/255.0 alpha:1.0];
}

- (NSColor *)bgColorInactive
{
    if ([self.node respondsToSelector:@selector(bgColorInactive)])
    {
        NSColor *color = [(id)self.node bgColorInactive];
        if (color)
        {
            return color;
        }
    }
    
    return [NSColor colorWithCalibratedWhite:031.0/255.0 alpha:1.0];
}

- (NSColor *)bgColor
{
    return [self isHighlighted] ? [self bgColorActive] : [self bgColorInactive];
}

- (NSString *)fontName
{
    return @"Open Sans Light";
}

- (NSDictionary *)titleAttributes
{
    CGFloat fontSize = 14.0;
    NSFont *font = [NSFont fontWithName:[self fontName] size:fontSize];
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [self textColor], NSForegroundColorAttributeName,
            font, NSFontAttributeName,
            nil];
}

- (NSDictionary *)subtitleAttributes
{
    CGFloat fontSize = 12.0;
    NSFont *font = [NSFont fontWithName:[self fontName] size:fontSize];
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [self textColor], NSForegroundColorAttributeName,
            font, NSFontAttributeName,
            nil];
}

- (NSDictionary *)noteAttributes
{
    CGFloat fontSize = 12.0;
    NSFont *font = [NSFont fontWithName:[self fontName] size:fontSize];
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [self textColor], NSForegroundColorAttributeName,
            font, NSFontAttributeName,
            nil];
}

- (NSImage *)icon
{
    NSString *stateName = @"inactive";
    
    if (self.isSelected)
    {
        stateName = @"active";
    }
    
    return [self.node nodeIconForState:stateName];
}

- (void)drawRect:(NSRect)dirtyRect
{
//	[super drawRect:dirtyRect];
    [self setWidth:self.tableView.width];
    NSRect f = self.bounds;
    
    [[self bgColor] set];
    [NSBezierPath fillRect:f];
    
    NSString *title = [self.node nodeTitle];
    NSString *subtitle = [self.node nodeSubtitle];
    
    CGFloat leftMargin = self.bounds.size.height * self.leftMarginRatio;
    
    NSImage *icon = nil; //[self icon];
    
    if (icon)
    {
        CGPoint center = CGPointMake((f.origin.x + (f.size.width / 2)),
                                     (f.origin.y + (f.size.height / 2)));
        
        CGFloat w = icon.size.width;
        CGFloat h = icon.size.height;
        
        NSRect r = NSMakeRect(center.x - w/2, center.y -h/2 , w, h);
        
        [icon drawInRect:r];
        return;
    }
    
    if (!subtitle)
    {
        NSDictionary *titleAttributes = [self titleAttributes];
        CGFloat fontSize = [(NSFont *)[titleAttributes objectForKey:NSFontAttributeName] pointSize];
        
        
        
        [title drawAtPoint:NSMakePoint(self.bounds.origin.x+leftMargin,
                                       self.bounds.origin.y + self.bounds.size.height/2.0 - fontSize/2.0 - 5)
            withAttributes:titleAttributes];
    }
    else
    {
        NSDictionary *titleAttributes = [self titleAttributes];
        CGFloat fontSize = [(NSFont *)[titleAttributes objectForKey:NSFontAttributeName] pointSize];
        
        title = [self string:title
              clippedToWidth:f.size.width*.5
               forAttributes:titleAttributes];
        
        [title drawAtPoint:NSMakePoint(self.bounds.origin.x + leftMargin,
                                       self.bounds.origin.y + self.bounds.size.height*.2 - fontSize/2.0 - 3)
            withAttributes:titleAttributes];
        
        NSDictionary *subtitleAttributes = [self subtitleAttributes];
        CGFloat subtitleFontSize = [(NSFont *)[subtitleAttributes objectForKey:NSFontAttributeName] pointSize];
        
        [subtitle drawAtPoint:NSMakePoint(self.bounds.origin.x + leftMargin,
                                          self.bounds.origin.y + self.bounds.size.height*.6 - subtitleFontSize/2.0 - 3)
               withAttributes:subtitleAttributes];
    }
    
    if ([self.node respondsToSelector:@selector(nodeNote)])
    {
        NSString *note = [self.node nodeNote];
        if (note)
        {
            CGFloat rightMargin = 30;
            NSDictionary *noteAttributes = [self noteAttributes];
            CGFloat fontSize = [(NSFont *)[noteAttributes objectForKey:NSFontAttributeName] pointSize];
            
            CGFloat width = [[[NSAttributedString alloc] initWithString:note attributes:noteAttributes] size].width;
            
            
            [note drawAtPoint:NSMakePoint(self.bounds.origin.x + f.size.width - width - rightMargin,
                                          self.bounds.origin.y + self.bounds.size.height*.5 - fontSize/2.0 - 6)
               withAttributes:noteAttributes];
        }
    }
}

- (NSString *)string:(NSString *)s
      clippedToWidth:(CGFloat)maxWidth
       forAttributes:(NSDictionary *)att
{
    NSUInteger fullLength = [s length];
    
    while ([s length])
    {
        CGFloat width = [[[NSAttributedString alloc] initWithString:s attributes:att] size].width;
        
        if (width < maxWidth)
        {
            if ([s length] < fullLength)
            {
                return [s stringByAppendingString:@"..."];
            }
            return s;
        }
        
        s = [s substringToIndex:[s length] -1];
    }
    
    return @"";
}

// --- mouse down ---

/*
- (BOOL)trackMouse:(NSEvent *)theEvent inRect:(NSRect)cellFrame ofView:(NSView *)controlView untilMouseUp:(BOOL)untilMouseUp
{
    NSLog(@"NSCell trackMouse"); // why isn't this working?
    return NO;
}

- (BOOL)startTrackingAt:(NSPoint)startPoint inView:(NSView *)controlView
{
    NSLog(@"NSCell startTrackingAt"); // why isn't this working?
    return NO;
}

+ (BOOL)prefersTrackingUntilMouseUp
{
    return YES; // why isn't this working?
}
*/

@end
