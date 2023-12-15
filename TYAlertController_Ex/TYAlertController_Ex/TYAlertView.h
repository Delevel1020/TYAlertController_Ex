//
//  TYAlertView.h
//  ZYCommon
//
//  Created by Ding on 2021/7/27.
//  Copyright © 2021 丁丁. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TYAlertActionStyle) {
    TYAlertActionStyleDefault,//白底 FFFFFF  黄色字体 F3633E  高亮底色 EEEEEE  字体大小 17
    TYAlertActionStyleCancel,//白底 FFFFFF  灰色字体 999999  高亮底色 EEEEEE 字体大小 17
    TYAlertActionStyleOK,//黄底 F3633E 白色字体 FFFFFF 高亮底色 F3633E 0.9 字体大小 15
};

@interface TYAlertAction : NSObject <NSCopying>

+ (instancetype)actionWithTitle:(NSString *)title
                          style:(TYAlertActionStyle)style
                        handler:(void (^)(TYAlertAction *action))handler;

@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) TYAlertActionStyle style;
@property (nonatomic, getter=isEnabled) BOOL enabled;

@end


@interface TYAlertView : UIView
// 标题内容
@property (nonatomic, weak, readonly) UILabel *titleLable;
// 消息内容
@property (nonatomic, weak, readonly) UILabel *messageLabel;
// 弹窗宽度  默认 ScreenWidth * 0.75
@property (nonatomic, assign) CGFloat alertViewWidth;
// 标题顶部间隙 默认 20pt
@property (nonatomic, assign) CGFloat titleLableTopSpace;
// 标题左右间隙 默认 20pt
@property (nonatomic, assign) CGFloat titleLableEdgeSpace;
// 消息顶部间隙 默认 16pt 如果titleLable没有文字则为0
@property (nonatomic, assign) CGFloat messageLableTopSpace;
// 消息左右间隙 默认 16pt
@property (nonatomic, assign) CGFloat messageLableEdgeSpace;
// 如果只有两个按钮的时候，是水平还是竖直方向 默认 水平方向 YES
@property (nonatomic, assign) BOOL buttonHorizontal;
// 按钮content顶部高度 默认 24pt
@property (nonatomic, assign) CGFloat buttonContentTopSpace;
// 按钮content底部高度 默认 0pt
@property (nonatomic, assign) CGFloat buttonContentBottomSpace;
// 按钮content左右间隙 默认 0pt
@property (nonatomic, assign) CGFloat buttonContentEdgeSpace;
// 按钮之间的间隙 默认 0
@property (nonatomic, assign) CGFloat buttonMargin;
// 按钮高度 默认 50pt
@property (nonatomic, assign) CGFloat buttonHeight;
// 按钮圆角 默认 0pt
@property (nonatomic, assign) CGFloat buttonCornerRadius;
// 按钮字体
@property (nonatomic, strong) UIFont  *buttonDefaultFont;
@property (nonatomic, strong) UIFont  *buttonCancelFont;
@property (nonatomic, strong) UIFont  *buttonOKFont;
// 按钮背景颜色
@property (nonatomic, strong) UIColor *buttonDefaultBgColor;
@property (nonatomic, strong) UIColor *buttonCancelBgColor;
@property (nonatomic, strong) UIColor *buttonOKBgColor;
// 按钮按下背景颜色
@property (nonatomic, strong) UIColor *buttonDefaultHightBgColor;
@property (nonatomic, strong) UIColor *buttonCancelHightBgColor;
@property (nonatomic, strong) UIColor *buttonOKHightBgColor;
// 按钮字体颜色
@property (nonatomic, strong) UIColor *buttonDefaultTitleColor;
@property (nonatomic, strong) UIColor *buttonCancelTitleColor;
@property (nonatomic, strong) UIColor *buttonOKTitleColor;

//是否可以点击隐藏 默认是点击隐藏
@property (nonatomic, assign) BOOL clickedAutoHide;
//如果是滚动的 默认高度是 275
@property (nonatomic, assign) CGFloat messageScrollHeight;

+ (instancetype)alertViewWithTitle:(NSString *)title
                           message:(NSString *)message
                      enableScroll:(BOOL)enableScroll;

- (void)addAction:(TYAlertAction *)action;

@end
