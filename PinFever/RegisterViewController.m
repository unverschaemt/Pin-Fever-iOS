//
//  RegisterViewController.m
//  PinFever
//
//  Created by David Ehlen on 11.05.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    logoImageView.clipsToBounds = YES;
    logoImageView.layer.cornerRadius = logoImageView.frame.size.width/2;
    logoImageView.layer.borderWidth = 2.0;
    logoImageView.layer.borderColor = [UIColor colorWithWhite:0.97 alpha:1.0].CGColor;
    
    [self setupTextFields];
}

-(void)setupTextFields {
    usernameField.delegate = self;
    emailField.delegate = self;
    passwordField.delegate = self;
    rePasswordField.delegate = self;
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

-(IBAction)signUp:(id)sender {
    
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
#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField == usernameField) {
        [emailField becomeFirstResponder];
    }
    else if (textField == emailField) {
        [passwordField becomeFirstResponder];
    }
    else if(textField == passwordField) {
        [rePasswordField becomeFirstResponder];
    }
    return YES;
}

@end
