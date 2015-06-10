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

@interface DEGameViewController ()

@end

@implementation DEGameViewController

#define SUBMIT_BUTTON_WIDTH 85
#define SUBMIT_BUTTON_HEIGHT 35

#define QUESTION_BUTTON_WIDTH 135
#define QUESTION_BUTTON_HEIGHT 35

#define kQuestionAmount 3

//TEST
#define GEORGIA_TECH_LATITUDE 33.777328
#define GEORGIA_TECH_LONGITUDE -84.397348

#define ZOOM_LEVEL 1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"gameTitle", nil);
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.questions = [NSMutableArray new];
    apiWrapper = [DEAPIWrapper new];
    
    self.mapView.delegate = self;
    
    NSString *template = @"http://tile.stamen.com/watercolor/{z}/{x}/{y}.jpg";
    mapOverlay = [[DETileOverlay alloc] initWithURLTemplate:template];
    mapOverlay.canReplaceMapContent = YES;
  
    [self.mapView addOverlay:mapOverlay level:MKOverlayLevelAboveLabels];
    
    //TODO: zwei TapRecognizer => daher popup nicht disabled wenn nebendran geklickt
    UITapGestureRecognizer * tapInterceptor = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
    
    [self.mapView addGestureRecognizer:tapInterceptor];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissPopup)];
    tapRecognizer.numberOfTapsRequired = 1;
    tapRecognizer.delegate = self;
    [self.view addGestureRecognizer:tapRecognizer];
    
    CLLocationCoordinate2D centerCoord = { GEORGIA_TECH_LATITUDE, GEORGIA_TECH_LONGITUDE };
    [self.mapView setCenterCoordinate:centerCoord zoomLevel:ZOOM_LEVEL animated:NO];

    [self setupSubmitButton];
    [self setupQuestionButton];
    [self setupQuestionPopup];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSNumber *value = @(UIInterfaceOrientationLandscapeLeft);
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    [self loadQuestions];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSNumber *value = @(UIInterfaceOrientationPortrait);
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
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

-(void)didTap:(UITapGestureRecognizer *)recognizer {
    if(!self.questionCurrentlyShown) {
        CGPoint point = [recognizer locationInView:self.mapView];
        [self placePin:point];
    }
}

-(void)loadQuestions {
    NSLog(@"question loading");
    NSString * language = @"en";
    //TODO:[[NSLocale preferredLanguages] objectAtIndex:0];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSLog(@"question url: %@",[NSString stringWithFormat:@"%@?amount=%i&language=%@&category=%@",kAPIRandomQuestions,kQuestionAmount,language,self.category.categoryId]);
    [apiWrapper request:[NSURL URLWithString:[NSString stringWithFormat:@"%@?amount=%i&language=%@&category=%@",kAPIRandomQuestions,kQuestionAmount,language,self.category.categoryId]] httpMethod:@"GET" optionalJSONData:nil optionalContentType:nil completed:^(NSDictionary *headers, NSString *body){
        NSLog(@"success");
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
    [self performSelector:@selector(showCurrentQuestion) withObject:nil afterDelay:1.0];
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
    [self.mapView removeAnnotation:self.userPlacePin];

    CLLocationCoordinate2D locCoord = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
    self.userPlacePin = [[MKPointAnnotation alloc] init];
    self.userPlacePin.coordinate = locCoord;
    [self.mapView addAnnotation:self.userPlacePin];
    [self showSubmitButton];
    
}

-(void)showSubmitButton {
    [submitButton setHidden:NO];
}

-(void)submit:(id)sender {
    [submitButton setHidden:YES];

    if(self.currentQuestion >= 3) {
        [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"homeViewController"] animated:YES];
    }
    else {
        [self showAnswerPin];
    }
}

-(void)showAnswerPin {
    DEQuestion *question = self.questions[(NSUInteger) self.currentQuestion];
    MKPointAnnotation *dropPin = [[MKPointAnnotation alloc] init];
    NSLog(@"%f, %f",question.answer.coordinate.latitude, question.answer.coordinate.longitude);
    dropPin.coordinate = question.answer.coordinate;
    dropPin.title = question.answer.text;
    [self.mapView addAnnotation:dropPin];
    
    CLLocationCoordinate2D coordinateArray[2];
    coordinateArray[0] = self.userPlacePin.coordinate;
    coordinateArray[1] = dropPin.coordinate;
    NSLog(@"%f %f", self.userPlacePin.coordinate.latitude, self.userPlacePin.coordinate.longitude);
    NSLog(@"%f %f", dropPin.coordinate.latitude, dropPin.coordinate.longitude);

    self.routeLine = [MKPolyline polylineWithCoordinates:coordinateArray count:2];
    [self.mapView addOverlay:self.routeLine];
    [self.mapView setNeedsDisplay];
    [self.mapView setCenterCoordinate:dropPin.coordinate zoomLevel:1 animated:YES];
    
    [self performSelector:@selector(showNextQuestion) withObject:nil afterDelay:4.0];
}

-(void)showNextQuestion {
    
    //remove route
    [self.mapView removeOverlay:self.routeLine];
    [self.mapView removeAnnotations:self.mapView.annotations];
    self.currentQuestion += 1;
    
    if(self.currentQuestion >= kQuestionAmount) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
        return;
    }
    
    self.questionCurrentlyShown = YES;
    NSString *question = [NSString stringWithFormat:@"%@",((DEQuestion *)self.questions[self.currentQuestion]).question];
    DEQuestionViewController *questionViewController = [[DEQuestionViewController alloc] initWithNibName:@"DEQuestionViewController" bundle:nil];
    NSLog(@"%@",question);
    questionViewController.question = question;
    [self presentPopupViewController:questionViewController animated:YES completion:nil];
}

-(void)showCurrentQuestion {
    self.questionCurrentlyShown = YES;
    NSString *question = [NSString stringWithFormat:@"%@",((DEQuestion *)self.questions[self.currentQuestion]).question];
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
    if([overlay isKindOfClass:[DETileOverlay class]]) {
        return [[MBXRasterTileRenderer alloc] initWithTileOverlay:overlay];
    }
    else {
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
    else {
        pinView.pinColor = MKPinAnnotationColorPurple;
    }
    
    return pinView;
}

#pragma mark -
#pragma mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}


@end
