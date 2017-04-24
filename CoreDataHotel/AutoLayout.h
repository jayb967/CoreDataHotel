//
//  AutoLayout.h
//  CoreDataHotel
//
//  Created by Rio Balderas on 4/24/17.
//  Copyright © 2017 Jay Balderas. All rights reserved.
//

@import UIKit;

@interface AutoLayout : NSObject

+(NSLayoutConstraint *)genericContraintFrom:(UIView *)view
                                     toView:(UIView *)superView
                              withAttribute:(NSLayoutAttribute)attribute
                              andMultiplier:(CGFloat)multiplier;

+(NSLayoutConstraint *)genericContraintFrom:(UIView *)view
                                     toView:(UIView *)superView
                              withAttribute:(NSLayoutAttribute)attribute;

+(NSArray *)fullScreenContraintsWithVFLForView:(UIView *)view;

+(NSLayoutConstraint *)equalHeightContraintFromView:(UIView *)view
                                             toView:(UIView *)otherView
                                     withMultiplier:(CGFloat)multiplier;

+(NSLayoutConstraint *)leadingConstraintFrom:(UIView *)view
                                      toView:(UIView *)otherView;

+(NSLayoutConstraint *)trailingConstraintFrom:(UIView *)view
                                       toView:(UIView *)otherView;


@end
