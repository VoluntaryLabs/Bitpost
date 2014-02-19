
#import "AppController.h"
#import "BMClient.h"
#import "DraftController.h"
#import "NavColumn.h"
#import "InfoPanelController.h"

@implementation AppController

- (void)awakeFromNib
{


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
    //InstallSignalnHandler();
    self.bitmessageProcess = [[BMServerProcess alloc] init];
    [self.bitmessageProcess launch];

    //[self connectToServer];
    [self performSelector:@selector(connectToServer) withObject:self afterDelay:1];
    //[[BMClient sharedBMClient] performSelector:@selector(refresh) withObject:self afterDelay:1];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(draftClosed:)
                                                 name:@"draftClosed"
                                               object:nil];
}


- (void)connectToServer
{
    [self.navView setRootNode:(id <NavNode>)[BMClient sharedBMClient]];
    self.drafts = [NSMutableArray array];
    
    NavColumn *firstNavColumn = [[self.navView navColumns] firstObject];
    [firstNavColumn selectRowIndex:0];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(timer:) userInfo:Nil repeats:YES];
}

- (void)timer:(id)sender
{
    NSLog(@"timer start");
    //[[[[BMClient sharedBMClient] messages] received] refresh];
    NSLog(@"timer stop");
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

- (IBAction)openInfoPanel:(id)sender
{
    [[InfoPanelController sharedInfoPanelController] open];
}


void SignalHandler(int signal)
{
    printf("SignalHandler caught signal - shutting down server and exiting\n");
    AppController *self = (AppController *)[[NSApplication sharedApplication] delegate];
    [self killServer];
    exit(0);
}

void InstallSignalnHandler()
{
    printf("InstallUncaughtExceptionHandler\n");
	signal(SIGABRT, SignalHandler);
	signal(SIGILL, SignalHandler);
	signal(SIGSEGV, SignalHandler);
	signal(SIGFPE, SignalHandler);
	signal(SIGBUS, SignalHandler);
	signal(SIGPIPE, SignalHandler);
}

@end
