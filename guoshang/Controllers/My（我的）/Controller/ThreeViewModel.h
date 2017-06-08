//
//  ThreeViewModel.h
//  guoshang
//
//  Created by JinLian on 16/8/22.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface ThreeViewModel : BaseModel

@property (nonatomic, copy)NSString *market_price, *goods_img, *promote_price, *sale_num, *shop_price, *short_name, *short_style_name, *thumb, *Id, *name;

@end

/*
 {
 "brand_name" = "<null>";
 brief = "\U7b80\U77ed\U63cf\U8ff0\Uff08\U7f8e\U5473\Uff09";
 "goods_img" = "http://192.168.1.168:8122/userfiles/3abf016ded3a4c2cabec83d6bb6d3c3a/images/photo/2016/08/450%2020150608234525_sjEkW_%E5%89%AF%E6%9C%AC_%E5%89%AF%E6%9C%AC.jpg";
 id = 18921;
 "market_price" = "\Uffe5200.00";
 name = "\U4e94\U5149\U5341\U8272\U86cb\U7cd5";
 "promote_price" = "\Uffe588.80";
 "sale_num" = 71;
 "shop_price" = "\Uffe599.90";
 "short_name" = "\U4e94\U5149\U5341\U8272\U86cb\U7cd5";
 "short_style_name" = "<font color=1>\U4e94\U5149\U5341\U8272\U86cb\U7cd5</font>";
 thumb = "http://192.168.1.168:8122/userfiles/3abf016ded3a4c2cabec83d6bb6d3c3a/images/photo/2016/08/450%2020150608234525_sjEkW_%E5%89%AF%E6%9C%AC_%E5%89%AF%E6%9C%AC.jpg";
 url = "/731/Apis/index.php?m=Api&c=Index&a=goods&gid=18921";
 }

 */