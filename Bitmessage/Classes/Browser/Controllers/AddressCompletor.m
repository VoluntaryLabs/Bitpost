//
//  AddressCompletor.m
//  Bitmessage
//
//  Created by Steve Dekorte on 2/24/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "AddressCompletor.h"
#import "BMClient.h"
#import "BMAddress.h"

@implementation AddressCompletor

- (id)init
{
    self = [super init];
    //self.addressLabels = [[BMClient sharedBMClient] addressLabels];
    return self;
}

- (void)setTextField:(NSTextField *)textField
{
    _textField = textField;
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
    //NSText *text = [self.textField.window fieldEditor:YES forObject:self.textField];
/*
    
    NSLog(@"selectedString = '%@'", self.selectedString);
    NSLog(@"unselectedString = '%@'", self.unselectedString);
 */
 
    /*
    self.isDeleting = (self.lastString != nil &&
                       self.lastString.length > self.unselectedString.length);
    
    //NSLog(@"last = %i current = %i", (int)self.lastString.length, (int)self.textField.stringValue.length);
    NSLog(@"last = '%@' current = '%@'", self.lastString, self.unselectedString);
    
    if (self.isDeleting)
    {
        NSLog(@"don't complete delete!");
        return;
    }
    
    self.lastString = self.unselectedString;
    */
    
    if(self.isCompleting)
    {
        return;
    }
    else
    {
        self.isCompleting = YES;
        //NSText *text = [self.textField.window fieldEditor:YES forObject:self.textField];
        id editor = [[note userInfo] objectForKey:@"NSFieldEditor"];
        if ([editor respondsToSelector:@selector(complete:)])
        {
            //NSText *text = [self.textField.window fieldEditor:YES forObject:self.textField];
            //[text complete:nil];
            [editor complete:nil];
        }
        else
        {
            NSLog(@"can't call complete:");
        }
        self.isCompleting = NO;
    }
    
    if (self.isValid)
    {
        self.textField.textColor = [NSColor colorWithCalibratedWhite:.5 alpha:1.0];
        [self.textField setFont:[NSFont fontWithName:@"Open Sans Light" size:self.textField.font.pointSize]];
    }
    else
    {
        self.textField.textColor = [NSColor redColor];
        [self.textField setFont:[NSFont fontWithName:@"Open Sans Bold" size:self.textField.font.pointSize]];
    }
}

- (NSArray *)control:(NSControl *)control
            textView:(NSTextView *)textView
         completions:(NSArray *)words
 forPartialWordRange:(NSRange)charRange
 indexOfSelectedItem:(NSInteger *)index
{
    //return [NSArray array];
    
    NSMutableArray *matches = [NSMutableArray array];
    NSString *selected = [[textView string] substringWithRange:charRange];
    
    for (NSString *label in self.addressLabels)
    {
        if ([label hasPrefix:selected])
        {
            [matches addObject:label];
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

- (BOOL)control:(NSControl *)control isValidObject:(id)object
{
    NSLog(@"isValidObject '%@'", object);
    return YES;
}

@end
