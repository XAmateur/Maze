//
//  NSArray+Safe.m
//  labyrinth
//
//  Created by amateur on 9/23/16.
//  Copyright © 2016 王琪. All rights reserved.
//

#import "NSArray+Safe.h"

@implementation NSArray (Safe)

- (id)safeObjectAtIndex:(NSInteger)index
{
    return index < self.count ? self[index] : nil;
}
@end
