//
//  AlertPair.m
//  MathTester
//
//  Created by Nickolay on 23.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AlertPair.h"

@implementation AlertPair

@synthesize filename;
@synthesize message;

- (id)initWithFilename:(NSString *)_filename message:(NSString *)_message
{
    if(self = [super init]) {
        filename = _filename;
        message = _message;
    }
    
    return self;
}

+ (AlertPair *)pairForFilename:(NSString *)filename message:(NSString *)message
{
    return [[AlertPair alloc] initWithFilename:filename message:message];
}

@end
