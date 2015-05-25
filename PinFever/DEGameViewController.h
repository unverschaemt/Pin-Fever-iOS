//
//  DEGameViewController.h
//  PinFever
//
//  Created by David Ehlen on 22.05.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface DEGameViewController : UIViewController <MKMapViewDelegate, UIGestureRecognizerDelegate> {
    UIButton *submitButton;
}

@property (nonatomic,weak) IBOutlet MKMapView *mapView;
@property (nonatomic,assign) NSInteger currentQuestion;
@property (nonatomic, assign) BOOL questionCurrentlyShown;
@end
