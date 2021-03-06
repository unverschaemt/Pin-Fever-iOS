//
//  ViewController.h
//  PinFever
//
//  Created by David Ehlen on 04.05.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DEAPIWrapper.h"
#import "DERoundImageView.h"

@interface LoginViewController : UIViewController<UITextFieldDelegate> {
    DEAPIWrapper *apiWrapper;
}

-(IBAction)login:(id)sender;
-(IBAction)forgotPassword:(id)sender;

@property (nonatomic, weak) IBOutlet DERoundImageView *logoImageView;
@property (nonatomic, weak) IBOutlet UITextField *emailField;
@property (nonatomic, weak) IBOutlet UITextField *passwordField;

@property (nonatomic, weak) IBOutlet UIButton *loginButton;
@property (nonatomic, weak) IBOutlet UIButton *forgotPwButton;
@property (nonatomic, weak) IBOutlet UIButton *signupButton;

@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *loadingView;
@end

