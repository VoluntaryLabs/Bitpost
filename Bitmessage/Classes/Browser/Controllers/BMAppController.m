
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
    BMNode *root = [BMClient sharedBMClient];
    [self setRootNode:(NavNode *)root];
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

- (IBAction)compose:(id)sender // hack - consolidate into BMDraftController
{
    [(BMClient *)self.rootNode compose];
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
