//
//  ViewController.h
//  PinFever
//
//  Created by David Ehlen on 04.05.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UITextFieldDelegate>

-(IBAction)login:(id)sender;
-(IBAction)forgotPassword:(id)sender;

@property (nonatomic, weak) IBOutlet UIImageView *logoImageView;
@property (nonatomic, weak) IBOutlet UITextField *usernameField;
@property (nonatomic, weak) IBOutlet UITextField *passwordField;

@property (nonatomic, weak) IBOutlet UIButton *loginButton;
@property (nonatomic, weak) IBOutlet UIButton *forgotPwButton;
@property (nonatomic, weak) IBOutlet UIButton *signupButton;

@end

