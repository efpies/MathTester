//
//  SettingsController.m
//  MathTester
//
//  Created by Nickolay on 23.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingsController.h"

@interface SettingsController () {
    IBOutlet UINavigationBar *navBar;
    IBOutletCollection(UIButton) NSMutableArray *buttons;
}

- (IBAction)typeSelected:(id)sender;

@end

@implementation SettingsController {
    EquationType currentLevel;
    UIColor *inactiveBtnColor;
    UIColor *activeBtnColor;
}

@synthesize delegate;

- (id)initWithLevel:(EquationType)level
{
    if(self = [super init]) {
        currentLevel = level;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    inactiveBtnColor = [UIColor colorWithRed:51.0f / 255.0 green:51.0 / 255.0 blue:51.0 / 255.0 alpha:0.15];
    activeBtnColor = [UIColor colorWithRed:255.0 / 255.0 green:204.0 / 255.0 blue:102.0 / 255.0 alpha:1.0];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshSelectedButton];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return interfaceOrientation == UIInterfaceOrientationPortrait;
}

#pragma mark - Actions

- (IBAction)typeSelected:(id)sender
{
    currentLevel = [buttons indexOfObject:sender];
    [self refreshSelectedButton];
    [delegate settingsController:self didSetLevel:currentLevel];
}

#pragma mark - Custom methods

- (void)refreshSelectedButton
{
    for(UIButton *button in buttons) {
        button.backgroundColor = inactiveBtnColor;
    }
    
    UIButton *activeButton = [buttons objectAtIndex:currentLevel];
    activeButton.backgroundColor = activeBtnColor;
}

@end
