
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
}

- (void)draftClosed:(NSNotification *)note
{
    [self.drafts removeObject:[note object]];
}

- (void)handleAction:(SEL)aSel
{
    id firstResponder = [[[NSApplication sharedApplication] mainWindow] firstResponder];
    
    //NSLog(@"firstResponder %@", firstResponder);
    
    if (firstResponder && [firstResponder respondsToSelector:@selector(handleAction:)])
    {
        [firstResponder handleAction:aSel];
    }
    
    DraftController *draft = [DraftController alloc];
    draft = [draft initWithNibName:@"Compose" bundle:nil];
    NSView *view = [draft view];
    NSWindow *window = [view window];
    //[window makeKeyAndOrderFront:self];
    //[window performSelector:@selector(makeKeyAndOrderFront:) withObject:self afterDelay:2];
    //[NSBundle loadNibNamed:@"Compose" owner:dc topLevelObjects:nil];
    //NSNib *nib = [[NSNib alloc] initWithNibNamed:@"Compose" bundle:nil];
    //NSLog(@"nib = %@", nib);
    
    [self.drafts addObject:draft];
}

- (IBAction)trash:(id)sender
{
    [self handleAction:@selector(trash)];
}

- (IBAction)reply:(id)sender
{
    [self handleAction:@selector(reply)];
}

- (IBAction)add:(id)sender
{
    [self handleAction:@selector(add)];
}

@end
