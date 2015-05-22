//
//  DETileOverlay.m
//  PocketBirds
//
//  Created by David Ehlen on 13.03.14.
//  Copyright (c) 2014 David Ehlen. All rights reserved.
//

#import "DETileOverlay.h"

@implementation DETileOverlay


//If there is a cached tile this tile is loaded (only on runtime NSCache), else we load the tile from the internet
- (void)loadTileAtPath:(MKTileOverlayPath)path
                result:(void (^)(NSData *data, NSError *error))result {
    if (!result) {
        NSLog(@"return");
        return;
    }

    NSData *cachedData = [self.cache objectForKey:[self URLForTilePath:path]];
    if (cachedData) {
        result(cachedData, nil);
    }
    else {
        NSURLRequest *request = [NSURLRequest requestWithURL:[self URLForTilePath:path] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:40];
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (connectionError != nil) {
                NSLog(@"%@", connectionError);
            }
            if (data == nil) {
                NSLog(@"Data is nil");
            }
            [self.cache setObject:data forKey:[self URLForTilePath:path]];

            result(data, connectionError);
        }];
    }
}

@end