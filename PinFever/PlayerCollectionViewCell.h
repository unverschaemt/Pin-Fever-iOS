//
//  PlayerCollectionViewCell.h
//  PinFever
//
//  Created by David Ehlen on 09.05.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayerCollectionViewCell : UICollectionViewCell {
    //UIImageView *overlayImageView;
}

@property (nonatomic,strong) IBOutlet UIImageView *playerImageView;
@property (nonatomic,strong) IBOutlet UILabel *playerNameLabel;
@end
