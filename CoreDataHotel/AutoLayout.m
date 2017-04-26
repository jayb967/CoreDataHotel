//
//  AutoLayout.m
//  CoreDataHotel
//
//  Created by Rio Balderas on 4/24/17.
//  Copyright © 2017 Jay Balderas. All rights reserved.
//

#import "AutoLayout.h"

@implementation AutoLayout

+(NSArray *)fullScreenContraintsWithVFLForView:(UIView *)view{
    NSMutableArray *constraints = [[NSMutableArray alloc]init];
    //  shorthand literal for dictionary. puts in argument of fullscree...above
    NSDictionary *viewDictionary = @{@"view": view};
    //                                                                                 refer to the white pic in notes
    NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:viewDictionary];
    
    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:viewDictionary];
    
    [constraints addObjectsFromArray:horizontalConstraints];
    [constraints addObjectsFromArray:verticalConstraints];
    
    [NSLayoutConstraint activateConstraints:constraints];
    
    return constraints.copy;
}

+(NSLayoutConstraint *)genericContraintFrom:(UIView *)view
                                     toView:(UIView *)superView
                              withAttribute:(NSLayoutAttribute)attribute
                              andMultiplier:(CGFloat)multiplier{
    
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:view attribute:attribute relatedBy:NSLayoutRelationEqual toItem:superView attribute:attribute multiplier:multiplier constant:0.0];
    
    constraint.active = YES;
    
    return constraint;
}

//MARK: helper method
+(NSLayoutConstraint *)genericContraintFrom:(UIView *)view
                                     toView:(UIView *)superView
                              withAttribute:(NSLayoutAttribute)attribute{
    
    return [AutoLayout genericContraintFrom:view toView:superView withAttribute:attribute andMultiplier:1.0];
}

+(NSLayoutConstraint *)equalHeightContraintFromView:(UIView *)view
                                             toView:(UIView *)otherView
                                     withMultiplier:(CGFloat)multiplier{
    NSLayoutConstraint *heightConstraint = [AutoLayout genericContraintFrom:view toView:otherView withAttribute:NSLayoutAttributeHeight andMultiplier:multiplier];
    
    return heightConstraint;
}

+(NSLayoutConstraint *)leadingConstraintFrom:(UIView *)view
                                      toView:(UIView *)otherView{
    
    return [AutoLayout genericContraintFrom:view toView:otherView withAttribute:NSLayoutAttributeLeading];
    
}

+(NSLayoutConstraint *)trailingConstraintFrom:(UIView *)view
                                       toView:(UIView *)otherView{
    
    return [AutoLayout genericContraintFrom:view toView:otherView
                              withAttribute:NSLayoutAttributeTrailing];
}

+(NSArray *)constraintsWithVFLForViewDictionary:(NSDictionary *)viewDictionary forMetricsDictionary:(NSDictionary *)metricsDictionary withOptions:(NSLayoutFormatOptions)options withVisualFormat:(NSString *)visualFormat {
    NSArray *constraints = [[NSArray alloc]init];
    
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:visualFormat options:options metrics:metricsDictionary views:viewDictionary];
    
    [NSLayoutConstraint activateConstraints:constraints];
    
    return constraints.copy;
}

@end
