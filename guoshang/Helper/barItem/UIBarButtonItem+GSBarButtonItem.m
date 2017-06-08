//
//  UIBarButtonItem+GSBarButtonItem.m
//  guoshang
//
//  Created by hi on 16/2/20.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "UIBarButtonItem+GSBarButtonItem.h"

@implementation UIBarButtonItem (GSBarButtonItem)

+(instancetype)barButtonItemWithBackgroundImage:(UIImage *)backgroundImage
                               highlightedImage:(UIImage *)highlightedImage
                                         target:(id)target
                                         action:(SEL)action
                               forControlEvents:(UIControlEvents)controlEvents {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    
    if (highlightedImage != nil) {
        
        [button setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
    }
    // 必须要设置控件尺寸，这里选择根据内容自适应
    [button sizeToFit];
    
    //点击事件
    [button addTarget:target action:action forControlEvents:controlEvents];
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}
@end
