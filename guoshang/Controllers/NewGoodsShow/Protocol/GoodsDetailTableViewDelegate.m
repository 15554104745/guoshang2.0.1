//
//  GoodsDetailTableViewDelegate.m
//  guoshang
//
//  Created by JinLian on 16/9/7.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GoodsDetailTableViewDelegate.h"
#import "GoodsDetailShopInfoModel.h"
@implementation GoodsDetailTableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GoodsDetailShopInfoModel *shopModel = [self.dataListDic objectForKey:@"shop_info"];
    switch (indexPath.row) {
        case 0:
            return 175.0f;
            break;
        case 1: {
            if ([shopModel.shop_id integerValue] != 0 ) {
                return 70.0f;
            }else {
                return 88.0f;
            }
        }break;
        case 2:
            if ([shopModel.shop_id integerValue] != 0) {
                return 127.0f;
            }else {
                return 60.0f;
            }
            
            break;
        default:
            return 0.0f;
            break;
    }
    return 200;
}

#pragma  mark - scrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(detailScrollView:)]) {
        [self.delegate detailScrollView:scrollView];
    }
    
}

/**
 *  每次拖拽都会回调
 *  @param decelerate YES时，为滑动减速动画，NO时，没有滑动减速动画
 */
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(detailScrollViewDidEndDragging:willDecelerate:)]) {
        [self.delegate detailScrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }

}


@end
