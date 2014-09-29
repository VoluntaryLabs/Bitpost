//
//  BMAddressCompletor.h
//  Bitmessage
//
//  Created by Steve Dekorte on 2/24/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMAddressTextField.h"

@interface BMAddressCompletor : NSObject <NSTextFieldDelegate>

@property (assign, nonatomic) id delegate;
@property (assign, nonatomic) BOOL isCompleting;
@property (strong, nonatomic) BMAddressTextField *textField;
@property (strong, nonatomic) NSSet *addressLabels;
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
