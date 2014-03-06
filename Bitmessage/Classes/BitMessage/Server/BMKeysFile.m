//
//  BMKeysFile.m
//  Bitmessage
//
//  Created by Steve Dekorte on 2/22/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "BMKeysFile.h"
#import "NSString+BM.h"
#import "BMServerProcess.h"

@implementation BMKeysFile

- (NSString *)path
{
    return [@"~/Library/Application Support/PyBitmessage/keys.dat" stringByExpandingTildeInPath];
}

- (NSString *)newBackupPath
{
    char buffer[50];
    unsigned long t = [[NSDate date] timeIntervalSince1970];
    sprintf(buffer, "%lu", t);
    return [NSString stringWithFormat:@"%@.backup.%s", self.path, buffer];
}

- (void)checkServer
{
    if ([[BMServerProcess sharedBMServerProcess] isRunning])
    {
        [NSException raise:@"Unsafe Request" format:@"Attempt to write keys.day while server running."];
    }
}

- (NSString *)readString
{
    [self checkServer];

    NSError *error;
    NSStringEncoding encoding;
    NSString *data = [NSString stringWithContentsOfFile:[NSURL fileURLWithPath:self.path]
                                           usedEncoding:&encoding error:&error];
    return data;
}

- (void)writeString:(NSString *)data
{
    [self checkServer];
    NSError *error;
    [data writeToFile:self.path atomically:YES encoding:NSUTF8StringEncoding error:&error];
}

- (void)read
{
    NSArray *lines = [[self readString] componentsSeparatedByString:@"\n"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *subDict = nil;
    
    for (NSString *line in lines)
    {
        //NSLog(@"line : '%@'", line);
        
        if ([line hasPrefix:@"["])
        {
            subDict = [NSMutableDictionary dictionary];
            [dict setObject:subDict forKey:line];
        }
        else
        {
            if ([[line strip] length])
            {
                NSArray *parts = [line componentsSeparatedByString:@"="];
                NSString *key = [[parts objectAtIndex:0] strip];
                NSString *value = [[parts objectAtIndex:1] strip];
                [subDict setObject:value forKey:key];
            }
        }
    }
    
    //NSLog(@"read keys: %@", dict);
    
    self.dict = dict;
}

- (void)write
{
    NSMutableString *data = [NSMutableString string];
    
    for (NSString *key in [self.dict allKeys])
    {
        NSDictionary *subDict = [self.dict objectForKey:key];
        [data appendString:@"\n"];
        [data appendString:key];
        [data appendString:@"\n"];
        
        for (NSString *subKey in [subDict allKeys])
        {
            NSDictionary *subValue = [subDict objectForKey:subKey];
            [data appendString:[NSString stringWithFormat:@"%@ = %@\n", subKey, subValue]];
        }
    }
    
    [self writeString:data];
}

- (NSMutableDictionary *)settings
{
    return [self.dict objectForKey:@"[bitmessagesettings]"];
}

// --- setting ----

- (void)setupForDaemon
{
    [self read];
    [self.settings setObject:@"true" forKey:@"daemon"];
    [self.settings setObject:@"8442" forKey:@"apiport"];
    [self.settings setObject:@"true" forKey:@"apienabled"];
    [self.settings setObject:@"false" forKey:@"startonlogon"];
    //[self.settings setObject:@"true" forKey:@"keysencrypted"];
    //[self.settings setObject:@"true" forKey:@"messagesencrypted"];
    [self write];
}

- (void)setupForNonDaemon
{
    [self read];
    [self.settings setObject:@"false" forKey:@"daemon"];
    [self write];
}


- (BOOL)setApiUsername:(NSString *)aString
{
    [self read];
    [self.settings setObject:aString forKey:@"apiusername"];
    [self write];
    return YES;
}

- (BOOL)setApiPassword:(NSString *)aString
{
    [self read];
    [self.settings setObject:aString forKey:@"apipassword"];
    [self write];
    return YES;
}

- (BOOL)setLabel:(NSString *)aLabel onAddress:(NSString *)anAddress
{
    [self read];

    NSString *key = [NSString stringWithFormat:@"[%@]", anAddress];
    NSMutableDictionary *addressDict = [self.dict objectForKey:key];
    
    if (!addressDict)
    {
        return NO;
    }
    
    if ([addressDict objectForKey:@"label"] == nil)
    {
        return NO;
    }
    
    [addressDict setObject:aLabel forKey:@"label"];

    [self write];
    return YES;
}

- (void)backup
{
    NSString *data = [self readString];
    NSError *error;
    
    [data writeToFile:self.newBackupPath
           atomically:YES
             encoding:NSUTF8StringEncoding
                error:&error];
}


@end
