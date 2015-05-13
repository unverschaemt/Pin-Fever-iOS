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
    self.logoImageView.clipsToBounds = YES;
    self.logoImageView.layer.cornerRadius = self.logoImageView.frame.size.width/2;
    self.logoImageView.layer.borderWidth = 2.0;
    self.logoImageView.layer.borderColor = [UIColor colorWithWhite:0.97 alpha:1.0].CGColor;
    
    [self setupTextFields];
}

-(void)setupTextFields {
    self.usernameField.delegate = self;
    self.emailField.delegate = self;
    self.passwordField.delegate = self;
    self.rePasswordField.delegate = self;
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
    if(textField == self.usernameField) {
        [self.emailField becomeFirstResponder];
        return YES;
    }
    else if (textField == self.emailField) {
        [self.passwordField becomeFirstResponder];
        return YES;
    }
    else if(textField == self.passwordField) {
        [self.rePasswordField becomeFirstResponder];
        return YES;
    }
    [textField resignFirstResponder];
    return NO;
}

@end
