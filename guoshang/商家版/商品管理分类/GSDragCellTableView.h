//
//  GSDragCellTableView.h
//  guoshang
//
//  Created by chenlei on 16/10/9.
//  Copyright © 2016年 hi. All rights reserved.
//


#import <UIKit/UIKit.h>
@class GSDragCellTableView;
@protocol GSDragCellTableViewDataSource <UITableViewDataSource>

@required
/**将外部数据源数组传入，以便在移动cell数据发生改变时进行修改重排*/
- (NSArray *)originalArrayDataForTableView:(GSDragCellTableView *)tableView;

@end

@protocol GSDragCellTableViewDelegate <UITableViewDelegate>

@required
/**将修改重排后的数组传入，以便外部更新数据源*/
- (void)tableView:(GSDragCellTableView *)tableView newArrayDataForDataSource:(NSArray *)newArray;

@optional
/**选中的cell完成移动，手势已松开*/
- (void)cellDidEndMovingInTableView:(GSDragCellTableView *)tableView MoveAtIndexPath:(NSIndexPath *)indexPath;
/**选中的cell准备好可以移动的时候*/
- (void)tableView:(GSDragCellTableView *)tableView cellReadyToMoveAtIndexPath:(NSIndexPath *)indexPath;
/**选中的cell正在移动，变换位置，手势尚未松开*/
- (void)cellIsMovingInTableView:(GSDragCellTableView *)tableView;


@end

@interface GSDragCellTableView : UITableView

@property (nonatomic, assign) id<GSDragCellTableViewDataSource> dataSource;
@property (nonatomic, assign) id<GSDragCellTableViewDelegate> delegate;
@property (nonatomic, assign) BOOL isSequence;


@end
