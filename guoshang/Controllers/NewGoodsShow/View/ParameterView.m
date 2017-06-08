//
//  ParameterView.m
//  Demo
//
//  Created by JinLian on 16/8/9.
//  Copyright © 2016年 GroupFly. All rights reserved.
//

#import "ParameterView.h"
#import "ChooseView.h"
#import "TypeView.h"
#import "BuyCountView.h"
#import "GoodsDetailGoodsInfoModel.h"
#import "GoodsDetailShopInfoModel.h"
#import "AttributeModel.h"

@interface ParameterView () <TypeSeleteDelegete> {
    
    NSMutableArray *sizeArr;           //商品型号数组
    NSMutableArray *attr_id_arr;
    NSMutableArray *attr_priceArr;
    NSArray *colorArr;          //颜色数组
    NSDictionary *stockerDic;   //库存
    GoodsDetailGoodsInfoModel *goodsModel;
    GoodsDetailShopInfoModel *shopModel;
    int goodsStock;
}
@end

@implementation ParameterView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        //        sizeArr = [[NSArray alloc] initWithObjects:@"S",@"M",@"L",nil];
        //        colorArr = [[NSArray alloc] initWithObjects:@"蓝色",@"红色",@"湖蓝色",@"咖啡色",nil];
        //        NSString *str = [[NSBundle mainBundle] pathForResource: @"stock" ofType:@"plist"];
        //        stockerDic = [[NSDictionary alloc] initWithContentsOfURL:[NSURL fileURLWithPath:str]];
    }
    
    return self;
}

- (void)setDataList:(NSDictionary *)dataList {
    
    _dataList = dataList;
    
    [self createBackView];
}

- (void)setGoodsDetailModel:(GSGoodsDetailModel *)goodsDetailModel {
    _goodsDetailModel = goodsDetailModel;
    [self createBackView];
}

- (void)createBackView {
    
    _chooseView = [[ChooseView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _chooseView.dataList = _dataList;
    [self addSubview:_chooseView];
    NSArray *arr = nil;
    if (self.goodsDetailModel) {
        arr = [AttributeModel mj_objectArrayWithKeyValuesArray:self.goodsDetailModel.attribute];
    } else {
        arr = [_dataList objectForKey:@"attribute"];
        goodsModel = [_dataList objectForKey:@"goodsInfo"];
        shopModel = [_dataList objectForKey:@"shopInfo"];
    }
    
    
    
    sizeArr = [NSMutableArray array];
    attr_id_arr = [NSMutableArray array];
    attr_priceArr = [NSMutableArray array];
    for (AttributeModel *model in arr) {
        [sizeArr addObject:model.attr_names];
        [attr_id_arr addObject:model.ID];
        [attr_priceArr addObject:model.shop_price];
    }
    
    if (arr.count > 0) {
        
        //添加尺寸
        _chooseView.sizeView = [[TypeView alloc]initWithFrame:CGRectMake(0, 0, _chooseView.frame.size.width, 50) andDatasource: sizeArr :@"尺码"];
        _chooseView.sizeView.delegate = self;
        _chooseView.sizeView.frame = CGRectMake(0, 0, _chooseView.frame.size.width, _chooseView.sizeView.height);
        [_chooseView.mainscrollview addSubview:_chooseView.sizeView];
        
        if (self.goodsDetailModel) {
            _chooseView.lb_stock.text = [NSString stringWithFormat:@"库存%@件",self.goodsDetailModel.goodsinfo.goods_number];
            _chooseView.lb_detail.text = [NSString stringWithFormat:@"已选 \"%@\" ",[sizeArr objectAtIndex:0]];
        } else {
            _chooseView.lb_stock.text = [NSString stringWithFormat:@"库存%@件",goodsModel.goods_number];
            _chooseView.lb_detail.text = [NSString stringWithFormat:@"已选 \"%@\" ",[sizeArr objectAtIndex:0]];
        }
        
        
        self.attr_id = attr_id_arr[0];
        
        //        //颜色分类
        //        _chooseView.colorView = [[TypeView alloc] initWithFrame:CGRectMake(0, _chooseView.sizeView.frame.size.height, _chooseView.frame.size.width, 50) andDatasource:colorArr :@"颜色分类"];
        //        _chooseView.colorView.delegate = self;
        //        [_chooseView.mainscrollview addSubview:_chooseView.colorView];
        //        _chooseView.colorView.frame = CGRectMake(0, _chooseView.sizeView.frame.size.height, _chooseView.frame.size.width, _chooseView.colorView.height);
        
        //购买数量
        _chooseView.countView.frame = CGRectMake(0, _chooseView.sizeView.frame.size.height+_chooseView.sizeView.frame.origin.y, _chooseView.frame.size.width, 50);
        _chooseView.mainscrollview.contentSize = CGSizeMake(self.frame.size.width, _chooseView.countView.frame.size.height+_chooseView.countView.frame.origin.y);
        
        //        _chooseView.lb_detail.text = @"请选择 尺码  ";
    }
    
    if (self.goodsDetailModel) {
        _chooseView.lb_price.text = self.goodsDetailModel.goodsinfo.shop_price_formated;
        _chooseView.lb_stock.text = [NSString stringWithFormat:@"库存%@件",self.goodsDetailModel.goodsinfo.goods_number];
        _chooseView.stock = [self.goodsDetailModel.goodsinfo.goods_number intValue];
    } else {
        _chooseView.lb_price.text = goodsModel.shop_price_formated;
        _chooseView.lb_stock.text = [NSString stringWithFormat:@"库存%@件",goodsModel.goods_number];
        _chooseView.stock = [goodsModel.goods_number intValue];
    }
    
    
    
}

-(void)btnindex:(int)tag
{
    //选中状态
    if (_chooseView.sizeView.seletIndex >= 0) {
        
        NSString *size =[sizeArr objectAtIndex:_chooseView.sizeView.seletIndex];
        NSString *attr = [attr_id_arr objectAtIndex:_chooseView.sizeView.seletIndex];
        _chooseView.lb_stock.text = [NSString stringWithFormat:@"库存%@件",goodsModel.goods_number];
        _chooseView.lb_detail.text = [NSString stringWithFormat:@"已选 \"%@\" ",size];
        _chooseView.lb_price.text = [attr_priceArr objectAtIndex:_chooseView.sizeView.seletIndex];
        self.attr_id = attr;
        [self resumeBtn:sizeArr :_chooseView.sizeView];;
        
    }
    if (_chooseView.sizeView.seletIndex ==-1) {
        
    }
    
    
    //    //通过seletIndex是否>=0来判断尺码和颜色是否被选择，－1则是未选择状态
    //    if (_chooseView.sizeView.seletIndex >=0&&_chooseView.colorView.seletIndex >=0) {
    //
    //        //尺码和颜色都选择的时候
    //        NSString *size =[sizeArr objectAtIndex:_chooseView.sizeView.seletIndex];
    ////        NSString *color =[colorArr objectAtIndex:_chooseView.colorView.seletIndex];
    //        _chooseView.lb_stock.text = [NSString stringWithFormat:@"库存%@件",goodsModel.goods_number];
    ////        _chooseView.lb_detail.text = [NSString stringWithFormat:@"已选 \"%@\" \"%@\"",size,color];
    //        _chooseView.lb_detail.text = [NSString stringWithFormat:@"已选 \"%@\" ",size];
    //        _chooseView.stock = [goodsModel.goods_number intValue];
    //
    //        [self reloadTypeBtn:[stockerDic objectForKey:size] :colorArr :_chooseView.colorView];
    ////        [self reloadTypeBtn:[stockerDic objectForKey:color] :sizeArr :_chooseView.sizeView];
    //        NSLog(@"%d",_chooseView.colorView.seletIndex);
    ////        _chooseView.img.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",_chooseView.colorView.seletIndex+1]];
    //
    //    }else if (_chooseView.sizeView.seletIndex ==-1&&_chooseView.colorView.seletIndex == -1)
    //    {
    //        //尺码和颜色都没选的时候
    //        _chooseView.lb_price.text = goodsModel.shop_price_formated;
    //        _chooseView.lb_stock.text = [NSString stringWithFormat:@"库存%@件",goodsModel.goods_number];
    ////        _chooseView.lb_detail.text = @"请选择 尺码 颜色分类";
    //        _chooseView.stock = [goodsModel.goods_number intValue];;
    //        //全部恢复可点击状态
    ////        [self resumeBtn:colorArr :_chooseView.colorView];
    //        [self resumeBtn:sizeArr :_chooseView.sizeView];
    //
    //    }else if (_chooseView.sizeView.seletIndex ==-1&&_chooseView.colorView.seletIndex >= 0)
    //    {
    //        //只选了颜色
    //        NSString *color =[colorArr objectAtIndex:_chooseView.colorView.seletIndex];
    //        //根据所选颜色 取出该颜色对应所有尺码的库存字典
    //        NSDictionary *dic = [stockerDic objectForKey:color];
    //        [self reloadTypeBtn:dic :sizeArr :_chooseView.sizeView];
    ////        [self resumeBtn:colorArr :_chooseView.colorView];
    //        _chooseView.lb_stock.text = [NSString stringWithFormat:@"库存%@件",goodsModel.goods_number];
    //        _chooseView.lb_detail.text = @"请选择 尺码";
    //
    //
    //        _chooseView.stock = [goodsModel.goods_number intValue];
    //
    ////        _chooseView.img.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",_chooseView.colorView.seletIndex+1]];
    //
    //    }else if (_chooseView.sizeView.seletIndex >= 0&&_chooseView.colorView.seletIndex == -1)
    //    {
    //        //只选了尺码
    //        NSString *size =[sizeArr objectAtIndex:_chooseView.sizeView.seletIndex];
    //        //根据所选尺码 取出该尺码对应所有颜色的库存字典
    //        NSDictionary *dic = [stockerDic objectForKey:size];
    //        [self resumeBtn:sizeArr :_chooseView.sizeView];
    //        [self reloadTypeBtn:dic :colorArr :_chooseView.colorView];
    //        _chooseView.lb_stock.text = [NSString stringWithFormat:@"库存%@件",goodsModel.goods_number];
    //        _chooseView.lb_detail.text = @"请选择 颜色分类";
    //        _chooseView.stock = [goodsModel.goods_number intValue];;
    //
    //        //        for (int i = 0; i<colorarr.count; i++) {
    //        //            int count = [[dic objectForKey:[colorarr objectAtIndex:i]] intValue];
    //        //            //遍历颜色字典 库存为零则改尺码按钮不能点击
    //        //            if (count == 0) {
    //        //                UIButton *btn =(UIButton *) [choseView.colorView viewWithTag:100+i];
    //        //                btn.enabled = NO;
    //        //            }
    //        //        }
    //
    //    }
}

//恢复按钮的原始状态
-(void)resumeBtn:(NSArray *)arr :(TypeView *)view
{
    for (int i = 0; i< arr.count; i++) {
        UIButton *btn =(UIButton *) [view viewWithTag:100+i];
        btn.enabled = YES;
        btn.selected = NO;
        [btn setBackgroundColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]];
        [btn setTitleColor:[UIColor blackColor] forState:0];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        if (view.seletIndex == i) {
            btn.selected = YES;
            [btn setBackgroundColor:[UIColor redColor]];
        }
    }
}

////根据所选的尺码或者颜色对应库存量 确定哪些按钮不可选
//-(void)reloadTypeBtn:(NSDictionary *)dic :(NSArray *)arr :(TypeView *)view
//{
//    for (int i = 0; i<arr.count; i++) {
//        int count = [[dic objectForKey:[arr objectAtIndex:i]] intValue];
//        UIButton *btn =(UIButton *)[view viewWithTag:100+i];
//        btn.selected = NO;
//        [btn setBackgroundColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]];
//        //库存为零 不可点击
//        if (count == 0) {
//            btn.enabled = NO;
//            [btn setTitleColor:[UIColor lightGrayColor] forState:0];
//        }else
//        {
//            btn.enabled = YES;
//            [btn setTitleColor:[UIColor blackColor] forState:0];
//        }
//        //根据seletIndex 确定用户当前点了那个按钮
//        if (view.seletIndex == i) {
//            btn.selected = YES;
//            [btn setBackgroundColor:[UIColor redColor]];
//        }
//    }
//}


@end
