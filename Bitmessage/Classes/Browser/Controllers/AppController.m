
#import "AppController.h"
#import "BMClient.h"
#import "DraftController.h"
#import "NavColumn.h"
#import "InfoPanelController.h"
#import "BMNewUserView.h"

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
    self.bitmessageProcess = [BMServerProcess sharedBMServerProcess];
    [self.bitmessageProcess launch];

    [self connectToServer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(unreadCountChanged:)
                                                 name:@"BMReceivedMessagesUnreadCountChanged"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ProgressPop" object:self];    
}


- (void)connectToServer
{
    [self.navView.window setTitle:@"connecting..."];
    
    [self.navView setRootNode:(id <NavNode>)[BMClient sharedBMClient]];
    //self.drafts = [NSMutableArray array];
    
    NavColumn *firstNavColumn = [[self.navView navColumns] firstObject];
    [firstNavColumn selectRowIndex:0];
    
    [self.navView.window setTitle:@""];

    [self checkForNewUser];
    //[self startRefreshTimer];
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

- (void)startRefreshTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0
                                                  target:self
                                                selector:@selector(refreshTimer:)
                                                userInfo:Nil
                                                 repeats:YES];
}

- (void)refreshTimer:(id)sender
{
    [[BMClient sharedBMClient] refresh];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    [self killServer];
}

- (void)killServer
{
    [self.timer invalidate];
    [self.bitmessageProcess terminate];
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
