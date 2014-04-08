//
//  BMKeysArchive.m
//  Bitmessage
//
//  Created by Steve Dekorte on 4/8/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "BMKeysArchive.h"
#import "ZipKit.h"

@implementation BMKeysArchive

- (void)archiveFromPath:(NSString *)inPath toPath:(NSString *)outPath
{
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath:outPath error:&error];
    
    if (error)
    {
        NSLog(@"error removing archive %@", error);
    }
    
    //[archive deflateDirectory:[self deckPath] relativeToPath:[[self archivePath] stringByDeletingLastPathComponent] usingResourceFork:NO];
    ZKFileArchive *archive = [ZKFileArchive archiveWithArchivePath:inPath];

    [archive deflateDirectory:inPath relativeToPath:outPath usingResourceFork:NO];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:inPath])
    {
        NSLog(@"archived succeeded!");
    }
    else
    {
        NSLog(@"archiving failed!");
    }
}

- (void)unarchiveFromPath:(NSString *)inPath toPath:(NSString *)outPath
{
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath:outPath error:&error];
    
    NSLog(@"unarchive deck:\n\n'%@'\n\nto:\n\n'%@'\n\n", inPath, outPath);
    
    ZKFileArchive *archive = [ZKFileArchive archiveWithArchivePath:inPath];
    [archive inflateToDirectory:outPath usingResourceFork:NO];
}

@end
