//
//  DEGameViewController.m
//  PinFever
//
//  Created by David Ehlen on 22.05.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import "DEGameViewController.h"
#import "MBXRasterTileRenderer.h"
#import "UIViewController+CWPopup.h"
#import "DEQuestionViewController.h"
#import "DEQuestion.h"
#import "MKMapView+ZoomLevel.h"
#import "DENotificationStylesheet.h"

@interface DEGameViewController ()
@end

@implementation DEGameViewController

#define SUBMIT_BUTTON_WIDTH 85
#define SUBMIT_BUTTON_HEIGHT 35

#define QUESTION_BUTTON_WIDTH 135
#define QUESTION_BUTTON_HEIGHT 35

#define kQuestionAmount 3

#define KARLSRUHE_LATITUDE 49.0
#define KARLSRUHE_LONGITUDE 8.0

#define ZOOM_LEVEL 1


//TODO: based on self.game.state show answers of opponent or not (first, second move), show all question and answers no pin placing (finished game)
//TODO: to make it easier, new viewcontroller for finished game (push from derounddetailviewcontroller), show second answer if state is accordingly
//TODO: or all with this viewcontroller, submit button to next question button
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"gameTitle", nil);
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.questions = [NSMutableArray new];
    apiWrapper = [DEAPIWrapper new];
    
    [self setupMap];
    
    self.beforeFirstQuestion = YES;

    //if question is shown dismiss question , else place pin
    UITapGestureRecognizer * tapInterceptor = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
    [self.mapView addGestureRecognizer:tapInterceptor];
  
    [TWMessageBarManager sharedInstance].styleSheet = [DENotificationStylesheet styleSheet];

    [self setupSubmitButton];
    [self setupQuestionButton];
    [self setupQuestionPopup];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self loadQuestions];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.localNavigationController = self.navigationController;
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.localNavigationController setNavigationBarHidden:NO];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark Actions

-(void)setupMap {
    self.mapView.delegate = self;
    NSString *template = @"http://tile.stamen.com/watercolor/{z}/{x}/{y}.jpg";
    mapOverlay = [[DETileOverlay alloc] initWithURLTemplate:template];
    mapOverlay.canReplaceMapContent = YES;
    [self.mapView addOverlay:mapOverlay level:MKOverlayLevelAboveLabels];
    CLLocationCoordinate2D centerCoord = { KARLSRUHE_LATITUDE, KARLSRUHE_LONGITUDE };
    [self.mapView setCenterCoordinate:centerCoord zoomLevel:ZOOM_LEVEL animated:NO];
}

-(void)didTap:(UITapGestureRecognizer *)recognizer {
    if(!self.questionCurrentlyShown) {
        if(!self.answerCurrentlyShown) {
            CGPoint point = [recognizer locationInView:self.mapView];
            [self placePin:point];
        }
    }
    else {
        [self dismissPopup];
    }
}

-(void)loadQuestions {
    //test with en
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    DLog(@"%@",language);
    [apiWrapper request:[NSURL URLWithString:[NSString stringWithFormat:@"%@?amount=%i&language=%@&category=%@",kAPIRandomQuestions,kQuestionAmount,language,self.category.categoryId]] httpMethod:@"GET" optionalJSONData:nil optionalContentType:nil completed:^(NSDictionary *headers, NSString *body){
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [self parseQuestions:body];
    } failed:^(NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:NSLocalizedString(@"loadQuestionsError", nil) delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
    }];
}

-(void)parseQuestions:(NSString *)body {
    NSData *jsonData = [body dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                         options:NSJSONReadingMutableContainers
                                                           error:nil];
    NSArray *response = dict[kDataKey][kQuestionsKey];
    
    for(NSDictionary *questionsDict in response) {
        DEQuestion *question = [DEQuestion new];
        question.categoryId = questionsDict[kCategoryId];
        question.question = questionsDict[kQuestionKey];
        DEAnswer *answer = [DEAnswer new];
        answer.text = questionsDict[kAnswerKey][kTextKey];
        answer.coordinate = CLLocationCoordinate2DMake([questionsDict[kAnswerKey][kCoordinatesKey][kLatitudeKey]doubleValue], [questionsDict[kAnswerKey][kCoordinatesKey][kLongitudeKey]doubleValue]);
        question.answer = answer;
        [self.questions addObject:question];
    }
    [self showCurrentQuestion];
}

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
    submitButton.titleLabel.numberOfLines = 1;
    submitButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    submitButton.titleLabel.lineBreakMode = NSLineBreakByClipping;
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

-(void)placePin:(CGPoint)point {
    //Don't place a pin before the first question was shown
    if(!self.beforeFirstQuestion) {
        [self.mapView removeAnnotation:self.userPlacePin];

        CLLocationCoordinate2D locCoord = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
        self.userPlacePin = [[MKPointAnnotation alloc] init];
        self.userPlacePin.coordinate = locCoord;
        [self.mapView addAnnotation:self.userPlacePin];
        [self showSubmitButton];
    }
    
}

-(void)showSubmitButton {
    [submitButton setHidden:NO];
}

-(void)submit:(id)sender {
    [submitButton setHidden:YES];
    [self showAnswer];
}

-(void)showAnswer {
    DEQuestion *question = self.questions[(NSUInteger) self.currentQuestion];
    MKPointAnnotation *dropPin = [[MKPointAnnotation alloc] init];
    dropPin.coordinate = question.answer.coordinate;
    dropPin.title = question.answer.text;
    [self.mapView addAnnotation:dropPin];
    //TODO: add opponent pin
    CLLocationCoordinate2D coordinateArray[2];
    coordinateArray[0] = self.userPlacePin.coordinate;
    coordinateArray[1] = dropPin.coordinate;
  
    self.routeLine = [MKPolyline polylineWithCoordinates:coordinateArray count:2];
    
    [self.mapView addOverlay:self.routeLine];
    
    //Answer View
    CLLocation *userLoc = [[CLLocation alloc] initWithCoordinate: coordinateArray[0] altitude:1 horizontalAccuracy:1 verticalAccuracy:-1 timestamp:nil];
    CLLocation *answerLoc = [[CLLocation alloc] initWithCoordinate: coordinateArray[1] altitude:1 horizontalAccuracy:1 verticalAccuracy:-1 timestamp:nil];

    CLLocationDistance distance = [userLoc distanceFromLocation:answerLoc]/1000;
    //TODO: show also opponent distance
    [self showAnswerView:question.answer.text withDistance:distance];
    
    [self.mapView setNeedsDisplay];
    [self.mapView setCenterCoordinate:dropPin.coordinate zoomLevel:1 animated:YES];
    [self performSelector:@selector(showNextQuestion) withObject:nil afterDelay:4.0];
}

-(void)dismissAnswerView {
    self.answerCurrentlyShown = NO;
    [[TWMessageBarManager sharedInstance] hideAllAnimated:YES];
}

-(void)showAnswerView:(NSString *)answer withDistance:(CLLocationDistance)distance {
    self.answerCurrentlyShown = YES;
    //TODO: show answer of opponent and his distance
    [[TWMessageBarManager sharedInstance] showMessageWithTitle:[NSString stringWithFormat:@"%@ : %@",NSLocalizedString(@"searchedPlace", nil),answer]
                                                   description:[NSString stringWithFormat:@"%@: %.0fkm",NSLocalizedString(@"distance",nil), distance]
                                                          type:TWMessageBarMessageTypeInfo
                                                      duration:6.0 statusBarHidden:YES callback:nil];
}

-(void)showNextQuestion {
    [self dismissAnswerView];
    //remove route
    [self.mapView removeOverlay:self.routeLine];
    //TODO: remove opponent route
    [self.mapView removeAnnotations:self.mapView.annotations];
    self.currentQuestion += 1;
    
    if(self.currentQuestion >= kQuestionAmount) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
    
    self.questionCurrentlyShown = YES;
    NSString *question = [NSString stringWithFormat:@"%@",((DEQuestion *)self.questions[self.currentQuestion]).question];
    DEQuestionViewController *questionViewController = [[DEQuestionViewController alloc] initWithNibName:@"DEQuestionViewController" bundle:nil];
    questionViewController.question = question;
    [self presentPopupViewController:questionViewController animated:YES completion:nil];
}

-(void)showCurrentQuestion {
    self.questionCurrentlyShown = YES;
    NSString *question = [NSString stringWithFormat:@"%@",((DEQuestion *)self.questions[self.currentQuestion]).question];
    DEQuestionViewController *questionViewController = [[DEQuestionViewController alloc] initWithNibName:@"DEQuestionViewController" bundle:nil];
    questionViewController.question = question;
    self.beforeFirstQuestion = NO;
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
    if([overlay isKindOfClass:[DETileOverlay class]]) {
        return [[MBXRasterTileRenderer alloc] initWithTileOverlay:overlay];
    }
    else {
        //TODO: opponent route in different color
        MKPolylineRenderer* lineView = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
        lineView.fillColor = [UIColor redColor];
        lineView.strokeColor = [UIColor redColor];
        lineView.lineWidth = 3;
        return lineView;
    }
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotationPoint
{
    static NSString *annotationIdentifier = @"pinIdentifier";
    
    MKPinAnnotationView *pinView = [[MKPinAnnotationView alloc]initWithAnnotation:annotationPoint reuseIdentifier:annotationIdentifier];
    
    if(annotationPoint == self.userPlacePin) {
        pinView.pinColor = MKPinAnnotationColorRed;
    }
    //TODO: opponent pinColor in different color
    else {
        pinView.pinColor = MKPinAnnotationColorPurple;
    }
    
    return pinView;
}



@end
