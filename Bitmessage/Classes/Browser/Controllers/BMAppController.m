
#import "BMAppController.h"
#import <BitmessageKit/BitmessageKit.h>
#import <NavKit/NavKit.h>
#import "BMDraftController.h"
#import "BMNewUserView.h"
#import "BMClient+NodeView.h"

@implementation BMAppController

- (void)applicationDidFinishLaunching: (NSNotification *)aNote
{
    [super applicationDidFinishLaunching:aNote];
    
    [self setNavTitle:@"launching server..."];
    BMNode *root = BMClient.sharedBMClient;
    [self setRootNode:(NavNode *)root];
    [self setNavTitle:@""];
    [self addAbout];
    
    [self checkForNewUser];
    [NSAppleEventManager.sharedAppleEventManager setEventHandler:self
                                                     andSelector:@selector(composeFromURL:)
                                                   forEventClass:kInternetEventClass
                                                      andEventID:kAEGetURL];
}

- (void)addAbout
{
    NavInfoNode *about = [[NavInfoNode alloc] init];
    about.nodeTitle = @"About";
    about.nodeSuggestedWidth = 200;
 
    NavInfoNode *info = (NavInfoNode *)BMClient.sharedBMClient.nodeAbout;
    [about addChild:info];
    
    [self.rootNode addChild:about];
}

- (void)checkForNewUser
{
    if (BMClient.sharedBMClient.hasNoIdentites ||
        BMClient.sharedBMClient.identities.firstIdentity.hasUnsetLabel)
    {
        [self openNewUserView];
    }
    
    //[BMClient.sharedBMClient.channels channelWithPassphraseJoinIfNeeded:@"Bitpost"];
    BMSubscription *sub = [BMClient.sharedBMClient.subscriptions subscriptionWithAddressAddIfNeeded:@"BM-2cWfHSiKkbXoUmwiqPAqdhZyRUoShQmPr5"];
    [sub setLabel:@"Bitpost releases"];

}

- (void)openNewUserView
{
    /*
    BMIdentity *identity = [BMClient.sharedBMClient.identities createFirstIdentityIfAbsent];
    
    if (identity.hasUnsetLabel)
    {
        identity.label = NSFullUserName();
        [identity update];
    }
    
    BMMessage *msg = [[BMMessage alloc] init];
    msg.toAddress = identity.address;
    msg.fromAddress = identity.address;
    msg.subject = @"Welcome to Bitpost";
    */
    
    {
        //NSRect f = self.navWindow.backgroundView.frame;
        BMNewUserView *nuv = [[BMNewUserView alloc] initWithFrame:self.navWindow.backgroundView.frame];
        [nuv setAutoresizesSubviews:YES];
        nuv.targetWindow = self.navWindow;
        [nuv open];
    }
}

- (IBAction)compose:(id)sender // hack - consolidate into BMDraftController
{
    [(BMClient *)self.rootNode compose];
}

- (IBAction)composeBroadcast:(id)sender // hack - consolidate into BMDraftController
{
    [(BMClient *)self.rootNode composeBroadcast];
}

- (void)composeFromURL:(NSAppleEventDescriptor *)event
{
    NSURL *url = [NSURL URLWithString:[[event paramDescriptorForKeyword:keyDirectObject] stringValue]];
    [(BMClient *)self.rootNode composeWithAddress: [url host]];
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
