//
//  HJWAnimationCell.m
//  Fragment
//
//  Created by Lion_Lemon on 15/12/5.
//  Copyright © 2015年 Lion_Lemon. All rights reserved.
//

#import "HJWAnimationCell.h"

@implementation HJWAnimationCell

+ (void)setAnimationCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath Type:(HJWAnimationType)type {
    switch (type) {
        case HJWAnimationLeft:
        {
            [self animationOneWith:cell forRowAtIndexPath:indexPath];
        }
            break;
        case HJWAnimationRight:
        {
            //呵呵
            [self animationTwoWith:cell forRowAtIndexPath:indexPath];
        }
            break;
        case HJWAnimationHorizontal:
        {
            [self animationThreeWith:cell forRowAtIndexPath:indexPath];
        }
            break;
        default:
            break;
    }
}

+ (void)animationOneWith:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    //动画1：
    NSMutableSet *showIndexes = [NSMutableSet set];
    if (![showIndexes containsObject:indexPath]) {
        [showIndexes addObject:indexPath];
        CGFloat rotationAngleDegrees = -30;
        CGFloat rotationAngleRadians = rotationAngleDegrees * (M_PI/ 180);
        CGPoint offsetPositioning = CGPointMake(-80, -80);
        
        
        CATransform3D transform = CATransform3DIdentity;
        transform = CATransform3DRotate(transform, rotationAngleRadians, 0.0,  0.0, 1.0);
        transform = CATransform3DTranslate(transform, offsetPositioning.x, offsetPositioning.y , 0.0);
        
        cell.layer.transform = transform;
        cell.alpha = 0.7;
        [UIView animateWithDuration:1 delay:0.0 usingSpringWithDamping:0.6f initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            cell.layer.transform = CATransform3DIdentity;
            cell.layer.opacity = 1;
        } completion:nil];
    }
}

+ (void)animationTwoWith:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    //动画2：
    NSMutableSet *showIndexes = [NSMutableSet set];
    
    if (![showIndexes containsObject:indexPath]) {
        [showIndexes addObject:indexPath];
        CATransform3D rotation;
        rotation = CATransform3DMakeRotation((90.0*M_PI)/180, 0.0, 0.7, 0.4);
        rotation.m34 = 1.0/ -600;
        
        //2. Define the initial state (Before the animation)
        cell.layer.shadowColor = [[UIColor blackColor]CGColor];
        cell.layer.shadowOffset = CGSizeMake(10, 10);
        cell.alpha = 0;
        
        cell.layer.transform = rotation;
        cell.layer.anchorPoint = CGPointMake(0.5, 0.5);
        
        //3. Define the final state (After the animation) and commit the animation
        [UIView beginAnimations:@"rotation" context:NULL];
        [UIView setAnimationDuration:0.3];
        cell.layer.transform = CATransform3DIdentity;
        cell.alpha = 1;
        cell.layer.shadowOffset = CGSizeMake(0, 0);
        [UIView commitAnimations];
    }
}

+ (void)animationThreeWith:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    //动画3：
    NSMutableSet *showIndexes = [NSMutableSet set];
    if (![showIndexes containsObject:indexPath]) {
        [showIndexes addObject:indexPath];
        cell.layer.transform = CATransform3DTranslate(cell.layer.transform, 300, 0, 0);
        cell.alpha = 0.5;
        [UIView animateWithDuration:0.3 delay:0.0f usingSpringWithDamping:0.8f initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            cell.layer.transform = CATransform3DIdentity;
            cell.alpha = 1;
        } completion:nil];
    }
}

@end
