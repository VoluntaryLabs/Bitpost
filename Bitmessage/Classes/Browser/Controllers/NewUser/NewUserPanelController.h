//
//  NewUserPanelController.h
//  Bitmessage
//
//  Created by Steve Dekorte on 2/27/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMNewUserView.h"

@interface NewUserPanelController : NSViewController <NSWindowDelegate, NSTextFieldDelegate>

@property (strong, nonatomic) BMNewUserView *userView;

+ (NewUserPanelController *)openNewUserPanel;

@end
