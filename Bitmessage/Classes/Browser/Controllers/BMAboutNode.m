//
//  BMAboutNode.m
//  Bitmessage
//
//  Created by Steve Dekorte on 7/29/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "BMAboutNode.h"

@implementation BMAboutNode

- (id)init
{
    self = [super init];
    
    if (self)
    {
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    NavInfoNode *about = self;
    about.shouldSortChildren = NO;
    about.nodeTitle = @"About";
    about.nodeSuggestedWidth = 150;
    
    
    NavInfoNode *version = [[NavInfoNode alloc] init];
    [about addChild:version];
    version.nodeTitle = @"Version";
    
    NSDictionary *info = NSBundle.mainBundle.infoDictionary;
    NSString *versionString = [info objectForKey:@"CFBundleVersion"];
    version.nodeSubtitle = versionString;
    version.nodeSuggestedWidth = 200;
    
    NavInfoNode *contributors = [[NavInfoNode alloc] init];
    [about addChild:contributors];
    contributors.nodeTitle = @"Credits";
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
    
    
    NavInfoNode *others = [[NavInfoNode alloc] init];
    [contributors addChild:others];
    others.nodeTitle = @"3rd Party";
    others.nodeSuggestedWidth = 200;
    others.shouldSortChildren = NO;
    
    
    {
        NavInfoNode *package = [[NavInfoNode alloc] init];
        package.nodeTitle = @"Bitmessage";
        package.nodeSubtitle = @"bitmessage.org";
        [others addChild:package];
    }
    
    {
        NavInfoNode *package = [[NavInfoNode alloc] init];
        package.nodeTitle = @"Open Sans";
        package.nodeSubtitle = @"Steve Matteson, Google fonts";
        [others addChild:package];
    }
    
    {
        NavInfoNode *package = [[NavInfoNode alloc] init];
        package.nodeTitle = @"Python";
        package.nodeSubtitle = @"python.org";
        [others addChild:package];
    }
    
    {
        NavInfoNode *package = [[NavInfoNode alloc] init];
        package.nodeTitle = @"Tor";
        package.nodeSubtitle = @"torproject.org";
        [others addChild:package];
    }
    
    {
        NavInfoNode *package = [[NavInfoNode alloc] init];
        package.nodeTitle = @"XmlPRC";
        package.nodeSubtitle = @"Eric Czarny";
        [others addChild:package];
    }
    
    {
        NavInfoNode *package = [[NavInfoNode alloc] init];
        package.nodeTitle = @"ZipKit";
        package.nodeSubtitle = @"Karl Moskowski";
        [others addChild:package];
    }
    
    
    {
        NavInfoNode *help = [[NavInfoNode alloc] init];
        help.nodeTitle = @"Help";
        //what.nodeSubtitle = @"Designer";
        //[about addChild:help];
 
        
        {
            NavInfoNode *how = [[NavInfoNode alloc] init];
            how.nodeTitle = @"What's this app for?";
            //what.nodeSubtitle = @"Designer";
            [help addChild:how];
        }
        
        {
            NavInfoNode *how = [[NavInfoNode alloc] init];
            how.nodeTitle = @"How does Bitmessage work?";
            //what.nodeSubtitle = @"Designer";
            [help addChild:how];
        }
        
        {
            NavInfoNode *how = [[NavInfoNode alloc] init];
            how.nodeTitle = @"Protecting your privacy";
            //what.nodeSubtitle = @"Designer";
            [help addChild:how];
        }
        
        {
            NavInfoNode *how = [[NavInfoNode alloc] init];
            how.nodeTitle = @"How to contribute";
            //what.nodeSubtitle = @"Designer";
            [help addChild:how];
        }
    }
}

@end
