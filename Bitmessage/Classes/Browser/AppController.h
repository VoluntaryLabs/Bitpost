

#import <Cocoa/Cocoa.h>
#import "NavView.h"
#import "DraftController.h"


@interface AppController : NSObject <NSTableViewDataSource>

@property (strong) id <NavNode> rootNode;
@property (strong) IBOutlet NavView *navView;
@property (strong) NSMutableArray *drafts;
@property (strong) NSTimer *timer;
@property (strong) NSTask *pybitmessage;

- (DraftController *)newDraft;

@end
