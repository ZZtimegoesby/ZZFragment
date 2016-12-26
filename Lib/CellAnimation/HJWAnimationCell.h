//
//  HJWAnimationCell.h
//  Fragment
//
//  Created by Lion_Lemon on 15/12/5.
//  Copyright © 2015年 Lion_Lemon. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HJWAnimationType){
    HJWAnimationLeft,
    HJWAnimationRight,
    HJWAnimationHorizontal
};

@interface HJWAnimationCell : UIView

+ (void)setAnimationCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath Type:(HJWAnimationType)type;

@end
