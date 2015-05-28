//
//  DEFileManager.h
//  PinFever
//
//  Created by David Ehlen on 28.05.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DEFileManager : NSObject


-(NSString *)saveFilePathWithSuffix:(NSString *)suffix;
-(void)saveMutableArray:(NSMutableArray *)array withFilename:(NSString *)filename;
-(NSMutableArray *)loadMutableArray:(NSString *)filename;

@end
