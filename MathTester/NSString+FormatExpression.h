//
//  NSString+FormatExpression.h
//  MathTester
//
//  Created by Nickolay on 24.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (FormatExpression)

+ (NSString *)formatExpressionWithLeftOperand:(NSInteger)left sign:(NSString *)sign right:(NSInteger)right;
+ (NSString *)formatExpressionWithLeftParentheses:(BOOL)leftParentheses rightParentheses:(BOOL)rightParentheses leftOperand:(NSString *)left sign:(NSString *)sign right:(NSString *)right;

@end
