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

-(DEPlayer *)loadPlayer:(NSString *)filename {
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:[self saveFilePathWithSuffix:filename]];
    
    if (fileExists) {
        DEPlayer *player = [NSKeyedUnarchiver unarchiveObjectWithFile:[self saveFilePathWithSuffix:filename]];
        
        if(player) {
            return player;
        }
    }
    return nil;

}
-(void)savePlayer:(DEPlayer *)player withFilename:(NSString *)filename {
    [NSKeyedArchiver archiveRootObject:player toFile:[self saveFilePathWithSuffix:filename]];
}

-(void)deleteAllFiles {
    BOOL friendsFileExists = [[NSFileManager defaultManager] fileExistsAtPath:[self saveFilePathWithSuffix:kFriendsFilename]];
    BOOL playerFileExists = [[NSFileManager defaultManager] fileExistsAtPath:[self saveFilePathWithSuffix:kPlayerFilename]];
    
    if(friendsFileExists) {
        [[NSFileManager defaultManager]removeItemAtPath:[self saveFilePathWithSuffix:kFriendsFilename] error:nil];
    }
    
    if(playerFileExists) {
        [[NSFileManager defaultManager]removeItemAtPath:[self saveFilePathWithSuffix:kPlayerFilename] error:nil];
    }

}

@end
