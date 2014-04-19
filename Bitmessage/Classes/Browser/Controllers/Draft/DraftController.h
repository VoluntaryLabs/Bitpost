//
//  DraftController.h
//  Bitmarket
//
//  Created by Steve Dekorte on 2/9/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NavKit/NavKit.h>
#import "AddressCompletor.h"
#import "AddressTextField.h"

@interface DraftController : NSViewController <NSWindowDelegate, NSTextFieldDelegate>

@property (assign, nonatomic) IBOutlet NSButton *sendButton;

@property (assign, nonatomic) IBOutlet AddressTextField *from;
@property (assign, nonatomic) IBOutlet AddressTextField *to;
@property (assign, nonatomic) IBOutlet NSTextField *subject;

@property (assign, nonatomic) IBOutlet NSTextField *fromLabel;
@property (assign, nonatomic) IBOutlet NSTextField *toLabel;
@property (assign, nonatomic) IBOutlet NSTextField *subjectLabel;


@property (assign, nonatomic) IBOutlet NSScrollView *scrollView;
@property (assign, nonatomic) IBOutlet NavMarginTextView *bodyText;


@property (strong, nonatomic) NavColoredView *bodyArea;
@property (assign, nonatomic) IBOutlet NavColoredView *topBackground;
@property (assign, nonatomic) IBOutlet NavColoredView *fromBackground;
@property (assign, nonatomic) IBOutlet NavColoredView *toBackground;
@property (assign, nonatomic) IBOutlet NavColoredView *subjectBackground;

@property (strong, nonatomic) AddressCompletor *fromCompletor;
@property (strong, nonatomic) AddressCompletor *toCompletor;

+ (DraftController *)openNewDraft;

- (IBAction)send:(id)sender;

- (void)setCursorForReply;
- (void)setCursorOnTo;

- (void)open;

- (void)updateSendButton;
- (void)setDefaultFrom;

- (void)setAddressesToLabels;
- (void)addSubjectPrefix:(NSString *)prefix;

- (void)setBodyString:(NSString *)aString;

@end
