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
#import <TWMessageBarManager/TWMessageBarManager.h>

@interface DEGameViewController : UIViewController <MKMapViewDelegate, UIGestureRecognizerDelegate> {
    UIButton *submitButton;
    DEAPIWrapper *apiWrapper;
    DETileOverlay *mapOverlay;
}


@property (nonatomic,weak) IBOutlet MKMapView *mapView;
@property (nonatomic,assign) NSInteger currentQuestion;
@property (nonatomic, assign) BOOL questionCurrentlyShown;
@property (nonatomic, assign) BOOL beforeFirstQuestion;
@property (nonatomic, assign) BOOL answerCurrentlyShown;


@property (nonatomic,strong) DEGame *game;
@property (nonatomic, strong) DECategory *category;
@property (nonatomic, strong) NSMutableArray *questions;


@property (nonatomic, strong) MKPolyline *routeLine;
@property (nonatomic, strong) MKPointAnnotation *userPlacePin;

//Since self.navigationController is nil in viewWillDisappear because the viewcontroller
//is deleted from the stack we need to keep a local reference
@property (nonatomic, weak) UINavigationController *localNavigationController;

@end
