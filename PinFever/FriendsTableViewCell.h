//
//  FriendsTableViewCell.h
//  PinFever
//
//  Created by David Ehlen on 05.05.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendsTableViewCell : UITableViewCell

@property (nonatomic,weak) IBOutlet UILabel *titleLabel;
@property (nonatomic,weak) IBOutlet UIImageView *playerImageView;
@property (nonatomic, weak) IBOutlet UIButton *playButton;

@end
