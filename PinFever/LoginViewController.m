//
//  ViewController.m
//  PinFever
//
//  Created by David Ehlen on 04.05.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import "LoginViewController.h"
#import "DEHomeViewController.h"
#import "AppDelegate.h"

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
    
}

-(void)setupTextFields {
    self.usernameField.delegate = self;
    self.passwordField.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSUInteger)supportedInterfaceOrientations
{
    return (UIInterfaceOrientationPortrait|UIInterfaceOrientationPortraitUpsideDown);
}

-(BOOL)shouldAutorotate
{
    return YES;
}


#pragma mark -
#pragma mark IBAction's
-(IBAction)login:(id)sender {
    DEHomeViewController *homeViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]]instantiateInitialViewController];
    homeViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    homeViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:homeViewController animated:YES completion:nil];
}

-(IBAction)forgotPassword:(id)sender {
    
}

#pragma mark -
#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField == self.usernameField) {
        [self.passwordField becomeFirstResponder];
        return YES;
    }
    [textField resignFirstResponder];
    return NO;
}


@end
