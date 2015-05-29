//
//  DESettingsForm.m
//  Tiwi
//
//  Created by David Ehlen on 16.04.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import "DESettingsForm.h"
#import "DEProfileManager.h"

@implementation DESettingsForm


- (NSArray *)fields
{
    return @[
             @{FXFormFieldTitle: NSLocalizedString(@"changeAvatar", nil), FXFormFieldAction: @"changeAvatar:", FXFormFieldHeader:NSLocalizedString(@"accountSettings", nil),@"textLabel.font": [UIFont systemFontOfSize:16]},
             @"displayName"];
}

- (NSDictionary *)displayNameField
{
    NSString *name = [[[DEProfileManager sharedManager] me]displayName];
    if(name == nil) {
        name = @"";
    }
    return @{@"textField.autocapitalizationType": @(UITextAutocapitalizationTypeNone),
             @"textLabel.font": [UIFont systemFontOfSize:16],
             FXFormFieldAction:@"displayNameChanged:",
             @"textField.text" : name
             };
}

@end
