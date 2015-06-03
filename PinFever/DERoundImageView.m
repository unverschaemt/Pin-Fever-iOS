//
// Created by David Ehlen on 02.06.15.
// Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import "DERoundImageView.h"


@implementation DERoundImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self commonInit];
    }
    return self;
}


- (id)initWithImage:(UIImage *)image
{
    self = [super initWithImage:image];
    if (self)
    {
        [self commonInit];
    }
    return self;
}

- (id)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage
{
    self = [super initWithImage:image highlightedImage:highlightedImage];
    if (self)
        [self commonInit];
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
        [self commonInit];
    return self;
}

-(void)commonInit {
    self.clipsToBounds = YES;
    self.layer.cornerRadius = self.frame.size.width/2;
    self.layer.borderWidth = 2.0;
    self.layer.borderColor = [UIColor colorWithWhite:0.97 alpha:1.0].CGColor;
    self.contentMode = UIViewContentModeScaleAspectFill;
}
@end