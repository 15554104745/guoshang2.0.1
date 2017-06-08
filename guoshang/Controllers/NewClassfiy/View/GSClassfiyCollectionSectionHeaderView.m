//
//  GSClassfiyCollectionSectionHeaderView.m
//  guoshang
//
//  Created by Rechied on 2016/11/2.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSClassfiyCollectionSectionHeaderView.h"

@implementation GSClassfiyCollectionSectionHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSectionModel:(GSClassfiyModel *)sectionModel {
    _sectionModel = sectionModel;
    self.titleLabel.text = sectionModel.name;
}

- (IBAction)sectionClick:(id)sender {
    if ([_delegate respondsToSelector:@selector(collectionViewDidSelectSectionWithCat_id:name:)]) {
        [_delegate collectionViewDidSelectSectionWithCat_id:self.sectionModel.ID name:self.sectionModel.name];
    }
}

@end
