
#import "AppController.h"
#import "BMClient.h"
#import "DraftController.h"
#import "NavColumn.h"
#import "InfoPanelController.h"

@implementation AppController

- (void)awakeFromNib
{
    self.progressController = [[ProgressController alloc] init];
    [self.progressController setProgress:self.progress];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ProgressPush" object:self];
}

- (void)draftClosed:(NSNotification *)note
{
    [self.drafts removeObject:[note object]];
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
    DraftController *draft = [[DraftController alloc] initWithNibName:@"Compose" bundle:nil];
    [[[draft view] window] makeKeyAndOrderFront:self];
    [self.drafts addObject:draft];
    return draft;
}

- (void)applicationDidFinishLaunching: (NSNotification *)aNotification
{
    self.bitmessageProcess = [BMServerProcess sharedBMServerProcess];
    [self.bitmessageProcess launch];

    [self connectToServer];
    //[self performSelector:@selector(connectToServer) withObject:self afterDelay:1];
    //[[BMClient sharedBMClient] performSelector:@selector(refresh) withObject:self afterDelay:1];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(draftClosed:)
                                                 name:@"draftClosed"
                                               object:nil];
 
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
    self.drafts = [NSMutableArray array];
    
    NavColumn *firstNavColumn = [[self.navView navColumns] firstObject];
    [firstNavColumn selectRowIndex:0];
    
    [self startRefreshTimer];
    [self.navView.window setTitle:@""];
}

- (void)startRefreshTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0
                                                  target:self
                                                selector:@selector(timer:)
                                                userInfo:Nil
                                                 repeats:YES];
}

- (void)timer:(id)sender
{
    //NSLog(@"timer start");
    //[[[[BMClient sharedBMClient] messages] received] refresh];
    [[BMClient sharedBMClient] refresh];
    //NSSound *systemSound = [[NSSound alloc] initWithContentsOfFile:@"/System/Library/Components/CoreAudio.component/Contents/SharedSupport/SystemSounds/dock/drag to trash.aif" byReference:YES];
/*
 /System/Library/Sounds
 Here the list of sounds found in that directory:
 Basso
 Blow
 Bottle
 Frog
 Funk
 Glass
 Hero
 Morse
 Ping
 Pop
 Purr
 Sosumi
 Submarine
 Tink
 */
    //NSLog(@"timer stop");
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
    
    //NSSound *newMessageSound = [[NSSound alloc] initWithContentsOfFile:@"/System/Library/Components/CoreAudio.component/Contents/SharedSupport/SystemSounds/dock/drag to trash.aif" byReference:YES];
    
    //[newMessageSound play];
}

- (IBAction)openInfoPanel:(id)sender
{
    [[InfoPanelController sharedInfoPanelController] open];
}

@end
