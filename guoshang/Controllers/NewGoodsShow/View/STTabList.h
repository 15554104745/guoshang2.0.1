//
//  STTabList.h
//  表格创建
//
//  Created by JinLian on 16/8/10.
//  Copyright © 2016年 suntao. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const SwitchButtonString;

@interface STTabList : UIView

@property (retain,nonatomic) NSArray *columnsWidths;
@property (assign,nonatomic) NSUInteger lastRowHeight;
@property (retain,nonatomic) UIImage *selectedImage;
@property (retain,nonatomic) UIImage *unselectedImage;
@property (assign,nonatomic) BOOL roundCorner;

- (id)initWithFrame:(CGRect)frame andColumnsWidths:(NSArray*)columns;
- (void)addRecord:(NSArray*)record;
- (NSUInteger)selectedIndex;


@end
