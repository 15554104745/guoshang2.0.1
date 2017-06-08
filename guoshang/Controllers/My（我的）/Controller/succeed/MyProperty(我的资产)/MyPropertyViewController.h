//
//  MyPropertyViewController.h
//  guoshang
//
//  Created by 张涛 on 16/3/2.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyPropertyViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *goldLabel;

@property (weak, nonatomic) IBOutlet UILabel *guoCoinLabel;

- (IBAction)goldButton:(id)sender;

- (IBAction)guoCoinButton:(id)sender;

- (IBAction)topupButton:(id)sender;

- (IBAction)cashButton:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *gold1;

@property (weak, nonatomic) IBOutlet UIImageView *guobi;

@property (weak, nonatomic) IBOutlet UIImageView *gold2;

@property (weak, nonatomic) IBOutlet UIImageView *gold3;

@property (weak, nonatomic) IBOutlet UIImageView *more1;

@property (weak, nonatomic) IBOutlet UIImageView *more2;

@property (weak, nonatomic) IBOutlet UIImageView *more3;

@property (weak, nonatomic) IBOutlet UIImageView *more4;


@end
