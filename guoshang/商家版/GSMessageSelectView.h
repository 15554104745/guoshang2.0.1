//
//  MessageSelectVIew.h
//  UISetting
//
//  Created by 金联科技 on 16/7/19.
//  Copyright © 2016年 jlkj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSMessageSelectView : UIView


- (void)setCallbackBlock:(void(^)(NSInteger index))block;
@end
