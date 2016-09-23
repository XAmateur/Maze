//
//  ViewController.m
//  labyrinth
//
//  Created by 王琪 on 16/9/7.
//  Copyright © 2016年 王琪. All rights reserved.
//

#import "ViewController.h"
#import "NSArray+Safe.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UIView *btnContainer;
@property (nonatomic, strong) NSArray *maze;
@property (nonatomic, strong) NSMutableArray *mazeKits;

@property (nonatomic, strong) NSArray *situations;

@property (nonatomic, strong) ViewControllerViewModel *viewModel;

@end

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@implementation ViewController
#pragma mark - lazy 

- (ViewControllerViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [[ViewControllerViewModel alloc]init];
    }
    return _viewModel;
}

- (NSArray *)maze
{
    if (!_maze) {
        _maze =
                @[@[@2,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0],
                  @[@1,@0,@1,@1,@1,@0,@0,@0,@0,@0,@0],
                  @[@1,@0,@1,@0,@0,@1,@0,@0,@0,@0,@0],
                  @[@1,@0,@1,@1,@0,@1,@0,@1,@1,@1,@3],
                  @[@1,@0,@0,@1,@0,@1,@0,@0,@1,@0,@0],
                  @[@1,@1,@1,@1,@0,@1,@0,@0,@1,@0,@0],
                  @[@0,@0,@0,@1,@1,@1,@0,@0,@1,@0,@0],
                  @[@0,@0,@0,@1,@0,@0,@0,@0,@1,@0,@0],
                  @[@1,@1,@1,@1,@0,@0,@0,@0,@1,@0,@0],
                  @[@1,@0,@0,@0,@0,@0,@0,@0,@1,@0,@0],
                  @[@1,@1,@1,@1,@1,@1,@1,@1,@1,@0,@0],];
    }
    return _maze;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configData];
    [self layoutUI];
}

- (void)layoutUI
{
    self.mazeKits = [NSMutableArray array];
    
    CGFloat regularLenght = SCREEN_WIDTH/_maze.count;
    
    for (int i=0 ;i<_maze.count;i++) {
        for (int j=0;j<[_maze[i] count];j++) {
            
            MazeNodeKit *mazeNode = [[MazeNodeKit alloc]init];
            mazeNode.position.xValue = i;
            mazeNode.position.yValue = j;
            mazeNode.displayValue = _maze[i][j];
            
            
            if ([_maze[i][j] integerValue]== 0) {
                mazeNode.backgroundColor = [UIColor lightGrayColor];
            }
            
            if ([_maze[i][j] integerValue]== 1) {
                mazeNode.backgroundColor = [UIColor whiteColor];
            }
            
            if ([_maze[i][j] integerValue]== 2) {
                mazeNode.backgroundColor = [UIColor greenColor];
            }
            
            if ([_maze[i][j] integerValue]== 3) {
                mazeNode.backgroundColor = [UIColor redColor];
            }
            
            [mazeNode setFrame:CGRectMake(0+regularLenght*i, 0+regularLenght*j, regularLenght-1, regularLenght-1)];
            
            [self.mazeKits addObject:mazeNode];
            [self.btnContainer addSubview:mazeNode];
        }
    }
}

- (IBAction)start:(UIButton *)sender
{
    NSLog(@"situations is %@",self.situations);
    
    for (NSArray *array in self.situations)
    {
        for (MazeNodeKit *node in array) {
            
            for (MazeNodeKit *node1 in self.mazeKits) {
                
                if (node.position.xValue == node1.position.xValue && node.position.yValue == node1.position.yValue) {
                    
                    node1.backgroundColor = [UIColor blueColor];
                    NSLog(@"node1 position is x = %ld, y = %ld",(long)node1.position.xValue,(long)node1.position.yValue);
                }
            }
        }
    }
}

- (void)configData
{
    
    NSMutableArray *stack = [NSMutableArray array];
    MazeNodeKit *start = [[MazeNodeKit alloc]init];
    start.position.xValue = 1;
    start.position.yValue = 1;
    start.currentStep = 0;
    start.direction = 1;
    
    NSLog(@"start position is x:%ld y:%ld",(long)start.position.xValue,(long)start.position.yValue);
    NSLog(@"start value is : %@",self.maze[start.position.xValue][start.position.yValue]);
    
    [stack addObject:start];
    
    self.viewModel.maze = self.maze;
   self.situations = [self.viewModel findMazeExit:stack];
}

@end

@implementation ViewControllerViewModel

- (NSArray *)findMazeExit :(NSMutableArray *)stack
{
    NSMutableArray *container = [NSMutableArray array];
    
    do {
        
        MazeNodeKit *mazeNode = stack.lastObject;
        
        if ([self accessAble:mazeNode]) {
            
            MazeNodeKit *nextStep = [[MazeNodeKit alloc]init];
            
            nextStep.position.xValue = mazeNode.position.xValue;
            nextStep.position.yValue = mazeNode.position.yValue;
            nextStep.currentStep = mazeNode.currentStep+=1;
            nextStep = [self swithPosition:nextStep];
            [stack addObject:nextStep];
            
            [container addObject:stack];
            
        } else {
            
            [stack removeLastObject];
            mazeNode = stack.lastObject;
     
            if (mazeNode.changeDirectionCount > 4 && stack.count>0) {
                
                [stack removeLastObject];
            }
            
            mazeNode.changeDirectionCount += 1;
            
            if (mazeNode.direction == 4) {
                
                mazeNode.direction = 0;
            }
            
            MazeNodeKit *nextStep = [[MazeNodeKit alloc]init];
            mazeNode.direction += 1;
            nextStep.direction = mazeNode.direction;
            nextStep.position.xValue = mazeNode.position.xValue;
            nextStep.position.yValue = mazeNode.position.yValue;
            nextStep = [self swithPosition:nextStep];
            
            if ([self isStackContainCurrentStep:nextStep stack:stack]) {
                
                NSInteger direction = 5 - mazeNode.direction;
                nextStep.direction = direction;
                nextStep.position.xValue = mazeNode.position.xValue;
                nextStep.position.yValue = mazeNode.position.yValue;
                nextStep = [self swithPosition:nextStep];
            }
            
            [stack addObject:nextStep];
        }
        
    } while ([self isExit:stack.lastObject]);
    
    self.dataArray = container;
    NSLog(@"%@",stack);
    return self.dataArray;
}

- (BOOL)isExit: (MazeNodeKit *)node
{
    return [[self nodeValue:node] integerValue] != 3;
}

- (MazeNodeKit *)swithPosition :(MazeNodeKit *)node
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

- (BOOL)accessAble :(MazeNodeKit *)node
{
    if ([[self nodeValue:node] integerValue] == 0) {
        return NO;
    } else {
        return YES;
    }
}

- (NSNumber *)nodeValue :(MazeNodeKit *)node
{
    return [[_maze safeObjectAtIndex:node.position.xValue] safeObjectAtIndex:node.position.yValue];
}

- (BOOL)isStackContainCurrentStep:(MazeNodeKit *)nextStep stack:(NSArray *)stack
{
    for (MazeNodeKit *node in stack)
    {
        if (node.position.xValue == nextStep.position.xValue && node.position.yValue == nextStep.position.yValue) {
            
            return YES;
        }
    }
    return NO;
}


@end
