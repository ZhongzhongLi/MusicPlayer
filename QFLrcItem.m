//
//  QFLrcItem.m
//  OC12_歌词解析
//
//  Created by LZXuan on 15-4-25.
//  Copyright (c) 2015年 LZXuan. All rights reserved.
//

#import "QFLrcItem.h"

@implementation QFLrcItem

- (void)dealloc {
    self.lrc = nil;
    [super dealloc];
}

- (BOOL)isTimeOldThanAnother:(QFLrcItem *)another {
    return self.time > another.time;
}

/*
- (BOOL)isEqualToString:(NSString *)str {
    return YES;
}
 */

@end
