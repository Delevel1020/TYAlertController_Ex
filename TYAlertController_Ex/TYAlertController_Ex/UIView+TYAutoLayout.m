//
//  UIView+TYAutoLayout.m
//  ZYCommon
//
//  Created by Ding on 2021/7/27.
//  Copyright © 2021 丁丁. All rights reserved.
//

#import "UIView+TYAutoLayout.h"

@implementation UIView (TYAutoLayout)

- (void)addConstraintToView:(UIView *)view edgeInset:(UIEdgeInsets)edgeInset
{
    [self addConstraintWithView:view topView:self leftView:self bottomView:self rightView:self edgeInset:edgeInset];
}

- (void)addConstraintWithView:(UIView *)view topView:(UIView *)topView leftView:(UIView *)leftView
                   bottomView:(UIView *)bottomView rightView:(UIView *)rightView edgeInset:(UIEdgeInsets)edgeInset
{
    if (topView) {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:topView attribute:NSLayoutAttributeTop multiplier:1 constant:edgeInset.top]];
    }
    
    if (leftView) {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:leftView attribute:NSLayoutAttributeLeft multiplier:1 constant:edgeInset.left]];
    }
    
    if (rightView) {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:rightView attribute:NSLayoutAttributeRight multiplier:1 constant:edgeInset.right]];
    }
    
    if (bottomView) {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:bottomView attribute:NSLayoutAttributeBottom multiplier:1 constant:edgeInset.bottom]];
    }
}

- (void)addConstraintWithLeftView:(UIView *)leftView toRightView:(UIView *)rightView constant:(CGFloat)constant
{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:leftView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:rightView attribute:NSLayoutAttributeLeft multiplier:1 constant:-constant]];
}

- (NSLayoutConstraint *)addConstraintWithTopView:(UIView *)topView toBottomView:(UIView *)bottomView constant:(CGFloat)constant
{
    NSLayoutConstraint *topBottomConstraint =[NSLayoutConstraint constraintWithItem:topView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:bottomView attribute:NSLayoutAttributeTop multiplier:1 constant:-constant];
    [self addConstraint:topBottomConstraint];
    return topBottomConstraint;
}

- (void)addConstraintWidth:(CGFloat)width height:(CGFloat)height
{
    if (width > 0) {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:width]];
    }
    
    if (height > 0) {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:height]];
    }
}

- (void)addConstraintEqualWithView:(UIView *)view widthToView:(UIView *)wView heightToView:(UIView *)hView
{
    if (wView) {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:wView attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    }
    
    if (hView) {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:hView attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    }
}

- (void)addConstraintCenterXToView:(UIView *)xView centerYToView:(UIView *)yView
{
    if (xView) {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:xView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    }
    
    if (yView) {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:yView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    }
}

- (NSLayoutConstraint *)addConstraintCenterYToView:(UIView *)yView constant:(CGFloat)constant;
{
    if (yView) {
        NSLayoutConstraint *centerYConstraint = [NSLayoutConstraint constraintWithItem:yView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:constant];
        [self addConstraint:centerYConstraint];
        return centerYConstraint;
    }
    return nil;
}

- (void)removeConstraintWithAttribte:(NSLayoutAttribute)attr
{
    for (NSLayoutConstraint *constraint in self.constraints) {
        if (constraint.firstAttribute == attr) {
            [self removeConstraint:constraint];
            break;
        }
    }
}

- (void)removeConstraintWithView:(UIView *)view attribute:(NSLayoutAttribute)attr
{
    for (NSLayoutConstraint *constraint in self.constraints) {
        if (constraint.firstAttribute == attr && constraint.firstItem == view) {
            [self removeConstraint:constraint];
            break;
        }
    }
}

- (void)removeAllConstraints
{
    [self removeConstraints:self.constraints];
}

@end
