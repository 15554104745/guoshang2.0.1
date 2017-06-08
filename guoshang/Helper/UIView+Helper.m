//
//  UIView+Helper.m
//  Anyfit
//
//  Created by INRED_Mac on 14-5-16.
//  Copyright (c) 2014年 anyfit. All rights reserved.
//

#import "UIView+Helper.h"

@implementation UIView (Helper)
-(CGFloat)endPointX
{
    return self.frame.origin.x+self.frame.size.width;
}
-(CGFloat)endPointY
{
    return self.frame.origin.y+self.frame.size.height;
}

@end
