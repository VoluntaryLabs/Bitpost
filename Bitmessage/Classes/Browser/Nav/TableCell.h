
#import <Cocoa/Cocoa.h>
#import "NavView.h"

@class NavColumn;

@interface TableCell : NSBrowserCell

@property (assign, nonatomic) CGFloat leftMarginRatio;
@property (assign, nonatomic) id <NavNode> node;
@property (assign, nonatomic) NavColumn *navColumn;
@property (assign, nonatomic) BOOL isSelected;

- (void)setupMenu;

@end
