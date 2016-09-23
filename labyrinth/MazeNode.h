//
//  MazeNode.h
//  labyrinth
//
//  Created by 王琪 on 16/9/8.
//  Copyright © 2016年 王琪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Position.h"

@interface MazeNode : NSObject

@property (nonatomic, strong) Position *position;
@property (nonatomic, assign) NSInteger currentStep;
@property (nonatomic, assign) NSInteger direction;
@property (nonatomic, assign) NSInteger changeDirectionCount;
@property (nonatomic, strong) NSNumber *value;

@end
