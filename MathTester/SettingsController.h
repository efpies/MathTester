//
//  SettingsController.h
//  MathTester
//
//  Created by Nickolay on 23.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Equation.h"

@protocol SettingsControllerDelegate;

@interface SettingsController : UIViewController

@property (nonatomic, unsafe_unretained) id<SettingsControllerDelegate> delegate;

- (id)initWithLevel:(EquationType)level;

@end

@protocol SettingsControllerDelegate <NSObject>
- (void)settingsController:(SettingsController *)ctrl didSetLevel:(EquationType)level;
@end