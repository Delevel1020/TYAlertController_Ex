//
//  TYAlertController+BlurEffects.m
//  TYAlertControllerDemo
//
//  Created by tanyang on 15/10/26.
//  Copyright © 2015年 tanyang. All rights reserved.
//

#import "TYAlertController+BlurEffects.h"
#import "UIImage+TYAlert.h"

@implementation TYAlertController (BlurEffects)

#pragma mark - public

- (void)setBlurEffectWithView:(UIView *)view
{
    [self setBlurEffectWithView:view style:BlurEffectStyleLight];
}

- (void)setBlurEffectWithView:(UIView *)view style:(BlurEffectStyle)blurStyle
{
    // time consuming task ,so use dispatch_async .很耗时的操作
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 处理耗时操作的代码块...
        UIImage *snapshotImage = [UIImage ty_snapshotImageWithView:view];
        UIImage * blurImage = [self blurImageWithSnapshotImage:snapshotImage style:blurStyle];
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImageView *blurImageView = [[UIImageView alloc]initWithImage:blurImage];
            self.backgroundView = blurImageView;
        });
        
    });
}

- (void)setBlurEffectWithView:(UIView *)view effectTintColor:(UIColor *)effectTintColor
{
    // time consuming task ,so use dispatch_async .很耗时的操作
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 处理耗时操作的代码块...
        UIImage *snapshotImage = [UIImage ty_snapshotImageWithView:view];
        UIImage * blurImage = [snapshotImage ty_applyTintEffectWithColor:effectTintColor];
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImageView *blurImageView = [[UIImageView alloc]initWithImage:blurImage];
            self.backgroundView = blurImageView;
        });
        
    });
}

#pragma mark - private

- (UIImage *)blurImageWithSnapshotImage:(UIImage *)snapshotImage style:(BlurEffectStyle)blurStyle
{
    switch (blurStyle) {
        case BlurEffectStyleLight:
            return [snapshotImage ty_applyLightEffect];
        case BlurEffectStyleDarkEffect:
            return [snapshotImage ty_applyDarkEffect];
        case BlurEffectStyleExtraLight:
            return [snapshotImage ty_applyExtraLightEffect];
        default:
            return nil;
    }
}

@end
