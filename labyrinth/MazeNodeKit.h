//
//  MazeNodeKit.h
//  labyrinth
//
//  Created by amateur on 9/23/16.
//  Copyright © 2016 王琪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Position.h"

@interface MazeNodeKit : UIView

@property (nonatomic, strong) Position *position;
@property (nonatomic, assign) NSInteger currentStep;
@property (nonatomic, assign) NSInteger direction;
@property (nonatomic, assign) NSInteger changeDirectionCount;
@property (nonatomic, strong) NSNumber *displayValue;

@end
