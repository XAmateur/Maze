//
//  MazeNode.m
//  labyrinth
//
//  Created by 王琪 on 16/9/8.
//  Copyright © 2016年 王琪. All rights reserved.
//

#import "MazeNode.h"

@implementation MazeNode


- (instancetype)init
{
    if (self = [super init]) {
        _position = [[Position alloc]init];
        _direction = 1;
    }
    return self;
}

@end
