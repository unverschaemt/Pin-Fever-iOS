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
    logoImageView.clipsToBounds = YES;
    logoImageView.layer.cornerRadius = logoImageView.frame.size.width/2;
    logoImageView.layer.borderWidth = 2.0;
    logoImageView.layer.borderColor = [UIColor colorWithWhite:0.97 alpha:1.0].CGColor;
    
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

-(IBAction)signUp:(id)sender {
    
}

-(IBAction)forgotPassword:(id)sender {
    
}

@end
