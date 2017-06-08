//
//  MySideViewController.m
//  guoshang
//
//  Created by 宗丽娜 on 16/7/21.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "MySideViewController.h"

@interface MySideViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SlideDelegate>
{
    UICollectionView * myCollectionView;
    NSMutableArray * dataSource;
    
    NSMutableArray * imageArr;
    
    NSMutableArray*scrollArr;
}

@end

@implementation MySideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
    [self loadData];
    
}

-(void)createUI
{   scrollArr=[[NSMutableArray alloc]init];
    dataSource = [[NSMutableArray alloc]init];
    imageArr = [[NSMutableArray alloc]init];
    
     UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.scrollDirection=UICollectionViewScrollDirectionVertical;
    flowLayout.minimumLineSpacing=20;
    
    flowLayout. minimumInteritemSpacing=0;
    myCollectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, self.view.frame.size.height-40) collectionViewLayout:flowLayout];
    [myCollectionView registerClass:[MySlideCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    
//    //注册头视图
//    [myCollectionView registerClass:[MySlideHeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusable"];

    myCollectionView.delegate=self;
    myCollectionView.dataSource=self;
    [self.view addSubview:myCollectionView];
    self.automaticallyAdjustsScrollViewInsets=NO;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return 6;
    
    
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MySlideCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.titleLabel.text=@"123";
    cell.priceLabel.text=@"456";
    cell.numberLabel.text=@"789";
    return cell;

}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(170, 200);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}


////为collectionView添加头脚视图
//-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    
//    MySlideHeaderCollectionReusableView * header = (MySlideHeaderCollectionReusableView *)[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"reusable" forIndexPath:indexPath];
//    
//    if([kind isEqualToString:UICollectionElementKindSectionHeader])
//    {
//        header.backgroundColor = [UIColor yellowColor];
//         //设置代理
//        header.delegate=self;
//        
//    }
//        return header;
//}
////设置头脚视图的宽高
//-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
//{
//    return CGSizeMake(50, 50);
//}
//执行代理方法跳转
-(void)tiaozhuan
{
    ClassifyViewController *cla=[[ClassifyViewController alloc]init];
    [self.navigationController pushViewController:cla animated:YES];
}

-(void)loadData
{
   StoreListScrollView*_scroll= [[StoreListScrollView alloc]initWithFrame:CGRectMake(0, 200, Width, 200) AndPicArray:scrollArr];
          [self.view addSubview:_scroll];
        

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
