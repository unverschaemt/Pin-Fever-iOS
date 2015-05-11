//
//  DEDeleteTextField.h
//  PinFever
//
//  Created by David Ehlen on 11.05.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DEDeleteTextFieldDelegate <NSObject>
@optional
- (void)textFieldWillDelete;
@end


@interface DEDeleteTextField : UITextField <UIKeyInput>

@property (nonatomic, assign) id<DEDeleteTextFieldDelegate> deDelegate;

@end
