//
//  UIBarButtonItem+GSBarButtonItem.h
//  guoshang
//
//  Created by hi on 16/2/20.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (GSBarButtonItem)

+(instancetype)barButtonItemWithBackgroundImage:(UIImage *)backgroundImage
                                highlightedImage:(UIImage *)highlightedImage
                                          target:(id)target
                                          action:(SEL)action
                                forControlEvents:(UIControlEvents)controlEvents;
@end
