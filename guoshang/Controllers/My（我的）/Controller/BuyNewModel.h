//
//  BuyNewModel.h
//  guoshang
//
//  Created by JinLian on 16/8/16.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "BaseModel.h"

@interface BuyNewModel : BaseModel

//@property (nonatomic, copy)NSString *goods_img, *name, *promote_price, *Id, *shop_price;

@property (nonatomic, copy)NSString *description, *end_time_date, *start_time_date, *goods_id, *group_purchase_number, *store_name, *title, *shop_price, *market_price,*group_price;



@end



/*
 {
 "brand_name" = "<null>";
 brief = "\U65f6\U5c1a\U84dd\U8272\U5916\U5957";
 "goods_img" = "http://www.ibg100.com:8080/gsyg_merchant/userfiles/4c717a34cba940baa6e231f997c8fd10/images/photo/2016/08/%E7%B2%BE%E5%93%81.jpg";
 id = 18636;
 "market_price" = "\Uffe5299.00";
 name = "\U65f6\U5c1a\U84dd\U8272";
 "promote_price" = "\Uffe5199.00";
 "sale_num" = 48;
 "shop_price" = "\Uffe5299.00";
 "short_name" = "\U65f6\U5c1a\U84dd\U8272";
 "short_style_name" = "\U65f6\U5c1a\U84dd\U8272";
 thumb = "http://www.ibg100.com:8080/gsyg_merchant/userfiles/4c717a34cba940baa6e231f997c8fd10/images/photo/2016/08/%E7%B2%BE%E5%93%81.jpg";
 url = "/Apis/index.php?m=Api&c=Index&a=goods&gid=18636";
 },

 */