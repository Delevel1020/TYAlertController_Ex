//
//  UIImage+TYAlert.h
//  BaseCustomLibrary
//
//  Created by Ding on 2022/11/3.
//

#import <UIKit/UIKit.h>

@interface UIImage (TYAlert)

/// tYAlertController的扩展类别
+ (UIImage *)ty_snapshotImageWithView:(UIView *)view;
- (UIImage *)ty_applyLightEffect;
- (UIImage *)ty_applyExtraLightEffect;
- (UIImage *)ty_applyDarkEffect;
- (UIImage *)ty_applyTintEffectWithColor:(UIColor *)tintColor;
- (UIImage *)ty_applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;

@end
