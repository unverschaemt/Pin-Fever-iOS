//
//  PlayerCollectionViewCell.h
//  PinFever
//
//  Created by David Ehlen on 09.05.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DERoundImageView.h"

@interface PlayerCollectionViewCell : UICollectionViewCell

@property (nonatomic,weak) IBOutlet DERoundImageView *playerImageView;
@property (nonatomic,weak) IBOutlet UILabel *playerNameLabel;
@property (nonatomic,weak) IBOutlet UIButton *deleteButton;
@end
