//
//  AddressCompletor.h
//  Bitmessage
//
//  Created by Steve Dekorte on 2/24/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddressTextField.h"

@interface AddressCompletor : NSObject <NSTextFieldDelegate>

@property (assign, nonatomic) id delegate;
@property (assign, nonatomic) BOOL isCompleting;
@property (strong, nonatomic) AddressTextField *textField;
@property (strong, nonatomic) NSMutableArray *addressLabels;
@property (strong, nonatomic) NSString *lastString;
@property (assign, nonatomic) BOOL shouldComplete;


- (void)controlTextDidChange:(NSNotification *)note;

- (NSArray *)control:(NSControl *)control
            textView:(NSTextView *)textView
         completions:(NSArray *)words
 forPartialWordRange:(NSRange)charRange
 indexOfSelectedItem:(NSInteger *)index;

- (BOOL)isMatched;
- (BOOL)isValid;

@end
