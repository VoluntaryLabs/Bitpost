#import <Cocoa/Cocoa.h>
#import <BitmessageKit/BitmessageKit.h>
#import <NavKit/NavKit.h>
#import "DraftController.h"

@interface AppController : NavAppController

// compose

- (IBAction)compose:(id)sender;

// import/export

@property (strong) NSAlert *alertPanel;

- (IBAction)exportMailbox:(id)sender;
- (IBAction)importMailbox:(id)sender;

@end
