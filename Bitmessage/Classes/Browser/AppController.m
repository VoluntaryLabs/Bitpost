
#import "AppController.h"
#import "BMClient.h"
#import "DraftController.h"
#import "NavColumn.h"

@implementation AppController

- (void)awakeFromNib
{
    [self.navView setRootNode:(id <NavNode>)[BMClient sharedBMClient]];
    self.drafts = [NSMutableArray array];
    
    NavColumn *firstNavColumn = [[self.navView navColumns] firstObject];
    [firstNavColumn selectRowIndex:0];
 
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(draftClosed:)
                                                 name:@"draftClosed"
                                               object:nil];
 
    //self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(timer:) userInfo:Nil repeats:YES];
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
    //return; // temporarily disable until sysconfig issue is fixed
    
    NSBundle * mainBundle = [NSBundle mainBundle];
    
    _pybitmessage = [[NSTask alloc] init];
    NSDictionary *environmentDict = [[NSProcessInfo processInfo] environment];
    NSMutableDictionary *environment = [NSMutableDictionary dictionaryWithDictionary:environmentDict];
    NSLog(@"%@", [environment valueForKey:@"PATH"]);
    
    // Set environment variables containing api username and password
    [environment setObject: @"FOO" forKey:@"PYBITMESSAGE_USER"];
    [environment setObject: @"BAR" forKey:@"PYBITMESSAGE_PASSWORD"];
    [_pybitmessage setEnvironment: environment];
    
    // Set the path to the python executable
    NSString * pythonPath = [mainBundle pathForResource:@"python" ofType:@"exe" inDirectory: @"static-python"];
    NSString * pybitmessagePath = [mainBundle pathForResource:@"bitmessagemain" ofType:@"py" inDirectory: @"pybitmessage"];
    [_pybitmessage setLaunchPath:pythonPath];


    [_pybitmessage setArguments:@[ pybitmessagePath ]];
    [_pybitmessage launch];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    NSLog(@"Killing pybitmessage process...");
    [_pybitmessage terminate];
}

@end
