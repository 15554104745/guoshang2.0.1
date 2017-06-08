//
//  CateGoryView.m
//  guoshang
//
//  Created by JinLian on 16/8/24.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "CateGoryView.h"

@interface CateGoryView ()<UIPickerViewDataSource,UIPickerViewDelegate> {
    
    NSArray *_dataList;  //存放数组
    NSMutableArray *data1;
    NSString *str1;
    NSString *str2;
    NSString *str3;
    
    
    NSString *returnstr1;
    NSString *returnstr2;
    NSString *returnstr3;
    NSString *returnstr4;
    
    int typeID;
}
@property (nonatomic, strong)UIPickerView *pickerV;


@end
@implementation CateGoryView


- (instancetype)initWithFrame:(CGRect)frame withCateType:(cateType) type {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = MyColor;
        [self addSubview:self.pickerV];
        data1 = [NSMutableArray array];
        
        if (type == 0) {
            typeID = 0;
            [self getShopCateID];
        }else if (type == 1) {
            typeID = 1;
            [self getShopID]; //获取分类列表
        }
        
        
        [self creteButton];

    }
    return self;
}

- (UIPickerView *)pickerV  {
    
    if (!_pickerV) {
        _pickerV  = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 20, self.bounds.size.width, 140)];
        _pickerV.dataSource = self;
        _pickerV.delegate = self;
    }
    
    return _pickerV;
}

- (void)creteButton {
    
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(self.bounds.size.width-60, 0, 40, 30);
    [button1 setTitle:@"确定" forState:UIControlStateNormal];
    button1.titleLabel.font = [UIFont systemFontOfSize:14];
    [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button1.tag = 1000;
    [button1 addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button1];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(20, 0, 40, 30);
    button2.tag = 1001;
    button2.titleLabel.font = [UIFont systemFontOfSize:14];
    [button2 setTitle:@"取消" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button2];
    
}

- (void)buttonAction:(UIButton *)sender {
   
    if (returnstr2.length > 0) {
        returnstr4 = [NSString stringWithFormat:@"%@-%@ %@",returnstr1,returnstr2,str2];
        _block(str2);
    }
    if (returnstr3.length > 0) {
        returnstr4 = [NSString stringWithFormat:@"%@-%@-%@ %@",returnstr1,returnstr2,returnstr3,str3];
        _block(str3);
    }else {
        returnstr4 = [NSString stringWithFormat:@"%@ %@",returnstr1,str1];
        _block(str1);
    }
   
    if (typeID == 0) {
        
        if (sender.tag == 1000) {
            
            [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:@"noticeShopID" object:nil userInfo:@{@"text":returnstr4}]];
            
        }else if (sender.tag == 1001) {
            
            self.dismissBlock();
        }

    }else if (typeID == 1) {
    if (sender.tag == 1000) {

        
        [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:@"notice" object:nil userInfo:@{@"text":returnstr4}]];
        
    }else if (sender.tag == 1001) {
        
        self.dismissBlock();
    }
    
    }
}

- (void)returnValue:(passValueB)block {
    _block = block;
}

//获取店铺分类
- (void)getShopCateID {
    //获取店铺Id
    __weak typeof(self) weakSelf = self;
    [HttpTool POST:URLDependByBaseURL(@"/Api/shop/CustomGoodsCategory")  parameters:@{@"token":[@{@"shop_id":GS_Business_Shop_id} paramsDictionaryAddSaltString]} success:^(id responseObject) {
        if ([[responseObject objectForKey:@"status"]integerValue] == 0) {
            
            _dataList = [responseObject objectForKey:@"result"];
            
            [weakSelf.pickerV reloadAllComponents];
        }
    }
           failure:^(NSError *error) {
               
           }];

}

//获取分类列表
- (void)getShopID {
    __weak typeof(self) weakSelf = self;
    //获取店铺Id
    [HttpTool POST:URLDependByBaseURL(@"/Api/Shop/GoodsCategory")  parameters:nil success:^(id responseObject) {
        
        if ([[responseObject objectForKey:@"status"]integerValue] == 0) {
            
            _dataList = [responseObject objectForKey:@"result"];
            
            [weakSelf.pickerV reloadAllComponents];
        }
    }
     
    failure:^(NSError *error) {
        
    }];
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    if (typeID == 0) {
        return 1;
    }else if (typeID == 1) {
        return 3;
    }
    
    return 0; //3列
}

//返回每一列的行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (component == 0) {
        
        return _dataList.count;
        
    }else if (component == 1){
        
        //返回第一列中选中的行的索引
        NSInteger selectRow = [pickerView selectedRowInComponent:0];
        
        NSDictionary *provinceDic = _dataList[selectRow];
        //获取
        data1 = [provinceDic objectForKey:@"child"];
        
        if (data1 !=nil && ![data1 isKindOfClass:[NSNull class]] &&data1.count !=0){
            
            
            return data1.count;
            
        }
        
    }else {
        
        //返回第一列中选中的行的索引
        NSInteger selectRow = [pickerView selectedRowInComponent:0];
        
        NSDictionary *provinceDic = _dataList[selectRow];
        
        NSArray *provinceArray = [provinceDic objectForKey:@"child"];
        
        
        if (provinceArray !=nil && ![provinceArray isKindOfClass:[NSNull class]] &&provinceArray.count !=0){
            
            //返回第二列索引的下标
            NSInteger selectsityRow = [pickerView selectedRowInComponent:1];
            
            NSDictionary *cityDic = provinceArray[selectsityRow];
            
            NSArray *cityArray = [cityDic objectForKey:@"child"];
            
            if (cityArray !=nil && ![cityArray isKindOfClass:[NSNull class]] &&cityArray.count !=0){
                
                return cityArray.count;
                
            }
            
        }
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (typeID == 0) {
        if (component == 0) {
            
            //获取当前的信息
            NSDictionary *provinceDic = _dataList[row];
            NSString *name = [provinceDic objectForKey:@"category_title"];
            str1 = [provinceDic objectForKey:@"category_id"];
            returnstr1 = name;
            return name;
        }
    }
    
    else if (typeID == 1){
    if (component == 0) {
        
        //获取当前的信息
        NSDictionary *provinceDic = _dataList[row];
        NSString *name = [provinceDic objectForKey:@"name"];
        
        returnstr1 = name;
        return name;
    }else if (component == 1){
        
        
        //获取第一列选中的行的索引
        NSInteger firstSelect = [pickerView selectedRowInComponent:0];
        //获取到信息
        NSDictionary *provinceDic = _dataList[firstSelect];
        //获取自称是数组
        NSArray *provinceArray = [provinceDic objectForKey:@"child"];
        
        
        if (row < provinceArray.count) {
            
            NSDictionary *cityDic = provinceArray[row];
            NSString *name = [cityDic objectForKey:@"name"];
            
            if (name.length > 0) {
                str2 =[ cityDic objectForKey:@"cat_id"];
                returnstr2 = name;
                return name;
            }
        }
        
        
    }else {
        
        
        //获取第一列选中的行的索引
        NSInteger firstSelect = [pickerView selectedRowInComponent:0];
        
        NSDictionary *provinceDic = _dataList[firstSelect];
        
        NSArray *provinceArray = [provinceDic objectForKey:@"child"];
        
        //获取第二列选中的行的索引
        NSInteger secondSelect = [pickerView selectedRowInComponent:1];
        
        NSDictionary *cityDic = provinceArray[secondSelect];
        
        NSArray *arr = [cityDic objectForKey:@"child"];
        //安全判断 避免同时滑动多列时 数组越界崩溃
        
        if (row < arr.count) {
            NSDictionary *dic= arr[row];
            NSString *name = [dic objectForKey:@"name"];
            
            if (name.length > 0) {
                str3 = [dic objectForKey:@"cat_id"];
                returnstr3 = name;
                return name;
            }
        }
    }
    }
    return nil;
}

//刷新数据
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (component == 0) {
        
        returnstr1 = nil;
        returnstr2 = nil;
        returnstr3 = nil;
        
        str1 = nil;
        str2 = nil;
        str3 = nil;
        
        NSDictionary *provinceDic = _dataList[row];
        
        if (typeID== 0) {
            NSString *name = [provinceDic objectForKey:@"category_title"];
            
            str1 = [provinceDic objectForKey:@"category_id"];
            returnstr1 = name;
        }
        else if (typeID == 1) {
            //当选中第一列时，刷新第二、三列
            [pickerView reloadComponent:1];
            [pickerView reloadComponent:2];
            //在数据刷新时使得各列都显示第一条数据
            [pickerView selectRow:0 inComponent:1 animated:YES];
            [pickerView selectRow:0 inComponent:2 animated:YES];
            
            NSDictionary *provinceDic = _dataList[row];
            NSString *name = [provinceDic objectForKey:@"name"];
            
            str1 = [provinceDic objectForKey:@"cat_id"];
            returnstr1 = name;
        }
        

        
    }else if (component == 1){
        //当选中第二列时刷新第三列
        [pickerView reloadComponent:2];
        //在数据刷新时使得各列都显示第一条数据
        [pickerView selectRow:0 inComponent:2 animated:YES];
        
        returnstr2 = nil;
        returnstr3 = nil;
        
        str2 = nil;
        str3 = nil;
        
        NSInteger firstSelect = [pickerView selectedRowInComponent:0];
        //获取到信息
        NSDictionary *provinceDic = _dataList[firstSelect];
        //获取自称是数组
        NSArray *provinceArray = [provinceDic objectForKey:@"child"];
        
        
        if (row < provinceArray.count) {
            
            NSDictionary *cityDic = provinceArray[row];
            NSString *name = [cityDic objectForKey:@"name"];
            str2 =[ cityDic objectForKey:@"cat_id"];
            if (name.length > 0) {
                
                //                _block(str2);
                returnstr2 = name;
                //                NSLog(@"%@",str2);
                //                NSLog(@"%@",returnstr2);
                
            }
        }
        
    }
    
    else if (component == 2) {
        
        returnstr3 = nil;
        
        str3 = nil;
        
        //获取第一列选中的行的索引
        NSInteger firstSelect = [pickerView selectedRowInComponent:0];
        
        NSDictionary *provinceDic = _dataList[firstSelect];
        
        NSArray *provinceArray = [provinceDic objectForKey:@"child"];
        
        //获取第二列选中的行的索引
        NSInteger secondSelect = [pickerView selectedRowInComponent:1];
        
        NSDictionary *cityDic = provinceArray[secondSelect];
        
        NSArray *arr = [cityDic objectForKey:@"child"];
        //安全判断 避免同时滑动多列时 数组越界崩溃
        
        if (row < arr.count) {
            NSDictionary *dic= arr[row];
            NSString *str = [dic objectForKey:@"name"];
            str3 = [dic objectForKey:@"cat_id"];
            if (str.length > 0) {
                
                //                _block(str3);
                returnstr3 = str;
                //                NSLog(@"%@",str3);
                //                NSLog(@"%@",returnstr3);
                
            }
        }
    }
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        
        pickerLabel.minimumFontSize = 8.;
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:UITextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}


@end
