//
//  ViewController.m
//  PinFever
//
//  Created by David Ehlen on 04.05.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import "LoginViewController.h"


@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.logoImageView.clipsToBounds = YES;
    self.logoImageView.layer.cornerRadius = self.logoImageView.frame.size.width/2;
    self.logoImageView.layer.borderWidth = 2.0;
    self.logoImageView.layer.borderColor = [UIColor colorWithWhite:0.97 alpha:1.0].CGColor;
    
    [self setupTextFields];
    
    apiWrapper = [DEAPIWrapper new];
    [apiWrapper checkLogin];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Orientation

-(NSUInteger)supportedInterfaceOrientations
{
    return (UIInterfaceOrientationPortrait|UIInterfaceOrientationPortraitUpsideDown);
}

-(BOOL)shouldAutorotate
{
    return YES;
}

#pragma mark -
#pragma mark Methods

-(void)setupTextFields {
    self.emailField.delegate = self;
    self.passwordField.delegate = self;
    [self.emailField becomeFirstResponder];
}

-(void)showLoading:(BOOL)showIndicators {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:showIndicators];
    if(showIndicators) {
        [self.loadingView startAnimating];
    }
    else {
        [self.loadingView stopAnimating];
    }
}

-(void)loginFailed:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Login Error" message:[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"loginFailedWith", nil),[error localizedDescription]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark -
#pragma mark IBAction's
-(IBAction)login:(id)sender {
    NSString *email = self.emailField.text;
    NSString *password = self.passwordField.text;
    if(email.length <= 0 || password.length <= 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Login Error" message:NSLocalizedString(@"loginErrorMsg", nil) delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    [self showLoading:YES];

    [apiWrapper tryLogin:email andPassword:password completed:^(NSDictionary *header, NSString *body)
    {
        [self showLoading:NO];
    } failed:^(NSError *error){
        [self showLoading:NO];
        [self loginFailed:error];

    }];

}


-(IBAction)forgotPassword:(id)sender {
    
}

#pragma mark -
#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField == self.emailField) {
        [self.passwordField becomeFirstResponder];
        return YES;
    }
    [textField resignFirstResponder];
    return NO;
}


@end
