
#import "AppController.h"
#import <BitmessageKit/BitmessageKit.h>
#import <NavKit/NavKit.h>
#import "DraftController.h"
#import "BMNewUserView.h"
#import "NavInfoNode.h"
#import "BMClient+UI.h"

@implementation AppController

- (void)awakeFromNib
{
}

- (void)applicationDidFinishLaunching: (NSNotification *)aNote
{
    [super applicationDidFinishLaunching:aNote];
    
    [self setNavTitle:@"launching server..."];
    BMNode *root = [BMClient sharedBMClient];
    [self setRootNode:(id <NavNode>)root];
    [self setNavTitle:@""];
    
    [self addAbout];
    
    [self checkForNewUser];
}


- (void)addAbout
{
    NavInfoNode *about = [[NavInfoNode alloc] init];
    [(BMNode *)self.rootNode addChild:about];
    about.nodeTitle = @"About";
    about.nodeSuggestedWidth = 150;

    NavInfoNode *contributors = [[NavInfoNode alloc] init];
    [about addChild:contributors];
    contributors.nodeTitle = @"Contributors";
    contributors.nodeSuggestedWidth = 200;

    
    {
        NavInfoNode *contributor = [[NavInfoNode alloc] init];
        contributor.nodeTitle = @"Chris Robinson";
        contributor.nodeSubtitle = @"Designer";
        [contributors addChild:contributor];
    }
    
    {
        NavInfoNode *contributor = [[NavInfoNode alloc] init];
        contributor.nodeTitle = @"Steve Dekorte";
        contributor.nodeSubtitle = @"Lead / UI Dev";
        [contributors addChild:contributor];
    }
    
    {
        NavInfoNode *contributor = [[NavInfoNode alloc] init];
        contributor.nodeTitle = @"Adam Thorsen";
        contributor.nodeSubtitle = @"Generalist";
        [contributors addChild:contributor];
    }
    
    {
        NavInfoNode *contributor = [[NavInfoNode alloc] init];
        contributor.nodeTitle = @"Dru Nelson";
        contributor.nodeSubtitle = @"Unix Guru";
       [contributors addChild:contributor];
    }

}

- (void)checkForNewUser
{
    if ([[BMClient sharedBMClient] hasNoIdentites] ||
        [[[[BMClient sharedBMClient] identities] firstIdentity] hasUnsetLabel])
    {
        [self openNewUserView];
    }
}

- (void)openNewUserView
{
    BMNewUserView *nuv = [[BMNewUserView alloc] initWithFrame:self.navWindow.navView.frame];
    nuv.replacementView = self.navWindow.navView;
    [nuv open];
    
}

- (IBAction)compose:(id)sender // hack - consolidate into DraftController
{
    [(BMClient *)self.rootNode compose];
}

// import/export

- (IBAction)exportMailbox:(id)sender
{
    NSOpenPanel* panel = [NSOpenPanel openPanel];
    [panel setCanChooseDirectories:YES];
    [panel setCanChooseFiles:NO];
    [panel setAllowsMultipleSelection:NO];
    [panel setMessage:@"Choose a folder to place your exported mailbox file in"];
    
    NSWindow *window = [[NSApplication sharedApplication] mainWindow];
    [panel beginSheetModalForWindow:window completionHandler:^(NSInteger result)
     {
         if (result == NSFileHandlingPanelOKButton)
         {
             NSArray* urls = [panel URLs];
             NSURL *url = [urls firstObject];
             NSLog(@"url '%@'", url);
             [[BMClient sharedBMClient] archiveToUrl:url];
         }
     }];
}

- (IBAction)importMailbox:(id)sender // import by double clicking on file instead?
{
    //[self performSelector:@selector(confirmImport) withObject:nil afterDelay:0.01];
}

- (void)confirmImport
{
    NSAlert *alert = [[NSAlert alloc] init];
    self.alertPanel = alert;
    [alert addButtonWithTitle:@"Import Mailbox"];
    [alert addButtonWithTitle:@"Cancel"];
    [alert setMessageText:@"Are you sure you want to replace your existing Bitmessage mailbox?"];
    [alert setInformativeText:@"CAUTION: This operation will delete your current Bitmessage mailbox and any identities you have in it. This will destroy the private keys for those identities making any mail sent to them permanently unreadable."];
    [alert setAlertStyle:NSWarningAlertStyle];
    
    NSWindow *window = [[NSApplication sharedApplication] mainWindow];
    
    [alert beginSheetModalForWindow:window completionHandler:^(NSInteger returnCode)
    {
        // 1000 = OK
        // 10001 = Cancel
        // why doesn't NSModalResponseContinue have this value?
        
        if (returnCode == 1000)
        {
            [self doImport];
        }
    }];
    
    /*
    if ([alert runModal] == NSAlertFirstButtonReturn)
    {
        [self doImport];
    }
    */
}

- (void)doImport
{
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setCanChooseDirectories:NO];
    [panel setCanChooseFiles:YES];
    [panel setAllowsMultipleSelection:NO];
    [panel setMessage:@"Choose a .bmbox file to import"];
    
    NSWindow *window = [[NSApplication sharedApplication] mainWindow];
    [panel beginSheetModalForWindow:window completionHandler:^(NSInteger result)
    {
        if (result == NSFileHandlingPanelOKButton)
        {
            NSArray *urls = [panel URLs];
            NSURL *url    = [urls firstObject];
            NSLog(@"url '%@'", url);
            [[BMClient sharedBMClient] unarchiveFromUrl:url];
        }
        
    }];
}

/*
- (BOOL)application:(NSApplication *)theApplication openFile:(NSString *)filename
{
    NSLog(@"open '%@'", filename);
    return YES;
}

- (void)application:(NSApplication *)sender openFiles:(NSArray *)filenames
{
    NSLog(@"open filenames");
}
*/

@end
