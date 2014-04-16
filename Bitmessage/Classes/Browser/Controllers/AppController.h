#import <Cocoa/Cocoa.h>
#import <BitmessageKit/BitmessageKit.h>
#import "NavView.h"
#import "DraftController.h"
#import "ProgressController.h"

@interface AppController : NSObject <NSTableViewDataSource>

@property (strong) id <NavNode> rootNode;
@property (strong) IBOutlet NavView *navView;

@property (strong) IBOutlet NSProgressIndicator *progress;
@property (strong) ProgressController *progressController;
@property (strong) NSDockTile *dockTile;

@property (strong) NSAlert *alertPanel;

- (DraftController *)newDraft;

- (NSInteger)unreadMessageCount;

- (IBAction)openInfoPanel:(id)sender;
- (IBAction)compose:(id)sender;


- (IBAction)exportMailbox:(id)sender;
- (IBAction)importMailbox:(id)sender;

@end
