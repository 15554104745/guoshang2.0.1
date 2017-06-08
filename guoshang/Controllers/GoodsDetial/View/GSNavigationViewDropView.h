//
//  GSNavigationViewDropView.h
//  guoshang
//
//  Created by Rechied on 2016/11/16.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol GSNavigationViewDropViewDelegate <NSObject>

- (void)dropViewDidSelectIndex:(NSInteger)index;

@end

@interface GSNavigationViewDropView : UIView
@property (weak, nonatomic) id <GSNavigationViewDropViewDelegate>delegate;
-  (void)changeDropViewStatus;
-  (void)changeDropViewStatusWithframe:(CGRect*)frame;

@end
