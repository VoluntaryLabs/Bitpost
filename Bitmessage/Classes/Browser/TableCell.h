
#import <Cocoa/Cocoa.h>
#import "NavView.h"

@interface TableCell : NSBrowserCell

@property (assign, nonatomic) CGFloat leftMarginRatio;
@property (assign, nonatomic) id <NavNode> node;
@property (assign, nonatomic) BOOL isSelected;

- (void)setupMenu;

@end
