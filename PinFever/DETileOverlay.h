//
//  DETileOverlay.h
//  PocketBirds
//
//  Created by David Ehlen on 13.03.14.
//  Copyright (c) 2014 David Ehlen. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface DETileOverlay : MKTileOverlay
@property NSCache *cache;
@end