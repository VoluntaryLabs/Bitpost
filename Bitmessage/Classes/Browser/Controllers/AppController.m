
#import "AppController.h"
#import "BMClient.h"
#import "DraftController.h"
#import "NavColumn.h"
#import "InfoPanelController.h"
#import "BMNewUserView.h"
//#import "BMInfoPanel.h"

@implementation AppController

- (void)awakeFromNib
{
    self.progressController = [[ProgressController alloc] init];
    [self.progressController setProgress:self.progress];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ProgressPush" object:self];
    
    self.dockTile = [[NSApplication sharedApplication] dockTile];
}

- (void)handleAction:(SEL)aSelector
{
    [self.navView handleAction:aSelector];
}

- (BOOL)canHandleAction:(SEL)aSelector
{
    return [self.navView canHandleAction:aSelector];
}

- (DraftController *)newDraft
{
    DraftController *draft = [DraftController openNewDraft];
    return draft;
}

- (void)applicationDidFinishLaunching: (NSNotification *)aNotification
{
    //[self openInfoPanel:nil];

    [self connectToServer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(unreadCountChanged:)
                                                 name:@"BMReceivedMessagesUnreadCountChanged"
                                               object:BMClient.sharedBMClient.messages.received];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ProgressPop" object:self];    
}


- (void)connectToServer
{
    [self.navView.window setTitle:@"launching server..."];
    [self.navView.window display];

    //self.bitmessageProcess = [BMServerProcess sharedBMServerProcess];
    //[self.bitmessageProcess launch];

    //[self.navView.window setTitle:@"connecting to server..."];
    //[self.navView.window display];

    
    [self.navView setRootNode:(id <NavNode>)[BMClient sharedBMClient]];
    //self.drafts = [NSMutableArray array];
    
    NavColumn *firstNavColumn = [[self.navView navColumns] firstObject];
    [firstNavColumn selectRowIndex:0];
    
    [self.navView.window setTitle:@""];

    [self checkForNewUser];
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
    BMNewUserView *nuv = [[BMNewUserView alloc] initWithFrame:self.navView.frame];
    nuv.replacementView = self.navView;
    [nuv open];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    [[BMClient sharedBMClient] stopServer];
}

- (NSInteger)unreadMessageCount
{
    return [[[[BMClient sharedBMClient] messages] received] unreadCount];
}

- (void)unreadCountChanged:(NSNotification *)note
{
    // replace with notification -> sound mapping with theme lookup
    NSLog(@"unreadCountChanged");
    [self displayUnreadMessageCountBadge];
}

- (void)displayUnreadMessageCountBadge
{
    NSInteger unreadMessageCount = [self unreadMessageCount];
    
    if (unreadMessageCount > 0)
    {
        [self.dockTile setBadgeLabel:[NSString stringWithFormat: @"%ld",
                                      (long)unreadMessageCount]];
    }
    else
    {
        [self.dockTile setBadgeLabel: nil];
    }
}

- (IBAction)openInfoPanel:(id)sender
{
    [[InfoPanelController sharedInfoPanelController] open];
}

- (IBAction)compose:(id)sender // hack - consolidate into DraftController
{
    AppController *appController = (AppController *)[[NSApplication sharedApplication] delegate];
    DraftController *draft = [appController newDraft];
    [draft setDefaultFrom];
    [draft setCursorOnTo];
    [draft open];
}

@end
