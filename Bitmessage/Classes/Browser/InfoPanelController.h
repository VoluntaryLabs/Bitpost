//
//  InfoPanelController.h
//  Bitmessage
//
//  Created by Steve Dekorte on 2/18/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InfoPanelController : NSViewController <NSWindowDelegate>


+ (InfoPanelController *)sharedInfoPanelController;

- (void)open;

@end
