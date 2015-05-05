//
//  DEHomeViewController.h
//  PinFever
//
//  Created by David Ehlen on 05.05.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DEHomeViewController : UIViewController <UITableViewDataSource,UITableViewDelegate> {
    IBOutlet UIImageView *avatarImageView;
    IBOutlet UILabel *scoreLabel;
    
    GPGPlayer *player;
}

@property (nonatomic,assign) BOOL avatarLoaded;
@property (nonatomic,weak) IBOutlet UITableView *tableView;

@end
