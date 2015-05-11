//
//  DEDeleteTextField.m
//  PinFever
//
//  Created by David Ehlen on 11.05.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import "DEDeleteTextField.h"

@implementation DEDeleteTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)deleteBackward {
    if ([self.deDelegate respondsToSelector:@selector(textFieldWillDelete)]){
        [self.deDelegate textFieldWillDelete];
    }
    [super deleteBackward];
}

@end
