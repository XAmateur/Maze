//
//  MazeNodeKit.m
//  labyrinth
//
//  Created by amateur on 9/23/16.
//  Copyright © 2016 王琪. All rights reserved.
//

#import "MazeNodeKit.h"

@implementation MazeNodeKit

- (instancetype)init
{
    if (self = [super init]) {
        _position = [[Position alloc]init];
        _direction = 1;
        _changeDirectionCount = 1;
    }
    return self;
}

@end
