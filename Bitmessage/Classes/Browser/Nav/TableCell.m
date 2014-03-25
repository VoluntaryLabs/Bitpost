

#import "TableCell.h"
#import "NavColumn.h"
#import "Theme.h"

@implementation TableCell

- (id)init
{
    self = [super init];
    self.leftMarginRatio = 0.5;
    return self;
}


- (void)setupMenu
{
    /*
    BrowserNode *node = self.representedObject;
    
    if (node && node.actions.count)
    {
        NSMenu *menu = [[NSMenu alloc] initWithTitle:@"menu"];
        
        for (NSString *action in node.actions)
        {
            NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:action
                                                          action:NSSelectorFromString(action)
                                                   keyEquivalent:@""];
            
            [item setTarget:node];
            [menu addItem:item];
        }
        [self setMenu:menu];
    }
    */
}

- (NSColor *)textActiveColor
{
    if ([self.node respondsToSelector:@selector(textActiveColor)])
    {
        NSColor *color = [(id)self.node textActiveColor];
        if (color)
        {
            return color;
        }
    }
    
    return self.navColumn.themeDict.textActiveColor;
}

- (NSColor *)textColor
{
    if (self.node.nodeParentInlines)
    {
        return [NSColor colorWithCalibratedWhite:.7 alpha:1.0];
    }
    
    if ([self isHighlighted])
    {
        return self.textActiveColor;
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
        self.navColumn.themeDict.textActiveColor :
        self.navColumn.themeDict.textInactiveColor;
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

    return self.navColumn.themeDict.bgActiveColor;
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
    
    return self.navColumn.themeDict.bgInactiveColor;
}

- (NSColor *)bgColor
{
    return [self isHighlighted] ? [self bgColorActive] : [self bgColorInactive];
}

- (NSRect)expansionFrameWithFrame:(NSRect)cellFrame inView:(NSView *)view
{
    return NSZeroRect; // to remove tool tip
}

- (NSString *)fontName
{
    if ([self isHighlighted])
    {
        return [self.navColumn.themeDict activeFontName];
    }
    
    return [Theme.sharedTheme lightFontName];
}

- (NSDictionary *)titleAttributes
{
    CGFloat fontSize = 14.0;
    NSString *fontName = [self fontName];
    NSFont *font = [NSFont fontWithName:fontName size:fontSize];
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

- (CGFloat)indent
{
    if (self.node.nodeShouldIndent)
    {
        return 60.0;
    }
    return 30; // cellFrame.size.height * self.leftMarginRatio
}
- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    NSRect f = cellFrame;
    //f.origin.x -= 1;
    //f.origin.y -= 1;
    f.size.width = controlView.frame.size.width; // +1;
    //f.size.height += 1;
    
    
    [[self bgColor] set];
    NSRectFill(f);
    
    NSString *title = [self.node nodeTitle];
    NSString *subtitle = [self.node nodeSubtitle];
    
    CGFloat leftMargin = self.indent; //cellFrame.size.height * self.leftMarginRatio;
    //NSLog(@"indent %i", (int)(cellFrame.size.height * self.leftMarginRatio));

    NSImage *icon = nil; //[self icon];
    
    if (icon)
    {
        CGPoint center = CGPointMake((f.origin.x + (f.size.width / 2)),
                                     (f.origin.y + (f.size.height / 2)));

        CGFloat w = icon.size.width;
        CGFloat h = icon.size.height;
        
        //NSRect r = NSMakeRect(center.x/2 - w/2, center.y/2 -h/2, w, h);
        NSRect r = NSMakeRect(center.x - w/2, center.y -h/2 , w, h);
        
        [icon drawInRect:r];
        return;
    }
    
    if (!subtitle)
    {
        NSDictionary *titleAttributes = [self titleAttributes];
        CGFloat fontSize = [(NSFont *)[titleAttributes objectForKey:NSFontAttributeName] pointSize];
        

        
        [title drawAtPoint:NSMakePoint(cellFrame.origin.x+leftMargin,
                                      cellFrame.origin.y + cellFrame.size.height/2.0 - fontSize/2.0 - 5)
            withAttributes:titleAttributes];
    }
    else
    {
        NSDictionary *titleAttributes = [self titleAttributes];
        CGFloat fontSize = [(NSFont *)[titleAttributes objectForKey:NSFontAttributeName] pointSize];

        title = [self string:title
              clippedToWidth:f.size.width*.6
               forAttributes:titleAttributes];
        
        [title drawAtPoint:NSMakePoint(cellFrame.origin.x + leftMargin,
                                      cellFrame.origin.y + cellFrame.size.height*.2 - fontSize/2.0 - 3)
           withAttributes:titleAttributes];
        
        NSDictionary *subtitleAttributes = [self subtitleAttributes];
        CGFloat subtitleFontSize = [(NSFont *)[subtitleAttributes objectForKey:NSFontAttributeName] pointSize];
        
        subtitle = [self string:subtitle
              clippedToWidth:f.size.width*.7
               forAttributes:titleAttributes];
        
        [subtitle drawAtPoint:NSMakePoint(cellFrame.origin.x + leftMargin,
                                       cellFrame.origin.y + cellFrame.size.height*.6 - subtitleFontSize/2.0 - 3)
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

            
            [note drawAtPoint:NSMakePoint(cellFrame.origin.x + f.size.width - width - rightMargin,
                                           cellFrame.origin.y + cellFrame.size.height*.5 - fontSize/2.0 - 6)
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
