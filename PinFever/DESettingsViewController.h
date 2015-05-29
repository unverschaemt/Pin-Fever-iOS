//
//  DESettingsViewController.h
//  PinFever
//
//  Created by David Ehlen on 05.05.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FXForms/FXForms.h>
#import "DEProfileManager.h"
#import "DEAPIWrapper.h"

@interface DESettingsViewController : UIViewController <FXFormControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate> {
    DEProfileManager *profileManager;
    DEAPIWrapper *apiWrapper;
}

@property (nonatomic, strong) FXFormController *formController;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end
