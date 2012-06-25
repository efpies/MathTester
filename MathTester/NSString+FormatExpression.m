//
//  NSString+FormatExpression.m
//  MathTester
//
//  Created by Nickolay on 24.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSString+FormatExpression.h"

@implementation NSString (FormatExpression)

+ (NSString *)formatExpressionWithLeftOperand:(NSInteger)left sign:(NSString *)sign right:(NSInteger)right
{
    return [NSString stringWithFormat:@"%d %@ %d", left, sign, right];
}

+ (NSString *)formatExpressionWithLeftParentheses:(BOOL)leftParentheses rightParentheses:(BOOL)rightParentheses leftOperand:(NSString *)left sign:(NSString *)sign right:(NSString *)right
{
    NSString *leftPart = [NSString encloseInParentheses:leftParentheses expression:left];
    NSString *rightPart = [NSString encloseInParentheses:rightParentheses expression:right];
    return [NSString stringWithFormat:@"%@ %@ %@", leftPart, sign, rightPart];
}

+ (NSString *)encloseInParentheses:(BOOL)enclose expression:(NSString *)expression
{
    return [NSString stringWithFormat:@"%@%@%@", enclose ? @"(" : @"", expression, enclose ? @")" : @""];
}

@end

