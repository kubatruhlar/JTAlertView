//
//  ViewController.h
//  JTAlertView Example
//
//  Created by Jakub Truhlar on 13.06.15.
//  Copyright (c) 2015 Jakub Truhlar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UISwitch *destructiveSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *animatedSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *popSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *parallaxSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *fontSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *bgSwitch;

- (IBAction)showPressed:(id)sender;

- (IBAction)segmentSwitch:(id)sender;

- (IBAction)animatedSwitch:(id)sender;
- (IBAction)destructiveSwitch:(id)sender;
- (IBAction)popSwitch:(id)sender;
- (IBAction)parallaxSwitch:(id)sender;
- (IBAction)fontSwitch:(id)sender;
- (IBAction)bgSwitch:(id)sender;

@end

