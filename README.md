# JTAlertView

**JTAlertView** is the new **wonderful dialog/HUD/alert** kind of View. It was also designed to cover user’s needs during **customization**. Created with **delightful combination** of image, parallax and pop effects, **JTAlertView** improves your user experience.

<h3 align="center">
  <img src="https://github.com/kubatru/JTAlertView/blob/master/Screens/alertView.png" alt="Example" width="600"/>
</h3>

## Installation
There are two ways to add the **JTAlertView** library to your project. Add it as a regular library or install it through **CocoaPods**.

`pod 'JTAlertView'`

You may also quick try the example project with

`pod try JTAlertView`

**Library requires target iOS 7.0 and above**

> **Works in both - Portrait and Landscape modes**

<h3 align="center">
  <img src="https://github.com/kubatru/JTAlertView/blob/master/Screens/parallax.gif" alt="Parallax" width="280"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  <img src="https://github.com/kubatru/JTAlertView/blob/master/Screens/popanimated.gif" alt="Example" width="250"/>
</h3>

## Usage and Customization

- Use `initWithTitle:andImage:` OR class method `alertWithTitle:andImage:` **to initialize**.
- Then you can use many properties like `overlayColor` **to customize** the **JTAlertView**. 
- Then **add the buttons** e.g. `addButtonWithTitle:action:`
- And finally use `show` and `hide` methods **to handle displaying**.


### Simple One-button example:
```objective-c
JTAlertView *alertView = [[JTAlertView alloc] initWithTitle:@"You are wonderful" andImage:image];
self.alertView.size = CGSizeMake(280, 230);
    
[self.alertView addButtonWithTitle:@"OK" style:JTAlertViewStyleDefault action:^(JTAlertView *alertView) {
    [alertView hide];
}];
    
[self.alertView show];
```

### Properties:

You must setup `size` property or the default will be used. `popAnimation` is visible while displaying and if you tap on the dialog. The `overlayColor` above given image and decent `titleShadow` make title better readable. The `backgroundShadow` creates decent shadow under the alertView. The `font` property (it's `style` and `size`) is applied to title and buttons (`style` only). To customize particular buttons, use `font` parameter in buttons adding methods (*see below*).

```objective-c
@property (nonatomic, assign) CGSize size;

@property (nonatomic, assign) bool popAnimation;
@property (nonatomic, assign) bool parallaxEffect;
@property (nonatomic, strong) UIColor *overlayColor;

@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, assign) bool titleShadow;
@property (nonatomic, assign) bool backgroundShadow;
```


### Adding buttons:

You can setup button's `title`, `actionBlock`, `style` (similar to `UIAlertAction` styles), `controlEvents` and `font` if needed.

```objective-c
- (void)addButtonWithTitle:action:
- (void)addButtonWithTitle:style:action:
- (void)addButtonWithTitle:style:forControlEvents:action:
- (void)addButtonWithTitle:font:style:forControlEvents:action:
```


### Displaying:

You can show **JTAlertView** `withCompletion` block, in specific `superview`, `animated` and hide it also with `delay`.

```objective-c
- (void)show
- (void)showInSuperview:withCompletion:animated:

- (void)hide
- (void)hideWithCompletion:animated:
- (void)hideWithDelay:animated:
```


## Changelog

### v1.0.2 - 06.23.15
- [**FIX**] README.md updated

### v1.0.1 - 06.18.15
- [**NEW**] BackgroundShadow added

### v1.0.0 - 06.17.15
- [**NEW**] Initial commit

## Author
This library is open-sourced by [Jakub Truhlar](http://kubatruhlar.cz).
    
## License
The MIT License (MIT)
Copyright © 2015 Jakub Truhlar
