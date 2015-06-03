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
    
    apiWrapper = [DEAPIWrapper new];
    
    [self setupTextFields];
    
}

-(void)setupTextFields {
    self.usernameField.delegate = self;
    self.emailField.delegate = self;
    self.passwordField.delegate = self;
    self.rePasswordField.delegate = self;
    [self.usernameField becomeFirstResponder];
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
#pragma mark Methods

-(void)registerFailed:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"registerError", nil) message:[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"registerFailedWith", nil),[error localizedDescription]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
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


-(IBAction)signUp:(id)sender {
    NSString *email = self.emailField.text;
    NSString *password = self.passwordField.text;
    NSString *rePassword = self.rePasswordField.text;
    NSString *username = self.usernameField.text;
    
    if(email.length == 0 || password.length == 0 || rePassword.length == 0 || username.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"registerError", nil) message:NSLocalizedString(@"registerErrorMsg", nil) delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if(![password isEqualToString:rePassword]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"registerError", nil) message:NSLocalizedString(@"registerPwError", nil) delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    [self showLoading:YES];
    [apiWrapper tryRegister:email andPassword:password andUsername:username completed:^(NSDictionary *headers, NSString *body)
    {
        [self showLoading:NO];

    } failed:^(NSError *error){
        [self showLoading:NO];
        [self registerFailed:error];
    }];

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
