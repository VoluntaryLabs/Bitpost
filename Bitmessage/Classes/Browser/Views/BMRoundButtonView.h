//
//  BMRoundButtonView.h
//  Bitmessage
//
//  Created by Steve Dekorte on 3/30/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "BMButton.h"

@interface BMRoundButtonView : BMButton

@property (strong, nonatomic) NSColor *backgroundColor;
@property (assign, nonatomic) CGFloat cornerRadius;
@property (strong, nonatomic) NSDictionary *titleAttributes;

@end
