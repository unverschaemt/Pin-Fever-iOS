//
//  MKMapView+ZoomLevel.h
//  PinFever
//
//  Created by David Ehlen on 08.06.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKMapView (ZoomLevel)

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated;

-(double)zoomLevel;
@end