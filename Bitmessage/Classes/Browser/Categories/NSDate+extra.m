//
//  NSDate+extra.m
//  Bitmessage
//
//  Created by Steve Dekorte on 3/21/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "NSDate+extra.h"

@implementation NSDate (extra)

- (NSString *)itemDateString
{
    NSDate *date = self;
    
    if (date)
    {
        //return [NSString stringWithFormat:@"%@", date];
        
        NSTimeInterval dt = -[date timeIntervalSinceNow];
        NSInteger mins = dt/60;
        NSInteger hours = mins/60;
        NSInteger days = hours/24;
        //NSInteger weeks = days/7;
        
        NSString *messageYear = [date
                                 descriptionWithCalendarFormat:@"%Y" timeZone:nil
                                 locale:[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]];
        NSString *currentYear = [[NSDate date]
                                 descriptionWithCalendarFormat:@"%Y" timeZone:nil
                                 locale:[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]];
        
        BOOL sameYear = [messageYear isEqualToString:currentYear];
        
        /*
         if (hours < 1)
         {
         return [NSString stringWithFormat:@"%imin", (int)mins];
         }
         */
        
        if (days < 1)
        {
            //return [NSString stringWithFormat:@"%ihr", (int)hours];
            return @"Today";
        }
        
        if (days < 2)
        {
            return @"Yesterday";
        }
        
        /*
         if (weeks < 1)
         {
         return [NSString stringWithFormat:@"%iwk", (int)days];
         }
         */
        
        if (!sameYear)
        {
            return [date
                    descriptionWithCalendarFormat:@"%b %d %Y" timeZone:nil
                    locale:[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]];
        }
        
        return [date
                descriptionWithCalendarFormat:@"%b %d" timeZone:nil
                locale:[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]];
    }
    
    return @"";
}

@end
