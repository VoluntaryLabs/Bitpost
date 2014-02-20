
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
    self.bitmessageProcess = [BMServerProcess sharedBMServerProcess];
    [self.bitmessageProcess launch];

    //[self connectToServer];
    [self performSelector:@selector(connectToServer) withObject:self afterDelay:1];
    //[[BMClient sharedBMClient] performSelector:@selector(refresh) withObject:self afterDelay:1];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(draftClosed:)
                                                 name:@"draftClosed"
                                               object:nil];
 
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(unreadCountChanged:)
                                                 name:@"BMReceivedMessagesUnreadCountChanged"
                                               object:nil];
    
}


- (void)connectToServer
{
    [self.navView.window setTitle:@"connecting..."];
    
    [self.navView setRootNode:(id <NavNode>)[BMClient sharedBMClient]];
    self.drafts = [NSMutableArray array];
    
    NavColumn *firstNavColumn = [[self.navView navColumns] firstObject];
    [firstNavColumn selectRowIndex:0];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(timer:) userInfo:Nil repeats:YES];
    [self.navView.window setTitle:@""];
}

- (void)timer:(id)sender
{
    NSLog(@"timer start");
    //[self.navView updateActionStrip];
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

- (void)unreadCountChanged:(NSNotification *)note
{
    NSLog(@"unreadCountChanged");
    
    NSSound *newMessageSound = [[NSSound alloc] initWithContentsOfFile:@"/System/Library/Components/CoreAudio.component/Contents/SharedSupport/SystemSounds/dock/drag to trash.aif" byReference:YES];
    [newMessageSound play];
}

- (IBAction)openInfoPanel:(id)sender
{
    [[InfoPanelController sharedInfoPanelController] open];
}

void SignalHandler(int signal)
{
    printf("SignalHandler caught signal %i - shutting down server and exiting \n", signal);
    AppController *self = (AppController *)[[NSApplication sharedApplication] delegate];
    [self killServer];
    //exit(0);
}

void InstallSignalnHandler()
{
    printf("InstallSignalnHandler\n");
	signal(SIGABRT, SignalHandler);
	signal(SIGALRM, SignalHandler);
	signal(SIGVTALRM, SignalHandler);
	signal(SIGPROF, SignalHandler);
	signal(SIGBUS, SignalHandler);
	signal(SIGCHLD, SignalHandler);
	signal(SIGFPE, SignalHandler);
	signal(SIGHUP, SignalHandler);
	signal(SIGILL, SignalHandler);
	signal(SIGINT, SignalHandler);
	signal(SIGKILL, SignalHandler);
    
    //prctl(PR_SET_PDEATHSIG, SIGKILL)
    
	signal(SIGPIPE, SignalHandler);
	signal(SIGQUIT, SignalHandler);
	signal(SIGSEGV, SignalHandler);
	signal(SIGSTOP, SignalHandler);
	signal(SIGTERM, SignalHandler);
	signal(SIGTSTP, SignalHandler);

    signal(SIGTTIN, SignalHandler);
	signal(SIGTTOU, SignalHandler);
    
	signal(SIGUSR1, SignalHandler);
	signal(SIGUSR2, SignalHandler);

	//signal(SIGPOLL, SignalHandler);
	signal(SIGSYS, SignalHandler);
	signal(SIGTRAP, SignalHandler);
    
	signal(SIGURG, SignalHandler);
	signal(SIGXCPU, SignalHandler);
	signal(SIGXFSZ, SignalHandler);

    //signal(SIGRTMIN, SignalHandler);
	//signal(SIGRTMAX, SignalHandler);
}

@end
