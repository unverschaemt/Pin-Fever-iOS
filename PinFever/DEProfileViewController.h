//
//  DEProfileViewController.h
//  PinFever
//
//  Created by David Ehlen on 18.05.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DEProfileManager.h"
#import "DEFileManager.h"
#import "DERoundImageView.h"

@interface DEProfileViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    DEProfileManager *profileManager;
    DEFileManager *fileManager;
}

@property(nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet DERoundImageView *avatarImageView;
@end
