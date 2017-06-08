//
//  GoodsDetailTableViewDelegate.h
//  guoshang
//
//  Created by JinLian on 16/9/7.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol detailScrollViewDelegate <NSObject>

- (void)detailScrollView:(UIScrollView *)scrollView;
-(void)detailScrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

@end


@interface GoodsDetailTableViewDelegate : NSObject <UITableViewDelegate>

@property (nonatomic, strong)NSDictionary *dataListDic;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, weak)id<detailScrollViewDelegate> delegate;

@end
