//
//  DEProfileViewController.h
//  PinFever
//
//  Created by David Ehlen on 18.05.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DEApiWrapper.h"
#import "DEProfileManager.h"
#import "DEFileManager.h"

@interface DEProfileViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    DEAPIWrapper *apiWrapper;
    DEProfileManager *profileManager;
    DEFileManager *fileManager;
}

@property(nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;
@end
