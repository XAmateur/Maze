//
//  ViewController.m
//  labyrinth
//
//  Created by 王琪 on 16/9/7.
//  Copyright © 2016年 王琪. All rights reserved.
//

#import "ViewController.h"
#import "MazeNode.h"


@interface ViewController ()

@property (nonatomic, strong) NSArray *maze;
@end

@implementation ViewController


#pragma mark - lazy 

- (NSArray *)maze
{
    if (!_maze) {
        _maze = @[@[@0,@0,@0,@0,@0,@0,@0,@0],
                  @[@0,@2,@1,@0,@0,@1,@0,@0],
                  @[@0,@1,@1,@0,@0,@0,@1,@0],
                  @[@0,@1,@0,@0,@0,@0,@0,@0],
                  @[@0,@1,@1,@1,@0,@0,@1,@3],
                  @[@0,@0,@0,@1,@0,@0,@1,@0],
                  @[@0,@0,@0,@1,@1,@1,@1,@0],
                  @[@0,@0,@0,@0,@0,@0,@0,@0]];
    }
    return _maze;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MazeNode *start = [[MazeNode alloc]init];
    start.position.xValue = 1;
    start.position.yValue = 1;
    start.currentStep = 0;
    start.direction = 1;
    
    
    NSMutableArray *stack = [NSMutableArray array];
    
    NSLog(@"start position is x:%ld y:%ld",(long)start.position.xValue,(long)start.position.yValue);
    NSLog(@"start value is : %@",self.maze[start.position.xValue][start.position.yValue]);

    [stack addObject:start];
    
//    NSLog(@"start position is x:%ld y:%ld",(long)start.xValue, (long)start.yValue);
    
    NSMutableArray *result = [self findMazeExit:stack];

}

- (NSMutableArray *)findMazeExit :(NSMutableArray *)stack
{
    NSMutableArray *invalidPosition = [NSMutableArray array];

    do {
        
        MazeNode *mazeNode = stack.lastObject;
        
        if ([self accessAble:mazeNode]) {
            
            MazeNode *nextStep = [[MazeNode alloc]init];
            
            nextStep.position.xValue = mazeNode.position.xValue;
            nextStep.position.yValue = mazeNode.position.yValue;

            nextStep.currentStep = mazeNode.currentStep+=1;
            
            nextStep = [self swithPosition:nextStep];
        
            NSLog(@"next step position is :x:%ld y:%ld", (long)nextStep.position.xValue,(long)nextStep.position.yValue);
            NSLog(@"next step count is: %ld",nextStep.currentStep);
            NSLog(@"next step node value is %@",[self nodeValue:nextStep]);

            [stack addObject:nextStep];

            NSLog(@"stack values is %@",stack);


        } else {
            
            [invalidPosition addObject:mazeNode.position];
            [stack removeLastObject];
            
            mazeNode = stack.lastObject;
            
            for (MazeNode *node in stack) {
                NSLog(@"the node xValue is :%ld, yValue is :%ld",(long)node.position.xValue,(long)node.position.yValue);
            }
            
            if (mazeNode.changeDirectionCount == 4 && stack.count>0) {
                
                [invalidPosition addObject:mazeNode.position];
                [stack removeLastObject];
                
            }
            
            mazeNode.changeDirectionCount += 1;
            
            if (mazeNode.direction == 4) {
                
                mazeNode.direction = 0;
            }
            
            MazeNode *nextStep = [[MazeNode alloc]init];
            mazeNode.direction += 1;
            nextStep.direction = mazeNode.direction;
            nextStep.position.xValue = mazeNode.position.xValue;
            nextStep.position.yValue = mazeNode.position.yValue;

            
            nextStep = [self swithPosition:nextStep];
            NSLog(@"the next step xValue is :%ld, yValue is :%ld",(long)nextStep.position.xValue,(long)nextStep.position.yValue);
            NSLog(@"the next direction is %ld",(long)nextStep.direction);
            
            [stack addObject:nextStep];
            
        }
        
    } while ([self isExit:stack.lastObject]);

    
    return stack;
}

- (BOOL)isExit: (MazeNode *)node
{
    return [[self nodeValue:node] integerValue] != 3;
}

- (MazeNode *)swithPosition :(MazeNode *)node
{
    
    switch (node.direction) {
            
        case 1: node.position.xValue += 1;
            break;
            
        case 2: node.position.yValue += 1;
            break;
            
        case 3: node.position.xValue -= 1;
            break;
            
        case 4: node.position.yValue -= 1;
            break;
            
        default:
            break;
    }
    
    return node;
}

- (BOOL)accessAble :(MazeNode *)node
{
    
    if ([[self nodeValue:node] integerValue] == 0) {
        return NO;
    } else {
        return YES;
    }
}

- (NSNumber *)nodeValue :(MazeNode *)node
{
    return _maze[node.position.xValue][node.position.yValue];
}


@end
