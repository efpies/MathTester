//
//  MainCtrl.m
//  MathTester
//
//  Created by Nickolay on 22.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainCtrl.h"
#import "Equation.h"
#import "AlertPair.h"
#import "NSArray+RandomObjectGetter.h"
#import "SettingsController.h"

#define KEY_LEVEL @"level"
#define KEY_CORRECT @"correct"
#define KEY_WRONG @"wrong"
#define KEY_TIME_SPENT @"time_spent"
#define KEY_PASSED @"passed"

@interface MainCtrl () <UIAlertViewDelegate, SettingsControllerDelegate> {
    IBOutlet UIView     *messageView;
    IBOutlet UIView     *startView;
    IBOutlet UIView     *wrongAnswerView;
    IBOutlet UILabel    *wrongAnswerAlertLabel;
    IBOutlet UILabel    *wrongAnswerMustBe;
    IBOutlet UIImageView *wrongImageView;
    IBOutlet UIView     *correctAnswerView;
    IBOutlet UILabel    *correctAnswerAlertLabel;
    IBOutlet UILabel    *correctAnswerTimeLabel;
    IBOutlet UIImageView *correctImageView;
    IBOutlet UIButton   *nextEquationButton;
    
    IBOutlet UIView     *equationView;
    IBOutlet UILabel    *equationLabel;
    IBOutlet UITextField *answerTextField;
    IBOutlet UIButton   *postAnswerButton;
    
    IBOutlet UILabel    *correctCountLabel;
    IBOutlet UILabel    *wrongCountLabel;
    IBOutlet UILabel    *averageTimeLabel;
}

- (IBAction)nextEquation;
- (IBAction)postAnswer;

@end

@implementation MainCtrl {
    Equation *equation;
    EquationType level;
    
    NSDate *startTime;
    NSNumberFormatter *secondsFormatter;
    NSNumberFormatter *millisecondsFormatter;
    NSInteger equationsPassed;
    NSTimeInterval totalTimeSpent;
    
    NSArray *good;
    NSArray *wrong;
    
    UIPopoverController *popoverSettings;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadState];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveState) name:UIApplicationWillResignActiveNotification object:nil];
    
    good = [NSArray arrayWithObjects:[AlertPair pairForFilename:@"good_awesome" message:@"You are awesome!"],
                                     [AlertPair pairForFilename:@"good_this_time" message:@"You won this time."],
                                     [AlertPair pairForFilename:@"good_oh_stop_it" message:@"You are very smart. Keep it up!"],
                                     nil];
    wrong = [NSArray arrayWithObjects:[AlertPair pairForFilename:@"wrong_kidding_me" message:@"Are you kidding me?"],
                                     [AlertPair pairForFilename:@"wrong_i_know_that_feel" message:@"I'm stupid too."],
                                     [AlertPair pairForFilename:@"wrong_oh_god_why" message:@"That one was simple, right?"],
                                        nil];
    
    UIBarButtonItem *clearBarBtn = [[UIBarButtonItem alloc] initWithTitle:@"Clear stats" style:UIBarButtonItemStylePlain target:self action:@selector(clearStats)];
    self.navigationItem.leftBarButtonItem = clearBarBtn;
    UIBarButtonItem *settingsBarBtn = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:self action:@selector(showSettings:)];
    self.navigationItem.rightBarButtonItem = settingsBarBtn;
    self.navigationItem.title = @"Awesome math tester";
    
    secondsFormatter = [NSNumberFormatter new];
    secondsFormatter.alwaysShowsDecimalSeparator = NO;
    secondsFormatter.positiveFormat = @"00";
    millisecondsFormatter = [NSNumberFormatter new];
    millisecondsFormatter.alwaysShowsDecimalSeparator = NO;
    millisecondsFormatter.positiveFormat = @"000";
    
    SettingsController *settingsCtrl = [[SettingsController alloc] initWithLevel:level];
    settingsCtrl.delegate = self;
    popoverSettings = [[UIPopoverController alloc] initWithContentViewController:settingsCtrl];
    popoverSettings.popoverContentSize = settingsCtrl.view.frame.size;
    
    if(equationsPassed) {
        [self showTime:totalTimeSpent / equationsPassed inLabel:averageTimeLabel];
        averageTimeLabel.text = [NSString stringWithFormat:@"AVERAGE TIME: %@", averageTimeLabel.text];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return interfaceOrientation == UIInterfaceOrientationPortrait;
}

#pragma mark - Actions

- (IBAction)nextEquation
{
    messageView.hidden = YES;
    equationView.hidden = NO;
    [self generateEquation];
    
    equationLabel.text = equation.equation;
    
    [answerTextField becomeFirstResponder];
    
    [self fireTimer];
}

- (void)showSettings:(id)sender
{
    if(!popoverSettings.isPopoverVisible) {
        [popoverSettings presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

- (void)clearStats
{
    UIAlertView *clearAlert = [[UIAlertView alloc] initWithTitle:@"Clear stats" message:@"Are you sure?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [clearAlert show];
}

- (IBAction)textFieldReturn:(id)sender
{
    [self postAnswer];
    [sender resignFirstResponder];
}

- (IBAction)postAnswer
{
    NSTimeInterval timeSpent = [self stopTimer];
    
    [answerTextField resignFirstResponder];
    equationView.hidden = YES;
    messageView.hidden = NO;
    startView.hidden = YES;
    
    if(equation.answer == answerTextField.text.integerValue) {
        [self incrementLabel:correctCountLabel];
        correctAnswerView.hidden = NO;
        wrongAnswerView.hidden = YES;
        [self showTime:timeSpent inLabel:correctAnswerTimeLabel];
        [self refreshAverageTime:timeSpent];
        [self showAlert:YES];
    }
    else {
        [self incrementLabel:wrongCountLabel];
        correctAnswerView.hidden = YES;
        wrongAnswerView.hidden = NO;
        wrongAnswerMustBe.text = [NSString stringWithFormat:@"%@ = %d", equation.equation, equation.answer];
        [self showAlert:NO];
    }
    
    answerTextField.text = @"";
}

#pragma mark - Custom methods

- (void)loadState
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSNumber *lastLevel = [userDefaults valueForKey:KEY_LEVEL];
    level = lastLevel.integerValue;
    
    NSNumber *correctCount = [userDefaults valueForKey:KEY_CORRECT];
    correctCountLabel.text = [NSString stringWithFormat:@"%d", correctCount.integerValue];
    
    NSNumber *wrongCount = [userDefaults valueForKey:KEY_WRONG];
    wrongCountLabel.text = [NSString stringWithFormat:@"%d", wrongCount.integerValue];
    
    NSNumber *timeSpent = [userDefaults valueForKey:KEY_TIME_SPENT];
    totalTimeSpent = timeSpent.doubleValue;
    
    NSNumber *passed = [userDefaults valueForKey:KEY_PASSED];
    equationsPassed = passed.integerValue;
}

- (void)saveState
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSNumber *lastLevel = [NSNumber numberWithInteger:level];
    [userDefaults setValue:lastLevel forKey:KEY_LEVEL];
    
    NSNumber *correctCount = [NSNumber numberWithInteger:correctCountLabel.text.integerValue];
    [userDefaults setValue:correctCount forKey:KEY_CORRECT];
    
    NSNumber *wrongCount = [NSNumber numberWithInteger:wrongCountLabel.text.integerValue];
    [userDefaults setValue:wrongCount forKey:KEY_WRONG];
    
    NSNumber *timeSpent = [NSNumber numberWithDouble:totalTimeSpent];
    [userDefaults setValue:timeSpent forKey:KEY_TIME_SPENT];
    
    NSNumber *passed = [NSNumber numberWithInteger:equationsPassed];
    [userDefaults setValue:passed forKey:KEY_PASSED];
    
    [userDefaults synchronize];
}

- (void)showAlert:(BOOL)isGood
{
    AlertPair *randomPair = (isGood) ? [good randomObject] : [wrong randomObject];
    UILabel *messageLabel = (isGood) ? correctAnswerAlertLabel : wrongAnswerAlertLabel;
    UIImageView *pic = (isGood) ? correctImageView : wrongImageView;
    
    messageLabel.text = randomPair.message;
    pic.image = [UIImage imageNamed:randomPair.filename];
}

- (void)incrementLabel:(UILabel *)label
{
    label.text = [NSString stringWithFormat:@"%d", label.text.integerValue + 1];
}

- (void)generateEquation
{
    equation = [[Equation alloc] initWithEquationType:level];
}

- (void)fireTimer
{
    startTime = [NSDate date];
}

- (NSTimeInterval)stopTimer
{
    return [[NSDate date] timeIntervalSinceDate:startTime];
}

- (void)showTime:(NSTimeInterval)time inLabel:(UILabel *)label
{
    time *= 1000;  // Convert to ms
    
    NSNumber *seconds = [NSNumber numberWithInteger:time / 1000.0f];
    NSNumber *milliseconds = [NSNumber numberWithInteger:(int)time % 1000];
    
    label.text = [NSString stringWithFormat:@"%@.%@", [secondsFormatter stringFromNumber:seconds], [millisecondsFormatter stringFromNumber:milliseconds]];
}

- (void)refreshAverageTime:(NSTimeInterval)addTime
{
    totalTimeSpent += addTime;
    ++equationsPassed;
    [self showTime:totalTimeSpent / equationsPassed inLabel:averageTimeLabel];
    averageTimeLabel.text = [NSString stringWithFormat:@"AVERAGE TIME: %@", averageTimeLabel.text];
}

- (void)goToStart
{
    startView.hidden = NO;
    messageView.hidden = NO;
    correctAnswerView.hidden = YES;
    wrongAnswerView.hidden = YES;
    equationView.hidden = YES;
    answerTextField.text = @"";
}

#pragma mark - UIAlertView delegate

- (void)alertViewCancel:(UIAlertView *)alertView
{
    [self goToStart];
    [answerTextField resignFirstResponder];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self goToStart];
    
    if(buttonIndex) {
        averageTimeLabel.text = @"AVERAGE TIME";
        totalTimeSpent = 0;
        equationsPassed = 0;
        correctCountLabel.text = @"0";
        wrongCountLabel.text = @"0";
    }
    
    [answerTextField resignFirstResponder];
}

#pragma mark - SettingsController delegate

- (void)settingsController:(SettingsController *)ctrl didSetLevel:(EquationType)_level
{
    level = _level;
    [popoverSettings dismissPopoverAnimated:YES];
}

@end