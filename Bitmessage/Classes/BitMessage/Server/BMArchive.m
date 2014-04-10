//
//  BMArchive
//  Bitmessage
//
//  Created by Steve Dekorte on 4/8/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "BMArchive.h"
#import "ZipKit.h"

@implementation BMArchive

- (void)archiveFromPath:(NSString *)inPath toPath:(NSString *)outPath
{
    // we archive it so when expanding, it includes the directory itself
    
    ZKFileArchive *archive = [ZKFileArchive archiveWithArchivePath:outPath];

    [archive deflateDirectory:inPath relativeToPath:[inPath stringByDeletingLastPathComponent] usingResourceFork:NO];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:outPath])
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
    [[NSFileManager defaultManager] removeItemAtPath:@"/tmp/PyBitmessage" error:&error];
    
    if (error)
    {
        NSLog(@"removing old tmp file failed");
        return;
    }
    
        
    ZKFileArchive *archive = [ZKFileArchive archiveWithArchivePath:inPath];
    [archive inflateToDirectory:@"/tmp" usingResourceFork:NO];
    
    if (error)
    {
        NSLog(@"unarchiving failed");
        return;
    }
    
    [[NSFileManager defaultManager] removeItemAtPath:outPath error:&error];

    if (error)
    {
        NSLog(@"removing old mailbox failed");
        return;
    }
    
    [[NSFileManager defaultManager] moveItemAtPath:@"/tmp/PyBitmessage" toPath:outPath error:&error];
    
    if (error)
    {
        NSLog(@"moving in new mailbox failed");
        return;
    }

}

@end
