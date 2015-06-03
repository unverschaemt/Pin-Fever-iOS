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
#import "DEQuestion.h"

@interface DEGameViewController ()

@end

@implementation DEGameViewController

#define SUBMIT_BUTTON_WIDTH 85
#define SUBMIT_BUTTON_HEIGHT 35

#define QUESTION_BUTTON_WIDTH 135
#define QUESTION_BUTTON_HEIGHT 35

#define kQuestionAmount 3

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"gameTitle", nil);
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.questions = [NSMutableArray new];
    
    self.mapView.delegate = self;
    NSString *template = @"http://tile.stamen.com/watercolor/{z}/{x}/{y}.jpg";
    DETileOverlay *overlay = [[DETileOverlay alloc] initWithURLTemplate:template];
    overlay.canReplaceMapContent = YES;
    [self.mapView addOverlay:overlay level:MKOverlayLevelAboveLabels];
    
    WildcardGestureRecognizer * tapInterceptor = [[WildcardGestureRecognizer alloc] init];
    tapInterceptor.touchesBeganCallback = ^(NSSet * touches, UIEvent * event) {
        if(!self.questionCurrentlyShown) {
            [self placePin:event];
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

-(void)loadQuestions {
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    [apiWrapper request:[NSURL URLWithString:[NSString stringWithFormat:@"%@?amount=%i&language=%@&category=%@",kAPIRandomQuestions,kQuestionAmount,language,self.category.categoryId]] httpMethod:@"GET" optionalJSONData:nil optionalContentType:nil completed:^(NSDictionary *headers, NSString *body) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        [self parseQuestions:body];
    } failed:^(NSError *error){
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
    [self performSelector:@selector(showNextQuestion) withObject:nil afterDelay:1.0];


    
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

-(void)placePin:(UIEvent *)event {
    UITouch *touch = [[event allTouches]anyObject];
    CGPoint point = [touch locationInView:self.mapView];
    CLLocationCoordinate2D locCoord = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
    self.userPlacePin = [[MKPointAnnotation alloc] init];
    self.userPlacePin.coordinate = locCoord;
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotation:self.userPlacePin];
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
        [self showAnswerPin];
    }
}

-(void)showAnswerPin {
    DEQuestion *question = self.questions[(NSUInteger) self.currentQuestion];
    MKPointAnnotation *dropPin = [[MKPointAnnotation alloc] init];
    dropPin.coordinate = question.answer.coordinate;
    [self.mapView addAnnotation:dropPin];
    CLLocationCoordinate2D coordinateArray[2];
    coordinateArray[0] = self.userPlacePin.coordinate;
    coordinateArray[1] = dropPin.coordinate;
    
    self.routeLine = [MKPolyline polylineWithCoordinates:coordinateArray count:2];
    [self.mapView setVisibleMapRect:[self.routeLine boundingMapRect]];
    
    [self.mapView addOverlay:self.routeLine];
    [self performSelector:@selector(showNextQuestion) withObject:nil afterDelay:4.0];
}

-(void)showNextQuestion {
    //remove route
    [self.mapView removeOverlay:self.routeLine];

    self.currentQuestion += 1;
    self.questionCurrentlyShown = YES;
    NSString *question = [NSString stringWithFormat:@"%@ #%li",NSLocalizedString(@"question", nil),(long)self.currentQuestion];
    DEQuestionViewController *questionViewController = [[DEQuestionViewController alloc] initWithNibName:@"DEQuestionViewController" bundle:nil];
    questionViewController.question = question;
    [self presentPopupViewController:questionViewController animated:YES completion:nil];
}

-(void)showCurrentQuestion {
    self.questionCurrentlyShown = YES;
    NSString *question = [NSString stringWithFormat:@"%@ #%li",NSLocalizedString(@"question", nil),(long)self.currentQuestion];
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

-(MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
{
    if(overlay == self.routeLine)
    {
        if(nil == self.routeLineView)
        {
            self.routeLineView = [[MKPolylineView alloc] initWithPolyline:self.routeLine];
            self.routeLineView.fillColor = [UIColor redColor];
            self.routeLineView.strokeColor = [UIColor redColor];
            self.routeLineView.lineWidth = 2;
            
        }
        
        return self.routeLineView;
    }
    
    return nil;
}

@end
