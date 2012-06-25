//
//  Expression.h
//  MathTester
//
//  Created by Nickolay on 23.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    EquationActionSum = 0,
    EquationActionDiff,
    EquationActionMul,
    EquationActionDiv
} EquationAction;

@interface Expression : NSObject

@property (nonatomic, assign, readonly) NSInteger result;
@property (nonatomic, assign, readonly) NSString *expression;

+ (Expression *)sumExpressionForLeftOperand:(NSInteger)left rightOperand:(NSInteger)right;
+ (Expression *)diffExpressionForLeftOperand:(NSInteger)left rightOperand:(NSInteger)right;
+ (Expression *)mulExpressionForLeftOperand:(NSInteger)left rightOperand:(NSInteger)right;
+ (Expression *)divExpressionForLeftOperandWithMinValue:(NSInteger)minLeft maxValue:(NSInteger)maxLeft maxDividerSigns:(NSInteger)maxDividerSigns;

+ (Expression *)sumExpressionForLeftExpression:(Expression *)left rightExpression:(Expression *)right;
+ (Expression *)diffExpressionForLeftExpression:(Expression *)left rightExpression:(Expression *)right;
+ (Expression *)mulExpressionForLeftExpression:(Expression *)left rightExpression:(Expression *)right;
+ (Expression *)divExpressionForLeftExpression:(Expression *)left rightExpression:(Expression *)right;
@end
