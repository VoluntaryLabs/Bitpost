
#import "AppController.h"
#import "BMClient.h"
#import "DraftController.h"
#import "NavColumn.h"

@implementation AppController

- (void)awakeFromNib
{
    /*
 
    //self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(timer:) userInfo:Nil repeats:YES];
    
    NSMutableParagraphStyle *indented = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    
    NSFont *font = [NSFont fontWithName:@"Open Sans Light" size:25.0];
    NSDictionary *att = [NSDictionary dictionaryWithObjectsAndKeys:
                         [NSColor colorWithCalibratedWhite:.9 alpha:1.0], NSForegroundColorAttributeName,
                         font, NSFontAttributeName,
                         nil];
    
    [indented setAlignment:NSCenterTextAlignment];
    [indented setLineSpacing:1.0];
    [indented setParagraphSpacing:1.0];
    [indented setHeadIndent:0.0];
    [indented setTailIndent:0.0];
    //[indented setFirstLineHeadIndent:45.0];
    [indented setLineBreakMode:NSLineBreakByWordWrapping];
    
    [self.message markAsRead];
    
    NSMutableAttributedString *subjectString = [[NSMutableAttributedString alloc]
                                                initWithString:@"About Bitmessage"
                                                attributes:[self subjectAttributes]];
    
    
    NSMutableAttributedString *bodyString = [[NSMutableAttributedString alloc]
                                             initWithString:[@"\n" stringByAppendingString:self.message.messageString]
                                             attributes:[self bodyAttributes]];
    
    [subjectString appendAttributedString:bodyString];
    
    //NSMutableAttributedString *subjectString = [[NSMutableAttributedString alloc] initWithString:aString];
    
    //[subjectString setAttributes:[self subjectAttributes] range:NSMakeRange(0, [aString length])];
    
    [subjectString addAttribute:NSParagraphStyleAttributeName
                          value:indented
                          range:NSMakeRange(0, [subjectString length])];
    
    [self.infoText appendAttr]
    */
}

- (void)timer:(id)sender
{
    NSLog(@"timer start");
    [[[[BMClient sharedBMClient] messages] received] refresh];
    NSLog(@"timer stop");
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
    InstallSignalnHandler();
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
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    [self killServer];
}

- (void)killServer
{
    [self.bitmessageProcess terminate];
}

- (NSInteger)unreadMessageCount
{
    return [[[[BMClient sharedBMClient] messages] received] unreadCount];
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
