//
//  SamplePopupViewController.h
//  CWPopupDemo
//
//  Created by Cezary Wojcik on 8/21/13.
//  Copyright (c) 2013 Cezary Wojcik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DEQuestionViewController : UIViewController

@property (nonatomic, copy) NSString *question;
@property (nonatomic, weak) IBOutlet UILabel *questionLabel;

@end
