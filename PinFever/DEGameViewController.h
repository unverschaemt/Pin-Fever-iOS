//
//  DEGameViewController.h
//  PinFever
//
//  Created by David Ehlen on 22.05.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface DEGameViewController : UIViewController <MKMapViewDelegate>

@property (nonatomic,weak) IBOutlet MKMapView *mapView;

@end
