//
//  TYAlertView.m
//  ZYCommon
//
//  Created by Ding on 2021/7/27.
//  Copyright © 2021 丁丁. All rights reserved.
//

#import "TYAlertView.h"
#import "TYAlertController.h"
#import "UIView+TYAutoLayout.h"
#import "OpenIMMacro.h"

#pragma mark - TYAlertAction
@interface TYAlertAction ()
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) TYAlertActionStyle style;
@property (nonatomic, copy) void (^ handler)(TYAlertAction *);
@end

@implementation TYAlertAction

+ (instancetype)actionWithTitle:(NSString *)title
                          style:(TYAlertActionStyle)style
                        handler:(void (^)(TYAlertAction *))handler {
    return [[self alloc]initWithTitle:title style:style handler:handler];
}

- (instancetype)initWithTitle:(NSString *)title
                        style:(TYAlertActionStyle)style
                      handler:(void (^)(TYAlertAction *))handler {
    if (self = [super init]) {
        _title = title;
        _style = style;
        _handler = handler;
        _enabled = YES;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    TYAlertAction *action = [[self class]allocWithZone:zone];
    action.title = self.title;
    action.style = self.style;
    return action;
}

@end

#define kButtonTagOffset 1000

#pragma mark - TYAlertView
@interface TYAlertView ()
// text content View
@property (nonatomic, weak) UILabel *titleLable;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UILabel *messageLabel;

// button content View
@property (nonatomic, weak) UIView *buttonContentView;
@property (nonatomic, weak) UIView *buttonContentHorLineView;//横线
@property (nonatomic, weak) UIView *buttonContentVerLineView;//竖线
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) NSMutableArray *actions;

@property (nonatomic, assign) BOOL messageScrollEnable;
@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, copy) NSString *messageStr;
@property (nonatomic, assign) BOOL isTitleBlank;
@property (nonatomic, assign) BOOL isMessageBlank;

@end

@implementation TYAlertView

#pragma mark - init
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message enableScroll:(BOOL)enableScroll {
    if (self = [self initWithFrame:CGRectZero]) {
        
        _titleStr = title;
        _messageStr = message;
        _messageScrollEnable = enableScroll;
        
        //如果两个都为空则不需要滚动
        _isTitleBlank = (title==nil || title.length==0 || [[title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0);
        _isMessageBlank = (message==nil || message.length==0 || [[message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0);
        if (_isTitleBlank && _isMessageBlank) {
            _messageScrollEnable = NO;
        }
        
        [self configureProperty];

        [self addContentViews];
    }
    return self;
}

+ (instancetype)alertViewWithTitle:(NSString *)title message:(NSString *)message enableScroll:(BOOL)enableScroll {
    return [[self alloc]initWithTitle:title message:message enableScroll:enableScroll];
}

- (void)configureProperty {
    _clickedAutoHide = YES;
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 5;
    self.clipsToBounds = YES;
    // 弹窗宽度  默认 ScreenWidth * 0.75
    _alertViewWidth = UIScreen.mainScreen.bounds.size.width * 0.75;
    // 标题顶部间隙 默认 20pt
    _titleLableTopSpace = 20;
    // 标题左右间隙 默认 20pt
    _titleLableEdgeSpace = 20;
    // 消息顶部间隙 默认 16pt
    _messageLableTopSpace = 16;
    // 消息左右间隙 默认 16pt
    _messageLableEdgeSpace = 16;
    // 按钮content顶部高度 默认 24pt
    _buttonContentTopSpace = 24;
    // 按钮content底部高度 默认 0pt
    _buttonContentBottomSpace = 0;
    // 按钮content左右间隙 默认 0pt
    _buttonContentEdgeSpace = 0;
    // 按钮之间的间隙 默认 0
    _buttonMargin = 0;
    // 按钮高度 默认 50pt
    _buttonHeight = 50;
    // 按钮圆角 默认 0pt
    _buttonCornerRadius = 0;
    // 默认275
    _messageScrollHeight = 275;
    // 按钮字体 17pt
    _buttonDefaultFont = OpenIMFONTLight(17);
    _buttonCancelFont = OpenIMFONTLight(17);
    _buttonOKFont = OpenIMFONTMedium(17);

    // 按钮背景颜色
    _buttonDefaultBgColor = UIColor.whiteColor;
    _buttonCancelBgColor = UIColor.whiteColor;
    _buttonOKBgColor = OpenIMRGBH(0xE63629);
    // 按钮按下背景颜色
    _buttonDefaultHightBgColor = OpenIMRGBH(0xEEEEEE);
    _buttonCancelHightBgColor = OpenIMRGBH(0xEEEEEE);
    _buttonOKHightBgColor = OpenIMRGBH(0xE63629);
    // 按钮字体颜色
    _buttonDefaultTitleColor = OpenIMRGBH(0xE63629);
    _buttonCancelTitleColor = OpenIMRGBH(0x999999);
    _buttonOKTitleColor = UIColor.whiteColor;

    _buttons = [NSMutableArray array];
    _actions = [NSMutableArray array];
}

- (UIImage *)buttonBgColorWithStyle:(TYAlertActionStyle)style {
    UIColor *color;
    if (style == TYAlertActionStyleCancel) {
        color = _buttonCancelBgColor;
    } else if (style == TYAlertActionStyleOK) {
        color = _buttonOKBgColor;
    } else {
        color = _buttonDefaultBgColor;
    }
    CGSize imageSize = CGSizeMake(1, 1);
    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
    [color set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (UIImage *)buttonHightBgColorWithStyle:(TYAlertActionStyle)style {
    UIColor *color;
    if (style == TYAlertActionStyleCancel) {
        color = _buttonCancelHightBgColor;
    } else if (style == TYAlertActionStyleOK) {
        color = _buttonOKHightBgColor;
    } else {
        color = _buttonDefaultHightBgColor;
    }
    CGSize imageSize = CGSizeMake(1, 1);
    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
    [color set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (UIColor *)buttonTitleColorWithStyle:(TYAlertActionStyle)style {
    switch (style) {
        case TYAlertActionStyleDefault:
            return _buttonDefaultTitleColor;
        case TYAlertActionStyleCancel:
            return _buttonCancelTitleColor;
        case TYAlertActionStyleOK:
            return _buttonOKTitleColor;
        default:
            return nil;
    }
}

- (UIFont *)buttonTitleFontWithStyle:(TYAlertActionStyle)style {
    switch (style) {
        case TYAlertActionStyleDefault:
            return _buttonDefaultFont;
        case TYAlertActionStyleCancel:
            return _buttonCancelFont;
        case TYAlertActionStyleOK:
            return _buttonOKFont;
        default:
            return nil;
    }
}

#pragma mark - add contentview

- (void)addContentViews {
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = _titleStr;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = OpenIMFONTMedium(17);
    titleLabel.textColor = OpenIMRGBH(0x333333);
    [self addSubview:titleLabel];
    _titleLable = titleLabel;
    
    if (_messageScrollEnable) {
        UIScrollView *scrollView = [[UIScrollView alloc]init];
        scrollView.alwaysBounceVertical = YES;
        [self addSubview:scrollView];
        _scrollView = scrollView;
    }
    
    UILabel *messageLabel = [[UILabel alloc]init];
    messageLabel.text = _messageStr;
    messageLabel.numberOfLines = 0;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.font = OpenIMFONTLight(15);
    messageLabel.textColor = OpenIMRGBH(0x333333);
    _messageLabel = messageLabel;
    if (_messageScrollEnable) {
        [_scrollView addSubview:messageLabel];
    } else {
        [self addSubview:messageLabel];
    }

    UIView *buttonContentView = [[UIView alloc]init];
    buttonContentView.userInteractionEnabled = YES;
    [self addSubview:buttonContentView];
    _buttonContentView = buttonContentView;

    UIView *buttonContentHorLineView = [[UIView alloc] init];
    buttonContentHorLineView.backgroundColor = OpenIMRGBH(0xF1F1F1);
    [buttonContentView addSubview:buttonContentHorLineView];
    _buttonContentHorLineView = buttonContentHorLineView;
    
    UIView *buttonContentVerLineView = [[UIView alloc] init];
    buttonContentVerLineView.backgroundColor = OpenIMRGBH(0xF1F1F1);
    [buttonContentView addSubview:buttonContentVerLineView];
    _buttonContentVerLineView = buttonContentVerLineView;
}

- (void)didMoveToSuperview
{
    if (self.superview) {
        [self layoutContentViews];
    }
}

- (void)addAction:(TYAlertAction *)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.clipsToBounds = YES;
    button.layer.cornerRadius = _buttonCornerRadius;
    button.titleLabel.font = [self buttonTitleFontWithStyle:action.style];
    [button setTitle:action.title forState:UIControlStateNormal];
    [button setTitleColor:[self buttonTitleColorWithStyle:action.style] forState:UIControlStateNormal];
    [button setBackgroundImage:[self buttonBgColorWithStyle:action.style] forState:UIControlStateNormal];
    [button setBackgroundImage:[self buttonHightBgColorWithStyle:action.style] forState:UIControlStateHighlighted];
    button.enabled = action.enabled;
    button.tag = kButtonTagOffset + _buttons.count;
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [button addTarget:self action:@selector(actionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

    [_buttonContentView addSubview:button];
    [_buttons addObject:button];
    [_actions addObject:action];

    if (_buttons.count == 1) {
        [self layoutContentViews];
    }

    [self layoutButtons];
}

#pragma mark - layout contenview

- (void)layoutContentViews {

    if (!_titleLable.translatesAutoresizingMaskIntoConstraints && !_messageLabel.translatesAutoresizingMaskIntoConstraints && !_buttonContentView.translatesAutoresizingMaskIntoConstraints &&
        !_scrollView.translatesAutoresizingMaskIntoConstraints &&
        !_buttonContentVerLineView.translatesAutoresizingMaskIntoConstraints &&
        !_buttonContentHorLineView.translatesAutoresizingMaskIntoConstraints) {
        // layout done
        return;
    }

    // width
    if (_alertViewWidth) {
        [self addConstraintWidth:_alertViewWidth height:0];
    }

    // title
    _titleLable.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraintWithView:_titleLable topView:self leftView:self bottomView:nil rightView:self edgeInset:UIEdgeInsetsMake((_isTitleBlank && _isMessageBlank)?:_titleLableTopSpace, _titleLableEdgeSpace, 0, -_titleLableEdgeSpace)];
    
    // message
    _messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _messageLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:_isTitleBlank?15:14];
    if (_messageScrollEnable) {
        _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
        [_scrollView addConstraintWidth:(_alertViewWidth-_messageLableEdgeSpace*2) height:_messageScrollHeight];
        
        [self addConstraintWithTopView:_titleLable toBottomView:_scrollView constant:(_isTitleBlank || _isMessageBlank)?:_messageLableTopSpace];
        [self addConstraintWithView:_scrollView topView:_messageLabel leftView:self bottomView:_messageLabel rightView:self edgeInset:UIEdgeInsetsMake(0, _messageLableEdgeSpace, 10, -_messageLableEdgeSpace)];
        
        [self addConstraintWithView:_messageLabel topView:nil leftView:self bottomView:nil rightView:self edgeInset:UIEdgeInsetsMake(0, _messageLableEdgeSpace, 0, -_messageLableEdgeSpace)];
    } else {
        [self addConstraintWithTopView:_titleLable toBottomView:_messageLabel constant:(_isTitleBlank || _isMessageBlank)?:_messageLableTopSpace];
        [self addConstraintWithView:_messageLabel topView:nil leftView:self bottomView:nil rightView:self edgeInset:UIEdgeInsetsMake(0, _messageLableEdgeSpace, 0, -_messageLableEdgeSpace)];
    }
    
    // buttonContentView
    _buttonContentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraintWithTopView:_messageScrollEnable?_scrollView:_messageLabel toBottomView:_buttonContentView constant:(_isTitleBlank && _isMessageBlank)?:_buttonContentTopSpace];
    [self addConstraintWithView:_buttonContentView topView:nil leftView:self bottomView:self rightView:self edgeInset:UIEdgeInsetsMake(0, _buttonContentEdgeSpace, -_buttonContentBottomSpace, -_buttonContentEdgeSpace)];
    
    //buttonContentVerLineView
    _buttonContentHorLineView.translatesAutoresizingMaskIntoConstraints = NO;
    [_buttonContentHorLineView addConstraintWidth:0 height:0.5];
    [_buttonContentView addConstraintWithView:_buttonContentHorLineView topView:_buttonContentView leftView:_buttonContentView bottomView:nil rightView:_buttonContentView edgeInset:UIEdgeInsetsZero];
    
    
    //buttonContentVerLineView
    _buttonContentVerLineView.translatesAutoresizingMaskIntoConstraints = NO;
    [_buttonContentVerLineView addConstraintWidth:0.5 height:0];
    [_buttonContentView addConstraintCenterXToView:_buttonContentVerLineView centerYToView:nil];
    [_buttonContentView addConstraintWithView:_buttonContentVerLineView topView:_buttonContentView leftView:nil bottomView:_buttonContentView rightView:nil edgeInset:UIEdgeInsetsZero];
}

- (void)layoutButtons {
    UIButton *button = _buttons.lastObject;
    TYAlertAction *action = _actions[button.tag - kButtonTagOffset];
    if (_buttons.count == 1) {
        _buttonContentVerLineView.hidden = YES;
        if (action.style == TYAlertActionStyleOK) {
            _buttonContentHorLineView.hidden = YES;
        } else {
            _buttonContentHorLineView.hidden = NO;
        }
        [_buttonContentView addConstraintToView:button edgeInset:UIEdgeInsetsZero];
        [button addConstraintWidth:0 height:_buttonHeight];
    } else if (_buttons.count == 2) {
        _buttonContentHorLineView.hidden = NO;
        _buttonContentVerLineView.hidden = NO;
        UIButton *firstButton = _buttons.firstObject;
        [_buttonContentView removeConstraintWithView:firstButton attribute:NSLayoutAttributeRight];
        [_buttonContentView addConstraintWithView:button topView:_buttonContentView leftView:nil bottomView:nil rightView:_buttonContentView edgeInset:UIEdgeInsetsZero];
        [_buttonContentView addConstraintWithLeftView:firstButton toRightView:button constant:_buttonMargin];
        [_buttonContentView addConstraintEqualWithView:button widthToView:firstButton heightToView:firstButton];
    } else {
        _buttonContentHorLineView.hidden = YES;
        _buttonContentVerLineView.hidden = YES;
        if (_buttons.count == 3) {
            UIButton *firstBtn = _buttons[0];
            UIButton *secondBtn = _buttons[1];
            [_buttonContentView removeConstraintWithView:firstBtn attribute:NSLayoutAttributeRight];
            [_buttonContentView removeConstraintWithView:firstBtn attribute:NSLayoutAttributeBottom];
            [_buttonContentView removeConstraintWithView:secondBtn attribute:NSLayoutAttributeTop];
            [_buttonContentView addConstraintWithView:firstBtn topView:nil leftView:nil bottomView:nil rightView:_buttonContentView edgeInset:UIEdgeInsetsZero];
            [_buttonContentView addConstraintWithTopView:firstBtn toBottomView:secondBtn constant:_buttonMargin];
        }

        UIButton *lastSecondBtn = _buttons[_buttons.count - 2];
        [_buttonContentView removeConstraintWithView:lastSecondBtn attribute:NSLayoutAttributeBottom];
        [_buttonContentView addConstraintWithTopView:lastSecondBtn toBottomView:button constant:_buttonMargin];
        [_buttonContentView addConstraintWithView:button topView:nil leftView:_buttonContentView bottomView:_buttonContentView rightView:_buttonContentView edgeInset:UIEdgeInsetsZero];
        [_buttonContentView addConstraintEqualWithView:button widthToView:nil heightToView:lastSecondBtn];
    }
    [_buttonContentView bringSubviewToFront:_buttonContentHorLineView];
    [_buttonContentView bringSubviewToFront:_buttonContentVerLineView];
}

#pragma mark - action
- (void)actionButtonClicked:(UIButton *)button {
    TYAlertAction *action = _actions[button.tag - kButtonTagOffset];

    if (_clickedAutoHide) {
        UIViewController *viewController = self.viewController;
        if (viewController && [viewController isKindOfClass:[TYAlertController class]]) {
            [(TYAlertController *)self.viewController dismissViewControllerAnimated:YES];
        } else {
            NSLog(@"self.viewController is nil, or isn't TYAlertController,or self.superview is nil, or isn't TYShowAlertView");
        }
    }

    if (action.handler) {
        action.handler(action);
    }
}

- (UIViewController *)viewController {
    for (UIView *next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

@end
