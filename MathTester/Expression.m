//
//  Expression.m
//  MathTester
//
//  Created by Nickolay on 23.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Expression.h"
#import "NSArray+RandomObjectGetter.h"
#import "NSString+FormatExpression.h"

@implementation Expression

@synthesize result;
@synthesize expression;

+ (Expression *)sumExpressionForLeftOperand:(NSInteger)left rightOperand:(NSInteger)right
{
    return [[Expression alloc] initWithExpression:[NSString formatExpressionWithLeftOperand:left sign:@"+" right:right]
                                           result:left + right];
}

+ (Expression *)sumExpressionForLeftExpression:(Expression *)left rightExpression:(Expression *)right
{
    return [[Expression alloc] initWithExpression:[NSString formatExpressionWithLeftParentheses:YES
                                                                               rightParentheses:YES
                                                                                    leftOperand:left.expression
                                                                                           sign:@"+"
                                                                                          right:right.expression]
                                           result:left.result + right.result];
}

+ (Expression *)diffExpressionForLeftOperand:(NSInteger)left rightOperand:(NSInteger)right
{
    return [[Expression alloc] initWithExpression:[NSString formatExpressionWithLeftOperand:left sign:@"-" right:right]
                                           result:left - right];
}

+ (Expression *)diffExpressionForLeftExpression:(Expression *)left rightExpression:(Expression *)right
{
    return [[Expression alloc] initWithExpression:[NSString formatExpressionWithLeftParentheses:YES
                                                                               rightParentheses:YES
                                                                                    leftOperand:left.expression
                                                                                           sign:@"-"
                                                                                          right:right.expression]
                                           result:left.result - right.result];
}

+ (Expression *)mulExpressionForLeftOperand:(NSInteger)left rightOperand:(NSInteger)right
{
    if(arc4random() % 2) {
        NSInteger t = left;
        left = right;
        right = t;
    }

    return [[Expression alloc] initWithExpression:[NSString formatExpressionWithLeftOperand:left sign:@"*" right:right]
                                           result:left * right];
}

+ (Expression *)mulExpressionForLeftExpression:(Expression *)left rightExpression:(Expression *)right
{
    if(arc4random() % 2) {
        Expression *t = left;
        left = right;
        right = t;
    }
    
    return [[Expression alloc] initWithExpression:[NSString formatExpressionWithLeftParentheses:YES
                                                                               rightParentheses:YES
                                                                                    leftOperand:left.expression
                                                                                           sign:@"*"
                                                                                          right:right.expression]
                                           result:left.result * right.result];
}

+ (Expression *)divExpressionForLeftOperandWithMinValue:(NSInteger)minLeft maxValue:(NSInteger)maxLeft maxDividerSigns:(NSInteger)maxDividerSigns
{
    NSMutableArray *dividers;
    NSInteger left;
    
    do {
        left = [self randomInRangeWithStart:minLeft end:maxLeft];
        NSInteger maxDivider = (maxDividerSigns) ? MIN(pow(10.0, maxDividerSigns) - 1, sqrt(left)) : sqrt(left);
        
        dividers = [NSMutableArray new];
        
        for(NSInteger i = 2; i <= maxDivider; ++i) {
            if(left % i == 0) {
                [dividers addObject:[NSNumber numberWithInteger:i]];
            }
        }
    } while (!dividers.count);
    
    NSNumber *randomDivider = [dividers randomObject];
    NSInteger right = randomDivider.integerValue;
    return [[Expression alloc] initWithExpression:[NSString formatExpressionWithLeftOperand:left sign:@"/" right:right]
                                           result:left / right];
}

+ (Expression *)divExpressionForLeftExpression:(Expression *)left rightExpression:(Expression *)right
{
    return [[Expression alloc] initWithExpression:[NSString formatExpressionWithLeftParentheses:YES
                                                                               rightParentheses:YES
                                                                                    leftOperand:left.expression
                                                                                           sign:@"/"
                                                                                          right:right.expression]
                                           result:left.result / right.result];
}

- (id)initWithExpression:(NSString *)_expression result:(NSInteger)_result
{
    if(self = [super init]) {
        expression = _expression;
        result = _result;
    }
    return self;
}

+ (NSInteger)randomInRangeWithStart:(NSInteger)start end:(NSInteger)end
{
    NSRange range = NSMakeRange(start, end - start);
    return arc4random() % range.length + range.location;
}

@end
