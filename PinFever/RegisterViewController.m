//
//  RegisterViewController.m
//  PinFever
//
//  Created by David Ehlen on 11.05.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import "RegisterViewController.h"
#import <STHTTPRequest/STHTTPRequest.h>
#import "DEHomeViewController.h"
#import "AppDelegate.h"
#import "KeychainItemWrapper.h"

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


-(void)saveAuthToken:(NSString *)token {
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:kKeychainKey accessGroup:nil];
    [keychainItem setObject:token forKey:(__bridge id)(kSecValueData)];
    
}

-(void)pushToHomeController {
    DEHomeViewController *homeViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]]instantiateInitialViewController];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    app.window.rootViewController = homeViewController;
}


-(IBAction)signUp:(id)sender {
    NSString *email = self.emailField.text;
    NSString *password = self.passwordField.text;
    NSString *rePassword = self.rePasswordField.text;
    NSString *username = self.usernameField.text;
    
    if(email.length == 0 || password.length == 0 || rePassword == 0 || username.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"registerError", nil) message:NSLocalizedString(@"registerErrorMsg", nil) delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if(![password isEqualToString:rePassword]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"registerError", nil) message:NSLocalizedString(@"registerPwError", nil) delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    NSURL *registerURL = [NSURL URLWithString:kRegisterEndpoint];
    STHTTPRequest *r = [STHTTPRequest requestWithURL:registerURL];
    r.POSTDictionary = @{ @"email":email, @"password":password, @"displayName":username };
    NSLog(@"%@",registerURL.description);
    
    r.completionBlock = ^(NSDictionary *headers, NSString *body) {
        NSLog(@"Body: %@",body);
        NSData *jsonData = [body dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:nil];
        if([response objectForKey:kErrorKey] == (id)[NSNull null]) {
            //Register Success
            NSString *token = [[response objectForKey:kDataKey]objectForKey:kTokenKey];
            if(token.length != 0) {
                [self saveAuthToken:token];
                [self pushToHomeController];
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"registerError", nil)message:NSLocalizedString(@"registerGenericMsg", nil) delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"registerError", nil) message:NSLocalizedString(@"registerGenericMsg", nil) delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    };
    
    r.errorBlock = ^(NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"registerError", nil) message:[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"registerFailedWith", nil),[error localizedDescription]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    };
    
    [r startAsynchronous];

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
