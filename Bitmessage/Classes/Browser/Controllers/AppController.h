#import <Cocoa/Cocoa.h>
#import <BitmessageKit/BitmessageKit.h>
#import <NavKit/NavKit.h>
#import "DraftController.h"
#import "ProgressController.h"

@interface AppController : NSObject <NSTableViewDataSource>

@property (strong) id <NavNode> rootNode;
@property (strong) NavWindow *navWindow;
@property (strong) ProgressController *progressController;
@property (strong) NSDockTile *dockTile;


- (NSInteger)unreadMessageCount;

// info

- (IBAction)openInfoPanel:(id)sender;

// compose

- (DraftController *)newDraft;
- (IBAction)compose:(id)sender;


// import/export

@property (strong) NSAlert *alertPanel;

- (IBAction)exportMailbox:(id)sender;
- (IBAction)importMailbox:(id)sender;

@end
