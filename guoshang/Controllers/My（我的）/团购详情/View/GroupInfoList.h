//
//  GroupInfoList.h
//  guoshang
//
//  Created by JinLian on 16/9/19.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>


#import <UIKit/UIKit.h>

typedef void(^passRowHeight)(CGFloat lastRowHeight);

@interface GroupInfoList : UIView {
    
    NSString *SwitchButtonString;
}

@property (retain,nonatomic) NSArray *columnsWidths;
@property (assign,nonatomic) NSUInteger lastRowHeight;
@property (retain,nonatomic) UIImage *selectedImage;
@property (retain,nonatomic) UIImage *unselectedImage;
@property (assign,nonatomic) BOOL roundCorner;
@property (copy,nonatomic)passRowHeight block;

- (id)initWithFrame:(CGRect)frame andColumnsWidths:(NSArray*)columns;
- (void)addRecordWithArr:(NSArray*)record;
- (NSUInteger)selectedIndex;

@end
