//
//  GSClassfiyCollectionSectionHeaderView.h
//  guoshang
//
//  Created by Rechied on 2016/11/2.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSClassfiyModel.h"

@protocol GSClassfiyCollectionSectionHeaderViewDelegate <NSObject>

- (void)collectionViewDidSelectSectionWithCat_id:(NSString *)cat_id name:(NSString *)name;

@end

@interface GSClassfiyCollectionSectionHeaderView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) GSClassfiyModel *sectionModel;

@property (weak, nonatomic) id <GSClassfiyCollectionSectionHeaderViewDelegate> delegate;
@end
