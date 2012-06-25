//
//  AlertPair.h
//  MathTester
//
//  Created by Nickolay on 23.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlertPair : NSObject

@property (nonatomic, retain, readonly) NSString *filename;
@property (nonatomic, retain, readonly) NSString *message;

+ (AlertPair *)pairForFilename:(NSString *)filename message:(NSString *)message;

@end
