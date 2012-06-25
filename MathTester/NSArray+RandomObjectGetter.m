//
//  NSArray+RandomObjectGetter.m
//  MathTester
//
//  Created by Nickolay on 23.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSArray+RandomObjectGetter.h"

@implementation NSArray (RandomObjectGetter)

-(id)randomObject
{
    // 1
    if (self.count < 1) {
        return nil;
    }
    
    // 2
    int randomIndex = (int)(arc4random() % self.count);    
    
    id foundObject = nil;
    foundObject = [self objectAtIndex: randomIndex];
    return foundObject;
}

@end
