//
//  DEFileManager.m
//  PinFever
//
//  Created by David Ehlen on 28.05.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import "DEFileManager.h"

@implementation DEFileManager


-(NSString *)saveFilePathWithSuffix:(NSString *)suffix {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, suffix];
    return filePath;
}

-(void)saveMutableArray:(NSMutableArray *)array withFilename:(NSString *)filename {
    [NSKeyedArchiver archiveRootObject:array toFile:[self saveFilePathWithSuffix:filename]];
}

-(NSMutableArray *)loadMutableArray:(NSString *)filename {
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:[self saveFilePathWithSuffix:filename]];
    
    if (fileExists) {
        NSMutableArray *arr = [NSKeyedUnarchiver unarchiveObjectWithFile:[self saveFilePathWithSuffix:filename]];
        
        if(arr) {
            return arr;
        }
        else {
            return [NSMutableArray new];
        }
    } else {
        return [NSMutableArray new];
    }

}

@end
