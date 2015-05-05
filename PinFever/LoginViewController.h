//
//  ViewController.h
//  PinFever
//
//  Created by David Ehlen on 04.05.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface LoginViewController : UIViewController <GPGStatusDelegate> {
    IBOutlet UIImageView *logoImageView;
    IBOutlet UIButton *loginButton;
    
    MBProgressHUD *hud;
}

-(IBAction)signIn:(id)sender;

@end

