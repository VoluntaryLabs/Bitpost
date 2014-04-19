//
//  AddressCompletor.m
//  Bitmessage
//
//  Created by Steve Dekorte on 2/24/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "AddressCompletor.h"
#import <BitmessageKit/BitmessageKit.h>
#import <NavKit/NavKit.h>


@implementation AddressCompletor

- (id)init
{
    self = [super init];
    //self.addressLabels = [[BMClient sharedBMClient] addressLabels];
    return self;
}

- (void)setTextField:(NSTextField *)textField
{
    _textField = (AddressTextField *) textField;
    [_textField setDelegate:self];
}

- (NSString *)selectedString
{
    NSText *text = [self.textField.window fieldEditor:YES forObject:self.textField];
    NSRange r = [text selectedRange];
    return [[self.textField stringValue] substringWithRange:r];
}

- (NSString *)unselectedString
{
    NSText *text = [self.textField.window fieldEditor:YES forObject:self.textField];
    NSRange r = [text selectedRange];
    return [[text string] substringWithRange:NSMakeRange(0, r.location)]; // correct?
}

- (void)controlTextDidChange:(NSNotification *)note
{
    if (self.isCompleting)
    {
        return;
    }
    else
    {
        self.shouldComplete = YES;
        
        if (self.textField.eventIsDelete)
        {
            //NSLog(@"delete - returning");
            self.shouldComplete = NO;
        }

        if (self.textField.eventIsSpace)
        {
            //NSLog(@"space - returning");
            self.textField.stringValue = [self.textField.stringValue stringByAppendingString:@" "];
            self.shouldComplete = NO;
        }
        
        if (self.textField.eventIsTab)
        {
            [[self.textField nextKeyView] becomeFirstResponder];
            self.shouldComplete = NO;
        }
        
        if (self.shouldComplete)
        {
            self.isCompleting = YES;
            
            //NSText *text = [self.textField.window fieldEditor:YES forObject:self.textField];
            id editor = [[note userInfo] objectForKey:@"NSFieldEditor"];
            if ([editor respondsToSelector:@selector(complete:)])
            {
                [editor complete:nil];
            }
            else
            {
                NSLog(@"can't call complete:");
            }
            
            self.isCompleting = NO;
        }
    }
    
    if (self.isValid)
    {
        /*
        self.textField.textColor = [NavTheme.sharedNavTheme formText2Color];
        [self.textField setFont:[NSFont fontWithName:[NavTheme.sharedNavTheme lightFontName] size:self.textField.font.pointSize]];
        */
        [self.textField setThemePath:@"draft/field"];
    }
    else
    {
        /*
        self.textField.textColor = [NavTheme.sharedNavTheme formTextErrorColor];
        [self.textField setFont:[NSFont fontWithName:@"Open Sans Bold" size:self.textField.font.pointSize]];
        */
        [self.textField setThemePath:@"draft/fieldError"];
    }
    
    [self.textField resetEventCharacter];
}

- (NSArray *)control:(NSControl *)control
            textView:(NSTextView *)textView
         completions:(NSArray *)words
 forPartialWordRange:(NSRange)charRange
 indexOfSelectedItem:(NSInteger *)index
{
    if (!self.shouldComplete)
    {
        //NSLog(@"skip complete");
        return [NSArray array];
    }
    
    NSMutableArray *matches = [NSMutableArray array];
    NSInteger end = charRange.location + charRange.length;
    NSRange fullRange = NSMakeRange(0, end);
    
    NSString *full = [[textView string] substringWithRange:fullRange];
    NSString *selected = [[textView string] substringWithRange:charRange];
    
    //NSLog(@"selected '%@' full '%@'", selected, full);
    
    for (NSString *label in self.addressLabels)
    {
        
        if ([full containsString:@" "])
        {
            NSArray *words = [label componentsSeparatedByString:@" "];
            
            for (NSString *word in words)
            {
                if (word.length && [[word lowercaseString] hasPrefix:[selected lowercaseString]])
                {
                    [matches addObject:word];
                }
            }
        }
        else
        {
            if (label.length && [[label lowercaseString] hasPrefix:[full lowercaseString]])
            {
                [matches addObject:label];
            }
        }
    }
    
    return matches;
}

- (BOOL)isMatched
{
    NSString *selected = [self.textField stringValue];
    
    for (NSString *label in self.addressLabels)
    {
        if ([label isEqualToString:selected])
        {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)isValid
{
    return self.isMatched || [BMAddress isValidAddress:[self.textField.stringValue strip]];
}

- (void)textDidEndEditing:(NSNotification *)notification
{
    [self.textField textDidEndEditing:notification];
}

//- (BOOL)textView:(NSTextView *)aTextView doCommandBySelector:(SEL)aSelector
- (BOOL)control:(NSControl *)control textView:(NSTextView *)textView doCommandBySelector:(SEL)command
{
    //NSLog(@"command '%@'", NSStringFromSelector(command));
    
    if (command == @selector(insertTab:) || command == @selector(insertNewline:))
    {
        NSView *next = self.textField.nextKeyView;
        //NSLog(@"selectNextKeyView %@", next);
        [next becomeFirstResponder];
        //[[self window] selectNextKeyView:nil];
        return YES;
    }
    
    return NO;
}

-(void)controlTextDidEndEditing:(NSNotification *)notification
{
    // See if it was due to a return
    if ( [[[notification userInfo] objectForKey:@"NSTextMovement"] intValue] == NSReturnTextMovement )
    {
        //NSLog(@"Return was pressed!");
    }
}

@end
