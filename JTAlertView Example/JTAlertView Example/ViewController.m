//
//  ViewController.m
//  JTAlertView Example
//
//  Created by Jakub Truhlar on 13.06.15.
//  Copyright (c) 2015 Jakub Truhlar. All rights reserved.
//

#import "ViewController.h"
#import "JTAlertView.h"

@interface ViewController ()

@property (nonatomic, strong) JTAlertView *alertView;
@property (nonatomic, assign) bool animated;
@property (nonatomic, assign) bool destructive;
@property (nonatomic, strong) UIFont *customFont;
@property (nonatomic, assign) bool pop;
@property (nonatomic, assign) bool parallax;
@property (nonatomic, assign) bool bg;
@property (nonatomic, assign) NSInteger numberOfButtons;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Example settings
    _numberOfButtons = 2;
    _animated = true;
    _destructive = false;
    _pop = true;
    _parallax = true;
    _customFont = nil;
    _bg = false;
    
    _segmentControl.selectedSegmentIndex = _numberOfButtons;
    _animatedSwitch.on = _animated;
    _destructiveSwitch.on = _destructive;
    _popSwitch.on = _pop;
    _parallaxSwitch.on = _parallax;
    _fontSwitch.on = _customFont ? true : false;
    _bgSwitch.on = _bg;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)showPressed:(id)sender {
    self.alertView = [[JTAlertView alloc] initWithTitle:[@"Hello, I'm a brand new alertView" uppercaseString] andImage:[UIImage imageNamed:@"city"]];
    self.alertView.size = CGSizeMake(280, 230);
    self.alertView.popAnimation = _pop;
    self.alertView.parallaxEffect = _parallax;
    self.alertView.backgroundShadow = _bg;
    
    __weak typeof(self)weakSelf = self;
    
    switch (_numberOfButtons) {
        case 0:
            [self.alertView hideWithDelay:1.5 animated:weakSelf.animated];
            [self performSelector:@selector(fadeExampleSettings) withObject:nil afterDelay:1.5];
            break;
        case 1:
            if (_destructive) {
                [self.alertView addButtonWithTitle:@"DELETE" font:_customFont style:JTAlertViewStyleDestructive forControlEvents:UIControlEventTouchUpInside action:^(JTAlertView *alertView) {
                    NSLog(@"JTAlertView: DELETE pressed");
                    [alertView hideWithCompletion:nil animated:weakSelf.animated];
                    [weakSelf fadeExampleSettings];
                }];
            } else {
                [self.alertView addButtonWithTitle:@"OK" font:_customFont style:JTAlertViewStyleDefault forControlEvents:UIControlEventTouchUpInside action:^(JTAlertView *alertView) {
                    NSLog(@"JTAlertView: OK pressed");
                    [alertView hideWithCompletion:nil animated:weakSelf.animated];
                    [weakSelf fadeExampleSettings];
                }];
            }
            break;
        case 2:
            if (_destructive) {
                [self.alertView addButtonWithTitle:@"CANCEL" font:_customFont style:JTAlertViewStyleDefault forControlEvents:UIControlEventTouchUpInside action:^(JTAlertView *alertView) {
                    NSLog(@"JTAlertView: CANCEL pressed");
                    [alertView hideWithCompletion:nil animated:weakSelf.animated];
                    [weakSelf fadeExampleSettings];
                }];
                [self.alertView addButtonWithTitle:@"DELETE" font:_customFont style:JTAlertViewStyleDestructive forControlEvents:UIControlEventTouchUpInside action:^(JTAlertView *alertView) {
                    NSLog(@"JTAlertView: DELETE pressed");
                    [alertView hideWithCompletion:nil animated:weakSelf.animated];
                    [weakSelf fadeExampleSettings];
                }];
            } else {
                [self.alertView addButtonWithTitle:@"OK" font:_customFont style:JTAlertViewStyleDefault forControlEvents:UIControlEventTouchUpInside action:^(JTAlertView *alertView) {
                    NSLog(@"JTAlertView: OK pressed");
                    [alertView hideWithCompletion:nil animated:weakSelf.animated];
                    [weakSelf fadeExampleSettings];
                }];
                [self.alertView addButtonWithTitle:@"CANCEL" font:_customFont style:JTAlertViewStyleCancel forControlEvents:UIControlEventTouchUpInside action:^(JTAlertView *alertView) {
                    NSLog(@"JTAlertView: CANCEL pressed");
                    [alertView hideWithCompletion:nil animated:weakSelf.animated];
                    [weakSelf fadeExampleSettings];
                }];
            }
            break;
        default:
            break;
    }
    
    [self.alertView showInSuperview:[[UIApplication sharedApplication] keyWindow] withCompletion:nil animated:_animated];
    
    [self fadeExampleSettings];
}

#pragma mark - Example Controls, Handles etc.

- (void)fadeExampleSettings {
    [UIView animateWithDuration:0.1 animations:^{
        for (UIView *s in self.view.subviews) {
            s.alpha = s.alpha ? 0.0 : 1.0;
        }
    } completion:nil];
}

- (IBAction)segmentSwitch:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    _numberOfButtons = segmentedControl.selectedSegmentIndex;
}

- (IBAction)animatedSwitch:(id)sender {
    UISwitch *animatedSwitch = (UISwitch *)sender;
    _animated = animatedSwitch.isOn;
}

- (IBAction)destructiveSwitch:(id)sender {
    UISwitch *destructiveSwitch = (UISwitch *)sender;
    _destructive = destructiveSwitch.isOn;
}

- (IBAction)popSwitch:(id)sender {
    UISwitch *popSwitch = (UISwitch *)sender;
    _pop = popSwitch.isOn;
}

- (IBAction)parallaxSwitch:(id)sender {
    UISwitch *parallaxSwitch = (UISwitch *)sender;
    _parallax = parallaxSwitch.isOn;
}

- (IBAction)fontSwitch:(id)sender {
    UISwitch *fontSwitch = (UISwitch *)sender;
    if (fontSwitch.isOn) {
        _customFont = [UIFont fontWithName:@"Menlo" size:21.0];
    } else {
        _customFont = nil;
    }
}

- (IBAction)bgSwitch:(id)sender {
    UISwitch *bgSwitch = (UISwitch *)sender;
    _bg = bgSwitch.isOn;
}

@end
