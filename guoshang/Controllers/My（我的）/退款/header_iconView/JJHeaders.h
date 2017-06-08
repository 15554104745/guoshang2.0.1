//
//  JJHeaders.h
//  QQHeader
//
//  Created by lijunjie on 16/1/5.
//  Copyright © 2016年 ljj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JJHeaders : NSObject


@property (nonatomic,strong) NSArray *imageStrArr;
+ (UIView *)createHeaderView:(CGFloat)headerWH images:(NSArray *)images;


@end
