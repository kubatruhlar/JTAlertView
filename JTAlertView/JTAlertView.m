//
//  JTAlertView.m
//
//  Created by Jakub Truhlar on 07.06.15.
//  Copyright (c) 2015 Jakub Truhlar. All rights reserved.
//

#import "JTAlertView.h"

const static CGFloat kAlertWidth = 240.0;
const static CGFloat kAlertHeight = 290.0;
const static CGFloat kButtonHeight = 50.0;
const static CGFloat kCornerRadius = 5.0;
const static CGFloat kTitlePadding = 16.0;

const static CGFloat kParallaxEffectDivergence = 10.0;
const static CGFloat kAnimatingDuration = 0.2;

const static CGFloat kShadowOffsetValue = 0.5;
const static CGFloat kBtnHighlightValue = 0.9;
const static CGFloat kSeparatorColorValue = 0.97;
const static CGFloat kBtnFontSize = 19.0;
const static CGFloat kTitleFontSize = 21.0;

@interface JTAlertView()

@property (nonatomic, strong) NSString *alertTitle;
@property (nonatomic, strong) UIImage *alertImage;
@property (nonatomic, strong) NSMutableArray *btns;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITapGestureRecognizer *gestureRecognizer;
@property (nonatomic, strong) UIView *backgroundView;

@end

@implementation JTAlertView

#pragma mark - Initializers
- (instancetype)init {
    return [self initWithTitle:nil andImage:nil];
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithTitle:nil andImage:nil];
}

- (instancetype)initWithTitle:(NSString *)titleText andImage:(UIImage *)image {
    _size = CGSizeMake(kAlertWidth, kAlertHeight);
    self = [super initWithFrame:[self alertFrameWithinScreen]];
    
    // Default setup of public properties
    [self defaultSetup];
    
    // Start with hidden view
    [self noAlpha];
    
    self.alertTitle = titleText;
    self.alertImage = image;
    
    // Inits
    self.btns = [NSMutableArray new];
    
    // Notifications
    [self createObservers];
    
    // Background
    [self createBackgroundView];
    
    return self;
}

+ (instancetype)alertWithTitle:(NSString *)titleText andImage:(UIImage *)image {
    return [(JTAlertView *)[self alloc] initWithTitle:titleText andImage:image];
}

#pragma mark - Buttons handle
- (void)addButtonWithTitle:(NSString *)titleText action:(void (^)(JTAlertView *alertView))action {
    
    [self addButtonWithTitle:titleText style:JTAlertViewStyleDefault action:action];
}

- (void)addButtonWithTitle:(NSString *)titleText style:(JTAlertViewStyle)style action:(void (^)(JTAlertView *alertView))action {
    
    [self addButtonWithTitle:titleText style:style forControlEvents:UIControlEventTouchUpInside action:action];
}

- (void)addButtonWithTitle:(NSString *)titleText style:(JTAlertViewStyle)style forControlEvents:(UIControlEvents)controlEvents action:(void (^)(JTAlertView *alertView))action {
    [self addButtonWithTitle:titleText font:nil style:style forControlEvents:controlEvents action:action];
}

- (void)addButtonWithTitle:(NSString *)titleText font:(UIFont *)font style:(JTAlertViewStyle)style forControlEvents:(UIControlEvents)controlEvents action:(void (^)(JTAlertView *alertView))action {
    
    UIBlockButton *btn = [UIBlockButton buttonWithType:UIButtonTypeSystem];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor whiteColor]];
    [btn setTitle:titleText forState:UIControlStateNormal];
    [btn handleControlEvent:controlEvents withBlock:action];
    
    if (!font) {
        switch (style) {
            case JTAlertViewStyleDefault:
                btn.titleLabel.font = [_font fontWithSize:kBtnFontSize];
                break;
            case JTAlertViewStyleCancel:
                btn.titleLabel.font = [self boldForFont:_font withSize:kBtnFontSize] ? [self boldForFont:_font withSize:kBtnFontSize] : [_font fontWithSize:kBtnFontSize];
                break;
            case JTAlertViewStyleDestructive:
                btn.titleLabel.font = [self boldForFont:_font withSize:kBtnFontSize] ? [self boldForFont:_font withSize:kBtnFontSize] : [_font fontWithSize:kBtnFontSize];
                [btn setTitleColor:[UIColor colorWithRed:0.906 green:0.298 blue:0.235 alpha:1] forState:UIControlStateNormal];
                break;
            default:
                break;
        }
    } else {
        switch (style) {
            case JTAlertViewStyleDefault:
                btn.titleLabel.font = font;
                break;
            case JTAlertViewStyleCancel:
                btn.titleLabel.font = [self boldForFont:font withSize:font.pointSize] ? [self boldForFont:font withSize:font.pointSize] : font;
                break;
            case JTAlertViewStyleDestructive:
                btn.titleLabel.font = [self boldForFont:font withSize:font.pointSize] ? [self boldForFont:font withSize:font.pointSize] : font;
                [btn setTitleColor:[UIColor colorWithRed:0.906 green:0.298 blue:0.235 alpha:1] forState:UIControlStateNormal];
                break;
            default:
                break;
        }
    }
    
    [self.btns addObject:btn];
    
    [self layoutBtns];
}

- (void)layoutBtns {
    for (int i = 0; i < self.btns.count; i++) {
        // Remove all buttons
        UIButton *b = [self.btns objectAtIndex:i];
        [b removeFromSuperview];
        
        // Remove all separators
        [[self viewWithTag:1] removeFromSuperview];
        [[self viewWithTag:2] removeFromSuperview];
    }
    
    // Setup frame
    CGFloat btnWidth = self.frame.size.width / self.btns.count;
    for (int i = 0; i < self.btns.count; i++) {
        UIButton *b = [self.btns objectAtIndex:i];
        b.frame = CGRectMake(btnWidth * i, _size.height - kButtonHeight, btnWidth, kButtonHeight);
        [b setBackgroundImage:[self jt_imageWithColor:[UIColor colorWithWhite:kBtnHighlightValue alpha:1.0] size:b.frame.size] forState:UIControlStateHighlighted];
        [self insertSubview:b atIndex:1];
        
        if (i < self.btns.count - 1) {
            // Add a vertical separator
            [self addSeparatorInView:self withTag:1 andFrame:CGRectMake(b.frame.size.width * (i + 1), b.frame.origin.y, 1.0, b.frame.size.height)];
        } else if (i == self.btns.count - 1) {
            // In the last loop - add a horizontal separator
            [self addSeparatorInView:self withTag:2 andFrame:CGRectMake(0, b.frame.origin.y, self.frame.size.width, 1.0)];
        }
    }
}

- (void)addSeparatorInView:(UIView *)superview withTag:(NSInteger)tag andFrame:(CGRect)frame {
    UIView *separator = [[UIView alloc] initWithFrame:frame];
    separator.backgroundColor = [UIColor colorWithWhite:kSeparatorColorValue alpha:1.0];
    separator.tag = tag;
    [superview insertSubview:separator atIndex:2];
}

#pragma mark - Appearance
- (void)applyAppearanceConsideringButtons:(bool)consideringBtns {
    // Self
    self.layer.cornerRadius = kCornerRadius;
    self.layer.masksToBounds = true;
    self.layer.backgroundColor = [UIColor whiteColor].CGColor;
    
    // ImageView
    CGFloat imgHeight;
    imgHeight = consideringBtns ? self.frame.size.height - kButtonHeight : self.frame.size.height;
    // Parallax effect
    CGFloat parallaxDivergence;
    if (_parallaxEffect) {
        //[self applyMotionEffects:self];
        parallaxDivergence = kParallaxEffectDivergence;
    } else {
        parallaxDivergence = 0;
    }
    _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(-parallaxDivergence, -parallaxDivergence, self.frame.size.width + parallaxDivergence * 2, imgHeight + parallaxDivergence * 2)];
    _imgView.contentMode = UIViewContentModeScaleAspectFill;
    _imgView.userInteractionEnabled = true;
    if (_parallaxEffect) {
        [self applyMotionEffects:_imgView];
    }
    _imgView.image = _alertImage;
    // Create overlay
    UIView *overlay = [[UIView alloc] initWithFrame:_imgView.bounds];
    overlay.userInteractionEnabled = true;
    overlay.backgroundColor = _overlayColor;
    [_imgView addSubview:overlay];
    [self insertSubview:_imgView atIndex:0];
    
    // Label
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kTitlePadding, kTitlePadding, self.frame.size.width - kTitlePadding * 2, imgHeight - kTitlePadding * 2)];
    _titleLabel.numberOfLines = 0;
    _titleLabel.font = _font;
    _titleLabel.textColor = _titleColor;
    _titleLabel.text = _alertTitle;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    if (_titleShadow) {
        _titleLabel.layer.shadowOpacity = 1.0;
        _titleLabel.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.5].CGColor;
        _titleLabel.layer.shadowOffset = CGSizeMake(kShadowOffsetValue, kShadowOffsetValue);
        _titleLabel.layer.shadowRadius = 1.5;
    }
    [self insertSubview:_titleLabel atIndex:3];
    
    // Pop animation for touch
    if (_popAnimation) {
        [self removeGestureRecognizer:_gestureRecognizer];
        _gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pop)];
        [_imgView addGestureRecognizer:_gestureRecognizer];
    }
}

- (void)createBackgroundView {
    self.backgroundView = [[UIView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    self.backgroundView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.5];
    self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.backgroundView.alpha = 0.0;
}

- (void)addBackgroundBelowAlertView {
    [self.backgroundView removeFromSuperview];
    [[UIApplication sharedApplication].keyWindow insertSubview:self.backgroundView belowSubview:self];
}

#pragma mark - Displaying
- (void)show {
    [self showInSuperview:[[UIApplication sharedApplication] keyWindow] withCompletion:nil animated:true];
}

- (void)showInSuperview:(UIView *)superView withCompletion:(void (^)())completion animated:(bool)animated {
    
    if (self.btns.count == 0) {
        [self applyAppearanceConsideringButtons:false];
    } else {
        [self applyAppearanceConsideringButtons:true];
    }
    
    [self noAlpha];
    
    CGFloat animationDuration = 0.0;
    animationDuration = animated ? kAnimatingDuration : 0;
    
    // Blocking views underneath
    for (id s in superView.subviews) {
        if ([s isMemberOfClass:[JTAlertView class]]) {
            [s setUserInteractionEnabled:true];
        } else {
            [s setUserInteractionEnabled:false];
        }
    }
    [superView addSubview:self];
    
    // Add gradient
    _backgroundShadow ? [self addBackgroundBelowAlertView] : nil;
    
    // Animation
    [UIView animateWithDuration:animationDuration animations:^{
        [self fullAlpha];
        self.backgroundView.alpha = 1.0;
        _popAnimation ? [self popAnimationForView:self withDuration:animationDuration] : nil;
        
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}

- (void)hide {
    [self hideWithCompletion:nil animated:true];
}

- (void)hideWithAnimation:(NSNumber *)animated {
    bool animation = [animated boolValue];
    [self hideWithCompletion:nil animated:animation];
}

- (void)hideWithDelay:(NSTimeInterval)delay animated:(bool)animated {
    NSNumber *boolNumber = [NSNumber numberWithBool:animated];
    [self performSelector:@selector(hideWithAnimation:) withObject:boolNumber afterDelay:delay];
}

- (void)hideWithCompletion:(void (^)())completion animated:(bool)animated {
    CGFloat animationDuration = 0.0;
    animationDuration = animated ? kAnimatingDuration : 0;
    [UIView animateWithDuration:animationDuration animations:^{
        [self noAlpha];
        self.backgroundView.alpha = 0.0;
        [UIView animateWithDuration:animationDuration delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.transform = CGAffineTransformMakeScale(0.95, 0.95);
        } completion:nil];
        
    } completion:^(BOOL finished) {
        for (id s in self.superview.subviews) {
            [s setUserInteractionEnabled:true];
        }
        self.transform = CGAffineTransformMakeScale(1.0, 1.0);
        [self removeFromSuperview];
        [_imgView removeFromSuperview];
        [_titleLabel removeFromSuperview];
        [self.backgroundView removeFromSuperview];
        if (completion) {
            completion();
        }
    }];
}

#pragma mark - Frame handle
- (CGFloat)screenCenterX {
    return [UIScreen mainScreen].bounds.size.width / 2;
}

- (CGFloat)screenCenterY {
    return [UIScreen mainScreen].bounds.size.height / 2;
}

- (CGRect)alertFrameWithinScreen {
    return CGRectMake([self screenCenterX] - (_size.width / 2), [self screenCenterY] - (_size.height / 2), _size.width, _size.height);
}

- (void)createObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeFrame) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)changeFrame {
    self.frame = [self alertFrameWithinScreen];
}

- (void)setSize:(CGSize)size {
    _size = size;
    [self changeFrame];
}

#pragma mark - Others
- (void)defaultSetup {
    _popAnimation = true;
    _parallaxEffect = true;
    _overlayColor = [UIColor colorWithWhite:0.15 alpha:0.75];
    _font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:kTitleFontSize];
    _titleColor = [UIColor whiteColor];
    _titleShadow = true;
    _backgroundShadow = false;
}

- (void)noAlpha {
    self.alpha = 0.0;
}

- (void)fullAlpha {
    self.alpha = 1.0;
}

- (void)applyMotionEffects:(UIView *)view {
    if (NSClassFromString(@"UIInterpolatingMotionEffect")) {
        UIInterpolatingMotionEffect *horizontalEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        horizontalEffect.minimumRelativeValue = @(-kParallaxEffectDivergence);
        horizontalEffect.maximumRelativeValue = @(kParallaxEffectDivergence);
        UIInterpolatingMotionEffect *verticalEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
        verticalEffect.minimumRelativeValue = @(-kParallaxEffectDivergence);
        verticalEffect.maximumRelativeValue = @(kParallaxEffectDivergence);
        UIMotionEffectGroup *motionEffectGroup = [[UIMotionEffectGroup alloc] init];
        motionEffectGroup.motionEffects = @[horizontalEffect, verticalEffect];
        [view addMotionEffect:motionEffectGroup];
    }
}

- (void)popAnimationForView:(UIView *)view withDuration:(CGFloat)duration {
    [UIView animateWithDuration:duration * 0.5 animations:^{
        view.transform = CGAffineTransformMakeScale(1.05, 1.05);
    }];
    [UIView animateWithDuration:duration * 0.35 delay:duration * 0.5 options:UIViewAnimationOptionCurveLinear animations:^{
        view.transform = CGAffineTransformMakeScale(0.98, 0.98);
    } completion:nil];
    [UIView animateWithDuration:duration * 0.15 delay:duration * 0.85 options:UIViewAnimationOptionCurveLinear animations:^{
        view.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:nil];
}

- (void)pop {
    [UIView animateWithDuration:kAnimatingDuration animations:^{
        [self popAnimationForView:self withDuration:kAnimatingDuration];
    } completion:nil];
}

- (UIImage *)jt_imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *createdImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return createdImage;
}

- (UIFont *)boldForFont:(UIFont *)font withSize:(CGFloat)size {
    NSArray *fontParts = [font.fontName componentsSeparatedByString:@"-"];
    NSString *fontBase = [fontParts firstObject];
    UIFont *newFont = [UIFont fontWithName:[NSString stringWithFormat:@"%@-Bold", fontBase] size:size];
    return newFont;
}

@end

#pragma mark - UIBlockButton
@implementation UIBlockButton

- (void)handleControlEvent:(UIControlEvents)event withBlock:(ActionBlock)action {
    _actionBlock = action;
    [self addTarget:self action:@selector(callActionBlock) forControlEvents:event];
}

- (void)callActionBlock {
    _actionBlock((JTAlertView *)self.superview);
}

@end