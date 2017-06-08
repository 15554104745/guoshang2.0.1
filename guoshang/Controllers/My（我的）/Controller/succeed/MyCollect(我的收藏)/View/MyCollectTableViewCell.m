//
//  MyCollectTableViewCell.m
//  guoshang
//
//  Created by 张涛 on 16/3/1.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "MyCollectTableViewCell.h"

@interface MyCollectTableViewCell()

//是否已经绘制了下拉菜单
@property (nonatomic, assign) BOOL isAlreadyDrawMenu;

@end


@implementation MyCollectTableViewCell

- (void)awakeFromNib {
    // Initialization code
//    [self customCell];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//-(void)customCell{
//    //最重要的一句代码！没有的话单元格直接全部显示下拉菜单了！两句随便选一句
//    self.layer.masksToBounds = YES;
//
//}

//-(void)buildMenuView{
//    //避免多次绘制
//    if (self.isAlreadyDrawMenu)
//    {
//        return;
//    }
//    
//    
//    self.isAlreadyDrawMenu = YES;
//
//}




@end
