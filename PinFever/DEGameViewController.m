//
//  DEGameViewController.m
//  PinFever
//
//  Created by David Ehlen on 22.05.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import "DEGameViewController.h"
#import "DETileOverlay.h"
#import "MBXRasterTileRenderer.h"
#import "WildcardGestureRecognizer.h"
#import "UIViewController+CWPopup.h"
#import "DEQuestionViewController.h"

@interface DEGameViewController ()

@end

@implementation DEGameViewController

#define SUBMIT_BUTTON_WIDTH 85
#define SUBMIT_BUTTON_HEIGHT 35

#define QUESTION_BUTTON_WIDTH 135
#define QUESTION_BUTTON_HEIGHT 35

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"gameTitle", nil);
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.mapView.delegate = self;
    NSString *template = @"http://tile.stamen.com/watercolor/{z}/{x}/{y}.jpg";
    DETileOverlay *overlay = [[DETileOverlay alloc] initWithURLTemplate:template];
    overlay.canReplaceMapContent = YES;
    [self.mapView addOverlay:overlay level:MKOverlayLevelAboveLabels];
    
    WildcardGestureRecognizer * tapInterceptor = [[WildcardGestureRecognizer alloc] init];
    tapInterceptor.touchesBeganCallback = ^(NSSet * touches, UIEvent * event) {
        if(!self.questionCurrentlyShown) {
            [self placePin:touches andEvent:event];
        }
    };
    [self.mapView addGestureRecognizer:tapInterceptor];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissPopup)];
    tapRecognizer.numberOfTapsRequired = 1;
    tapRecognizer.delegate = self;
    [self.view addGestureRecognizer:tapRecognizer];

    
    [self setupSubmitButton];
    [self setupQuestionButton];
    [self setupQuestionPopup];
    [self performSelector:@selector(showNextQuestion) withObject:nil afterDelay:2.0];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark -
#pragma mark Actions

-(void)setupQuestionPopup {
    self.useBlurForPopup = YES;
}

-(void)setupSubmitButton {
    submitButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-SUBMIT_BUTTON_WIDTH-15,self.view.frame.size.height-SUBMIT_BUTTON_HEIGHT-15,SUBMIT_BUTTON_WIDTH,SUBMIT_BUTTON_HEIGHT)];
    [submitButton addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    submitButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleTopMargin;
    submitButton.backgroundColor = [UIColor colorWithWhite:0.95 alpha:0.5];
    [submitButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [submitButton setTitle:NSLocalizedString(@"submit", nil) forState:UIControlStateNormal];
    submitButton.layer.borderWidth = 1.0;
    submitButton.layer.borderColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5].CGColor;
    submitButton.layer.cornerRadius = 5.0;
    [self.view insertSubview:submitButton aboveSubview:self.mapView];
    [submitButton setHidden:YES];
}

-(void)setupQuestionButton {
    UIButton *questionButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-15-QUESTION_BUTTON_WIDTH,15,QUESTION_BUTTON_WIDTH,QUESTION_BUTTON_HEIGHT)];
    [questionButton addTarget:self action:@selector(showCurrentQuestion) forControlEvents:UIControlEventTouchUpInside];
    questionButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleBottomMargin;
    questionButton.backgroundColor = [UIColor colorWithWhite:0.95 alpha:0.5];
    [questionButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [questionButton setTitle:NSLocalizedString(@"showQuestion", nil) forState:UIControlStateNormal];
    questionButton.layer.borderWidth = 1.0;
    questionButton.layer.borderColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5].CGColor;
    questionButton.layer.cornerRadius = 5.0;
    [self.view insertSubview:questionButton aboveSubview:self.mapView];
}

-(void)placePin:(NSSet *)touches andEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches]anyObject];
    CGPoint point = [touch locationInView:self.mapView];
    CLLocationCoordinate2D locCoord = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
    MKPointAnnotation *dropPin = [[MKPointAnnotation alloc] init];
    dropPin.coordinate = locCoord;
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotation:dropPin];
    [self showSubmitButton];
    
}

-(void)showSubmitButton {
    [submitButton setHidden:NO];
}

-(void)submit:(id)sender {
    [submitButton setHidden:YES];
    [self.mapView removeAnnotations:self.mapView.annotations];

    if(self.currentQuestion >= 3) {
        [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"homeViewController"] animated:YES];
    }
    else {
        [self showNextQuestion];
    }
    
}

-(void)showNextQuestion {
    self.currentQuestion += 1;
    self.questionCurrentlyShown = YES;
    NSString *question = [NSString stringWithFormat:@"%@ #%li",NSLocalizedString(@"question", nil),self.currentQuestion];
    DEQuestionViewController *questionViewController = [[DEQuestionViewController alloc] initWithNibName:@"DEQuestionViewController" bundle:nil];
    questionViewController.question = question;
    [self presentPopupViewController:questionViewController animated:YES completion:nil];
}

-(void)showCurrentQuestion {
    self.questionCurrentlyShown = YES;
    NSString *question = [NSString stringWithFormat:@"%@ #%li",NSLocalizedString(@"question", nil),self.currentQuestion];
    DEQuestionViewController *questionViewController = [[DEQuestionViewController alloc] initWithNibName:@"DEQuestionViewController" bundle:nil];
    questionViewController.question = question;
    [self presentPopupViewController:questionViewController animated:YES completion:nil];
}

- (void)dismissPopup {
    if (self.popupViewController != nil) {
        self.questionCurrentlyShown = NO;
        [self dismissPopupViewControllerAnimated:YES completion:^{
        }];
    }
}

#pragma mark -
#pragma mark MapKitDelegate

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay {
    return [[MBXRasterTileRenderer alloc] initWithTileOverlay:overlay];
}

@end
