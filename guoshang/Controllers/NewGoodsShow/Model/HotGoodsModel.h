//
//  HotGoodsModel.h
//  guoshang
//
//  Created by JinLian on 16/8/11.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface HotGoodsModel : JSONModel


@property (nonatomic, copy)NSString *goods_img,*shop_price,*short_name,*short_style_name,*thumb,*promote_price;

@property (nonatomic, assign)int id;
/*
"brand_name" = "<null>";
brief = "\U65f6\U5c1a\U9ed1\U8272T\U6064";
"goods_img" = "http://www.ibg100.com:8080/gsyg_merchant/userfiles/4c717a34cba940baa6e231f997c8fd10/images/photo/2016/08/%E5%95%86%E5%93%812.jpg";
id = 18642;
"market_price" = "\Uffe5299.00";
name = "\U65f6\U5c1a\U9ed1\U8272";
"promote_price" = "\Uffe5199.00";
"shop_price" = "\Uffe5299.00";
"short_name" = "\U65f6\U5c1a\U9ed1\U8272";
"short_style_name" = "\U65f6\U5c1a\U9ed1\U8272";
thumb = "http://www.ibg100.com:8080/gsyg_merchant/userfiles/4c717a34cba940baa6e231f997c8fd10/images/photo/2016/08/%E5%95%86%E5%93%812.jpg";
url = "/Apis/index.php?m=Api&c=Index&a=goods&gid=18642";
*/

@end
