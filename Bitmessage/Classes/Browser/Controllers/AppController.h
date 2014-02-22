#import <Cocoa/Cocoa.h>
#import "NavView.h"
#import "DraftController.h"
#import "BMServerProcess.h"
#import "ProgressController.h"

@interface AppController : NSObject <NSTableViewDataSource>

@property (strong) id <NavNode> rootNode;
@property (strong) IBOutlet NavView *navView;
@property (strong) NSMutableArray *drafts;
@property (strong) NSTimer *timer;
@property (strong) BMServerProcess *bitmessageProcess;
@property (strong) IBOutlet NSTextView *infoText;

@property (strong) IBOutlet NSProgressIndicator *progress;
@property (strong) ProgressController *progressController;
@property (strong) NSDockTile *dockTile;

- (DraftController *)newDraft;

- (NSInteger)unreadMessageCount;

- (IBAction)openInfoPanel:(id)sender;

@end
