//
//  BMArchive
//  Bitmessage
//
//  Created by Steve Dekorte on 4/8/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BMArchive : NSObject

- (void)archiveFromPath:(NSString *)inPath   toPath:(NSString *)outPath;
- (void)unarchiveFromPath:(NSString *)inPath toPath:(NSString *)outPath;

@end
