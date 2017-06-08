//
//  AccountViewController.h
//  guoshang
//
//  Created by 宗丽娜 on 16/3/9.
//  Copyright © 2016年 宗丽娜. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end
