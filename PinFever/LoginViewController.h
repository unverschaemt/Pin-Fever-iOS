//
//  ViewController.h
//  PinFever
//
//  Created by David Ehlen on 04.05.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UITextFieldDelegate> {
    IBOutlet UIImageView *logoImageView;
    IBOutlet UITextField *usernameField;
    IBOutlet UITextField *passwordField;
    
    IBOutlet UIButton *loginButton;
    IBOutlet UIButton *forgotPwButton;
    IBOutlet UIButton *signupButton;
}

-(IBAction)login:(id)sender;
-(IBAction)forgotPassword:(id)sender;

@end

