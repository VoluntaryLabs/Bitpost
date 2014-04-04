//
//  InfoButton.h
//  Bitmessage
//
//  Created by Steve Dekorte on 3/11/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "BMButton.h"

@interface InfoButton : NSButton

@property (strong) NSString *link;
@property (strong) NSTrackingArea *trackingArea;
@property (strong) NSString *normalTitle;
@property (strong) NSString *altTitle;
@property (strong) NSString *titleThemePath;


@end
