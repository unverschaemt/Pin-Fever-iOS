//
//  PlayerCollectionViewCell.m
//  PinFever
//
//  Created by David Ehlen on 09.05.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import "PlayerCollectionViewCell.h"

@implementation PlayerCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    self.playerImageView.clipsToBounds = YES;
    self.playerImageView.layer.cornerRadius = self.playerImageView.frame.size.width/2;
    self.playerImageView.layer.borderWidth = 1.0;
    self.playerImageView.layer.borderColor = [UIColor colorWithWhite:0.97 alpha:1.0].CGColor;
}

-(void)setSelected:(BOOL)selected {
    [super setSelected:selected];
}



@end
