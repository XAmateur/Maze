//
//  ViewController.h
//  labyrinth
//
//  Created by 王琪 on 16/9/7.
//  Copyright © 2016年 王琪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MazeNodeKit.h"

@interface ViewControllerViewModel : NSObject

@property (nonatomic, strong) NSArray <MazeNodeKit *> *dataArray;
@property (nonatomic, strong) NSArray *maze;

- (NSArray *)findMazeExit :(NSMutableArray *)stack;

@end

@interface ViewController : UIViewController


@end

