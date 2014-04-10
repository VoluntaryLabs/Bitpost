//
//  MKSellView.m
//  Bitmessage
//
//  Created by Steve Dekorte on 2/21/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "MKSellView.h"
#import "NSTextView+extra.h"
#import "NSView+sizing.h"
#import "Theme.h"
#import "BMTextView.h"
#import "BMButton.h"

@implementation MKSellView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self setAutoresizesSubviews:YES];
        [self setAutoresizingMask:NSViewHeightSizable | NSViewWidthSizable];

        _title = [[BMTextView alloc] initWithFrame:NSMakeRect(0, 0, 500, 24)];
        [self addSubview:_title];
        _title.string = @"Powerbass 4-Channel Amplifier";
        [_title setThemePath:@"sell/title"];
        //@property (strong) IBOutlet NSTextView *quantity;
        
        self.price = [[BMTextView alloc] initWithFrame:NSMakeRect(0, 0, 500, 24)];
        self.price.string = @"0.23BTC";
        [self.price setThemePath:@"sell/price"];
        [self addSubview:self.price];
        
        _postOrBuyButton = [[BMRoundButtonView alloc] initWithFrame:NSMakeRect(0, 0, 120, 32)];
        _postOrBuyButton.title = @"Buy Now";
        //[_postOrBuyButton setThemePath:@"sell/button"];
        [_postOrBuyButton setTitleAttributes:[Theme.sharedTheme attributesDictForPath:@"sell/button"]];
        [self addSubview:_postOrBuyButton];
        
        self.separator = [[ColoredView alloc] initWithFrame:NSMakeRect(0, 0, self.width, 1)];
        [self.separator setThemePath:@"sell/separator"];
        [self addSubview:self.separator];
        
        self.description = [[BMTextView alloc] initWithFrame:NSMakeRect(0, 0, 500, 24)];
        self.description.string = @"I've had this TOA amp in the closet for a while waiting to setup in my shop space but I need the space so my loss is your gain. Works fine and is in mostly decent condition with a few dings on the corners. I'm available during the day near 7th and Folsom but I can also meet up in the evening in the Mission.";
        [self.description setThemePath:@"sell/description"];
        [self addSubview:self.description];
        
        // region
        
        self.regionIcon = [[NSImageView alloc] initWithFrame:NSMakeRect(0, 0, 16, 16)];
        [_regionIcon setImage:[NSImage imageNamed:@"icon_location.png"]];
        [self addSubview:self.regionIcon];
 
        self.region = [[BMTextView alloc] initWithFrame:NSMakeRect(0, 0, 500, 24)];
        self.region.string = @"United States";
        [self.region setThemePath:@"sell/label"];
        [self addSubview:self.region];
        
        // category
        
        self.categoryIcon = [[NSImageView alloc] initWithFrame:NSMakeRect(0, 0, 16, 16)];
        [_categoryIcon setImage:[NSImage imageNamed:@"icon_right.png"]];
        [self addSubview:self.categoryIcon];
        
        self.category = [[BMTextView alloc] initWithFrame:NSMakeRect(0, 0, 500, 24)];
        self.category.string = @"Electronics";
        [self.category setThemePath:@"sell/label"];
        [self addSubview:self.category];
        
        // fromAddress
        
        self.fromAddressIcon = [[NSImageView alloc] initWithFrame:NSMakeRect(0, 0, 16, 16)];
        [_fromAddressIcon setImage:[NSImage imageNamed:@"icon_profile.png"]];
        [self addSubview:self.fromAddressIcon];
        
        self.fromAddress = [[BMTextView alloc] initWithFrame:NSMakeRect(0, 0, 500, 24)];
        self.fromAddress.string = @"fromAddress";
        [self.fromAddress setThemePath:@"sell/address"];
        [self addSubview:self.fromAddress];

        // attachment

        self.attachedImage = [[NSImageView alloc] initWithFrame:NSMakeRect(0, 0, 500, 24)];
        [self addSubview:self.attachedImage];
    }
    
    return self;
}

- (void)layout
{
    CGFloat leftMargin = 30;
    
    [_title setX:leftMargin];
    [_title placeInTopOfSuperviewWithMargin:leftMargin];
    
    [_price setX:leftMargin];
    [_price placeYBelow:_title margin:0];

    [_postOrBuyButton setWidth:84];
    [_postOrBuyButton setX:self.width - _postOrBuyButton.width - leftMargin];
    [_postOrBuyButton placeInTopOfSuperviewWithMargin:40];
    
    [_separator setX:0];
    [_separator setWidth:self.width];
    [_separator placeYBelow:_price margin:20];
    
    [_description setX:leftMargin];
    [_description setWidth:self.width - leftMargin*2];
    [_description setHeight:100];
    [_description placeYBelow:_separator margin:30];

    
    CGFloat iconMargin = 5;
    
    [_regionIcon setX:leftMargin];
    [_regionIcon placeYBelow:_description margin:iconMargin];
    [_region placeYBelow:_description margin:iconMargin];
    [_region placeXRightOf:_regionIcon margin:iconMargin];
    
    [_categoryIcon setX:leftMargin];
    [_categoryIcon placeYBelow:_regionIcon margin:iconMargin];
    [_category placeYBelow:_regionIcon margin:iconMargin];
    [_category placeXRightOf:_categoryIcon margin:iconMargin];
    
    [_fromAddressIcon setX:leftMargin];
    [_fromAddressIcon placeYBelow:_categoryIcon margin:iconMargin];
    [_fromAddress placeYBelow:_categoryIcon margin:iconMargin];
    [_fromAddress placeXRightOf:_fromAddressIcon margin:iconMargin];
}

- (void)prepareToDisplay
{
    [self layout];
    [self layout];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setFrame:(NSRect)frameRect
{
    [super setFrame:frameRect];
    [self layout];
}

- (void)setNode:(id <NavNode>)node
{
    _node = node;
}

- (MKSell *)sell
{
    return (MKSell *)self.node;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
    [[NSColor whiteColor] set];
    NSRectFill(dirtyRect);
}

/*
- (void)updateAddressColor
{
    if (self.hasValidAddress)
    {
        self.addressField.textColor = [Theme.sharedTheme formText2Color];
    }
    else
    {
        self.addressField.textColor = [Theme.sharedTheme formTextErrorColor];
    }
}
*/


- (void)textDidEndEditing:(NSNotification *)aNotification
{
    [[aNotification object] endEditing];
    [self saveChanges];
}

- (void)saveChanges
{

}

// -- sync ----

- (void)selectFirstResponder
{
    //[self.window makeFirstResponder:self.labelField];
    //[self.labelField selectAll:nil];
    //[labelField becomeFirstResponder];
}

@end
