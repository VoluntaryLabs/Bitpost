

#import <Cocoa/Cocoa.h>
#import "NavView.h"
#import "DraftController.h"


@interface AppController : NSObject <NSTableViewDataSource>

@property (strong) id <NavNode> rootNode;
@property (strong) IBOutlet NavView *navView;
@property (strong) NSMutableArray *drafts;

// actions

/*
@property (strong) IBOutlet NSView *trash;
@property (strong) IBOutlet NSView *reply;
@property (strong) IBOutlet NSView *add;

- (IBAction)trash:(id)sender;
- (IBAction)reply:(id)sender;
- (IBAction)add:(id)sender;
*/

- (DraftController *)newDraft;

@end
