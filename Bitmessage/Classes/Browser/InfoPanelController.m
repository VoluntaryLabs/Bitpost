//
//  InfoPanelController.m
//  Bitmessage
//
//  Created by Steve Dekorte on 2/18/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "InfoPanelController.h"

@implementation InfoPanelController

static InfoPanelController *shared = nil;

+ (InfoPanelController *)sharedInfoPanelController
{
    if (!shared)
    {
        shared = [[InfoPanelController alloc] initWithNibName:@"Info" bundle:nil];
    }
    
    return shared;
}

- (NSWindow *)window
{
    return self.view.window;
}

- (NSTextView *)infoText
{
    return (NSTextView *)self.view;
}

- (void)open
{
    [self.window makeKeyAndOrderFront:self];
    [self.window center];
    [self.window setLevel:NSTornOffMenuWindowLevel];
}

- (NSDictionary *)subjectAttributes
{
    NSFont *font = [NSFont fontWithName:@"Open Sans" size:22.0];
    NSDictionary *att = [NSDictionary dictionaryWithObjectsAndKeys:
                         [NSColor colorWithCalibratedWhite:.3 alpha:1.0], NSForegroundColorAttributeName,
                         font, NSFontAttributeName,
                         nil];
    return att;
}

- (NSDictionary *)bodyAttributes
{
    NSFont *font = [NSFont fontWithName:@"Open Sans Light" size:16.0];
    NSDictionary *att = [NSDictionary dictionaryWithObjectsAndKeys:
                         [NSColor colorWithCalibratedWhite:.5 alpha:1.0], NSForegroundColorAttributeName,
                         font, NSFontAttributeName,
                         nil];
    return att;
}

- (NSDictionary *)bodyHeaderAttributes
{
    NSFont *font = [NSFont fontWithName:@"Open Sans Light" size:16.0];
    NSDictionary *att = [NSDictionary dictionaryWithObjectsAndKeys:
                         [NSColor colorWithCalibratedWhite:.3 alpha:1.0], NSForegroundColorAttributeName,
                         font, NSFontAttributeName,
                         nil];
    return att;
}

- (void)awakeFromNib
{
    [self.window setDelegate:self];
    [self.infoText setEditable:NO];
    
    [self.infoText setSelectedTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [NSColor colorWithCalibratedWhite:1.0 alpha:.05], NSBackgroundColorAttributeName,
      //[NSColor whiteColor], NSForegroundColorAttributeName,
      nil]];

     NSMutableParagraphStyle *indented = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
     
     [indented setAlignment:NSCenterTextAlignment];
     [indented setLineSpacing:1.0];
     [indented setParagraphSpacing:1.0];
     [indented setHeadIndent:0.0];
     [indented setTailIndent:0.0];
     //[indented setFirstLineHeadIndent:45.0];
     [indented setLineBreakMode:NSLineBreakByWordWrapping];
    
    
     NSMutableAttributedString *string = [[NSMutableAttributedString alloc]
         initWithString:@"\nBitMail\n\n"
         attributes:[self subjectAttributes]];
     

    [string appendAttributedString:[[NSMutableAttributedString alloc]
                                    initWithString:@"Design\n"
                                    attributes:[self bodyHeaderAttributes]]];
 
    [string appendAttributedString:[[NSMutableAttributedString alloc]
                                    initWithString:@"Chris Robinson\n\n"
                                    attributes:[self bodyAttributes]]];
    
    [string appendAttributedString:[[NSMutableAttributedString alloc]
                                    initWithString:@"Development\n"
                                    attributes:[self bodyHeaderAttributes]]];
    
    [string appendAttributedString:[[NSMutableAttributedString alloc]
                                    initWithString:@"Steve Dekorte\nAdam Thorsen"
                                    attributes:[self bodyAttributes]]];

    [string addAttribute:NSParagraphStyleAttributeName
                           value:indented
                           range:NSMakeRange(0, [string length])];
    
    [self.infoText setBackgroundColor:[NSColor colorWithCalibratedWhite:.1 alpha:1.0]];
    [[self.infoText textStorage] setAttributedString:string];
}


- (void)close
{
    [self.window orderOut:self];
}

- (BOOL)windowShouldClose:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"infoClosed" object:self];
    return YES;
}

@end
