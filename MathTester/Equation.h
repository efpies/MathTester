//
//  Equation.h
//  MathTester
//
//  Created by Nickolay on 23.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Expression.h"

typedef enum {
    EquationType1 = 0,
    EquationType2,
    EquationType3,
    EquationType4,
    EquationType5
} EquationType;

@interface Equation : NSObject

@property (nonatomic, assign, readonly) NSInteger answer;
@property (nonatomic, retain, readonly) NSString *equation;
@property (nonatomic, retain, readonly) Expression *expression;

- (id)initWithEquationType:(EquationType)_type;
- (id)initWithEquationType:(EquationType)_type action:(EquationAction)action;

@end
