//
//  DEGameViewController.h
//  PinFever
//
//  Created by David Ehlen on 22.05.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "DEGame.h"
#import "DECategory.h"
#import "DEAPIWrapper.h"
#import "DETileOverlay.h"

@interface DEGameViewController : UIViewController <MKMapViewDelegate, UIGestureRecognizerDelegate> {
    UIButton *submitButton;
    DEAPIWrapper *apiWrapper;
    DETileOverlay *mapOverlay;
}

@property (nonatomic,weak) IBOutlet MKMapView *mapView;
@property (nonatomic,assign) NSInteger currentQuestion;
@property (nonatomic, assign) BOOL questionCurrentlyShown;

@property (nonatomic,strong) DEGame *game;
@property (nonatomic, strong) DECategory *category;
@property (nonatomic, strong) NSMutableArray *questions;

@property (nonatomic, strong) MKPolyline *routeLine; //line
@property (nonatomic, strong) MKPointAnnotation *userPlacePin;

@end
