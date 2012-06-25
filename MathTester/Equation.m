//
//  Equation.m
//  MathTester
//
//  Created by Nickolay on 23.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Equation.h"
#import "NSArray+RandomObjectGetter.h"
#import "NSString+FormatExpression.h"

static NSInteger actionsCount = 4;

@implementation Equation {
    EquationType type;
}

@synthesize answer;
@synthesize equation;
@synthesize expression;

- (id)initWithEquationType:(EquationType)_type
{
    return [self initWithEquationType:_type action:-1];
}

- (id)initWithEquationType:(EquationType)_type action:(EquationAction)action
{
    if(self = [super init]) {
        type = _type;
        [self generateEquation:action];
    }
    
    return self;
}

- (void)generateEquation:(EquationAction)action
{
    switch (type) {
        case EquationType1:
            [self generateEquationType1:action];
            break;
            
        case EquationType2:
            [self generateEquationType2:action];
            break;
            
        case EquationType3:
            [self generateEquationType3:action];
            break;
            
        case EquationType4:
            [self generateEquationType4:action];
            break;
            
        case EquationType5:
            [self generateEquationType5];
            break;
            
        default:
            break;
    }
}

- (void)generateEquationType1:(EquationAction)action
{
    Expression *expr;
    EquationAction currentAction = (action != -1) ? action : arc4random() % actionsCount;
    
    switch (currentAction) {
        case EquationActionSum:
            expr = [Expression sumExpressionForLeftOperand:[self randomInRangeWithStart:25 end:99] rightOperand:[self randomInRangeWithStart:25 end:99]];
            break;
            
        case EquationActionDiff:
            expr = [Expression diffExpressionForLeftOperand:[self randomInRangeWithStart:11 end:99] rightOperand:[self randomInRangeWithStart:11 end:99]];
            break;
            
        case EquationActionMul:
            expr = [Expression mulExpressionForLeftOperand:[self randomInRangeWithStart:11 end:99] rightOperand:[self randomInRangeWithStart:2 end:9]];
            break;
            
        case EquationActionDiv:
            expr = [Expression divExpressionForLeftOperandWithMinValue:101 maxValue:999 maxDividerSigns:1];
            break;
    }
    
    answer = expr.result;
    equation = expr.expression;
    expression = expr;
}

- (void)generateEquationType2:(EquationAction)action
{
    Expression *expr;
    EquationAction currentAction = (action != -1) ? action : arc4random() % actionsCount;
    
    switch (currentAction) {
        case EquationActionSum:
            expr = [Expression sumExpressionForLeftOperand:[self randomInRangeWithStart:101 end:999] rightOperand:[self randomInRangeWithStart:101 end:999]];
            break;
            
        case EquationActionDiff:
            expr = [Expression diffExpressionForLeftOperand:[self randomInRangeWithStart:101 end:999] rightOperand:[self randomInRangeWithStart:101 end:999]];
            break;
            
        case EquationActionMul:
            expr = [Expression mulExpressionForLeftOperand:[self randomInRangeWithStart:11 end:59] rightOperand:[self randomInRangeWithStart:11 end:29]];
            break;
            
        case EquationActionDiv:
            expr = [Expression divExpressionForLeftOperandWithMinValue:101 maxValue:999 maxDividerSigns:0];
            break;
    }
    
    answer = expr.result;
    equation = expr.expression;
    expression = expr;
}

- (void)generateEquationType3:(EquationAction)action
{
    Expression *expr;
    EquationAction currentAction = (action != -1) ? action : arc4random() % actionsCount;
    
    switch (currentAction) {
        case EquationActionSum:
            expr = [Expression sumExpressionForLeftOperand:[self randomInRangeWithStart:1001 end:9999] rightOperand:[self randomInRangeWithStart:101 end:999]];
            break;
            
        case EquationActionDiff:
            expr = [Expression diffExpressionForLeftOperand:[self randomInRangeWithStart:101 end:9999] rightOperand:[self randomInRangeWithStart:101 end:9999]];
            break;
            
        case EquationActionMul:
            expr = [Expression mulExpressionForLeftOperand:[self randomInRangeWithStart:11 end:99] rightOperand:[self randomInRangeWithStart:11 end:99]];
            break;
            
        case EquationActionDiv:
            expr = [Expression divExpressionForLeftOperandWithMinValue:1001 maxValue:9999 maxDividerSigns:2];
            break;
    }
    
    answer = expr.result;
    equation = expr.expression;
    expression = expr;
}

- (void)generateEquationType4:(EquationAction)action
{
    Expression *expr;
    EquationAction currentAction = (action != -1) ? action : arc4random() % actionsCount;
    Equation *left, *right;
    
    switch (currentAction) {
        case EquationActionSum:
            left = [[Equation alloc] initWithEquationType:EquationType2 action:-1];
            right = [[Equation alloc] initWithEquationType:EquationType2 action:-1];
            expr = [Expression sumExpressionForLeftExpression:left.expression rightExpression:right.expression];
            break;
            
        case EquationActionDiff:
            left = [[Equation alloc] initWithEquationType:EquationType2 action:-1];
            right = [[Equation alloc] initWithEquationType:EquationType2 action:-1];            
            expr = [Expression diffExpressionForLeftExpression:left.expression rightExpression:right.expression];
            break;
            
        case EquationActionMul:
            left = [[Equation alloc] initWithEquationType:EquationType2 action:EquationActionDiv];
            EquationAction secondAction = (arc4random() % 2) ? ((arc4random() % 2) ? EquationActionSum : EquationActionDiff) : EquationActionMul;
            right = [[Equation alloc] initWithEquationType:EquationType2 action:secondAction];
            expr = [Expression mulExpressionForLeftExpression:left.expression rightExpression:right.expression];
            break;
            
        case EquationActionDiv:
            do {
                left = [[Equation alloc] initWithEquationType:EquationType2 action:EquationActionSum];
            } while ([self dividersCountForNumber:left.answer] < 3);
            
            do {
                right = [[Equation alloc] initWithEquationType:EquationType2 action:EquationActionDiv];
            } while (left.answer % right.answer != 0);
            
            expr = [Expression divExpressionForLeftExpression:left.expression rightExpression:right.expression];
            break;
    }
    
    answer = expr.result;
    equation = expr.expression;
    expression = expr;
}

- (void)generateEquationType5
{
    type = arc4random() % 4;
    [self generateEquation:-1];
}

#pragma mark - Eq gen

- (NSInteger)randomInRangeWithStart:(NSInteger)start end:(NSInteger)end
{
    NSRange range = NSMakeRange(start, end - start);
    return arc4random() % range.length + range.location;
}

- (NSInteger)dividersCountForNumber:(NSInteger)number
{
    NSInteger maxPossibleDivider = sqrt(number);
    NSInteger count = 0;
    for(NSInteger i = 2; i < maxPossibleDivider; ++i) {
        if(number % i == 0) {
            ++count;
        }
    }
    return count;
}

@end
