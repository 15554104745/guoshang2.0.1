//
//  MultilevelMenu.m
//  MultilevelMenu
//
//  Created by gitBurning on 15/3/13.
//  Copyright (c) 2015年 BR. All rights reserved.
//

#import "MultilevelMenu.h"
#import "MultilevelTableViewCell.h"
#import "MultilevelCollectionViewCell.h"
#import "ClassifyModel.h"

//#import "UIImageView+WebCache.h"

#define kImageDefaultName @"tempShop"
#define kMultilevelCollectionViewCell @"MultilevelCollectionViewCell"
#define kMultilevelCollectionHeader   @"CollectionHeader"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@interface MultilevelMenu()

@property(strong,nonatomic ) UITableView * leftTable; //商品分类
@property(strong,nonatomic ) UICollectionView * rightCollection; //商品展示

@property(assign,nonatomic) BOOL isReturnLastOffset; //是否回到最后的位移

@end
@implementation MultilevelMenu


-(id)initWithFrame:(CGRect)frame WithData:(NSArray *)data withSelectIndex:(void (^)(NSInteger, NSInteger, id))selectIndex
{
    
    if (self  = [super initWithFrame:frame]) {
        if (data.count==0) {
           return nil;
        }
        
        _myblock = selectIndex;
        self.leftSelectColor=[UIColor redColor];
        self.leftSelectBgColor=[UIColor whiteColor];
        self.leftBgColor=UIColorFromRGB(0xF3F4F6);
        self.leftSeparatorColor=UIColorFromRGB(0xE5E5E5);
        self.leftUnSelectBgColor=UIColorFromRGB(0xF3F4F6);
        self.leftUnSelectColor=[UIColor blackColor];
        
        
        _allData=data;
        
        
        /**
         左边的视图
        */
        self.leftTable=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kLeftWidth, frame.size.height)];
        self.leftTable.dataSource=self;
        self.leftTable.delegate=self;
        self.leftTable.showsVerticalScrollIndicator = NO;
        self.leftTable.tableFooterView=[[UIView alloc] init];
        [self addSubview:self.leftTable];
        self.leftTable.backgroundColor = self.leftBgColor;
        
        
        if ([self.leftTable respondsToSelector:@selector(setLayoutMargins:)]) {
            self.leftTable.layoutMargins=UIEdgeInsetsZero;
        }
        if ([self.leftTable respondsToSelector:@selector(setSeparatorInset:)]) {
            self.leftTable.separatorInset=UIEdgeInsetsZero;
        }
        self.leftTable.separatorColor=self.leftSeparatorColor;
        
        
        /**
         右边的视图
         */
        float leftMargin =5;
        //广告位
        _adButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _adButton.frame = CGRectMake(kLeftWidth+leftMargin, 0, Width-kLeftWidth-leftMargin*2, ((Width -kLeftWidth)*60)/220);
        _adButton.backgroundColor = MyColor;
        [self addSubview:_adButton];
        //二级、三级菜单
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumInteritemSpacing=0.f;//左右间隔
        flowLayout.minimumLineSpacing=0.f;
        self.rightCollection=[[UICollectionView alloc] initWithFrame:CGRectMake(kLeftWidth+leftMargin,((Width -kLeftWidth)*60)/220,Width-kLeftWidth-leftMargin*2,frame.size.height-((Width -kLeftWidth)*60)/220) collectionViewLayout:flowLayout];
        
        self.rightCollection.delegate=self;
        self.rightCollection.dataSource=self;
        
        
        
        UINib *nib=[UINib nibWithNibName:kMultilevelCollectionViewCell bundle:nil];
        
        [self.rightCollection registerNib: nib forCellWithReuseIdentifier:kMultilevelCollectionViewCell];
        self.rightCollection.showsVerticalScrollIndicator = NO;
      
        
        UINib *header=[UINib nibWithNibName:kMultilevelCollectionHeader bundle:nil];
        [self.rightCollection registerNib:header forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kMultilevelCollectionHeader];
        
        [self addSubview:self.rightCollection];
        
        
        if (self.allData.count>0 && self.selectIndex == 0) {
              [self.leftTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
        }
      
        self.isReturnLastOffset=YES;
        
        self.rightCollection.backgroundColor=self.leftSelectBgColor;

        self.backgroundColor=self.leftSelectBgColor;
        
    }
    return self;
}

-(void)setLeftBgColor:(UIColor *)leftBgColor{
    _leftBgColor=leftBgColor;
    self.leftTable.backgroundColor=leftBgColor;
   
}
-(void)setLeftSelectBgColor:(UIColor *)leftSelectBgColor{
    
    _leftSelectBgColor=leftSelectBgColor;
    self.rightCollection.backgroundColor=leftSelectBgColor;
    
    self.backgroundColor=leftSelectBgColor;
}
-(void)setLeftSeparatorColor:(UIColor *)leftSeparatorColor{
    _leftSeparatorColor=leftSeparatorColor;
    self.leftTable.separatorColor=leftSeparatorColor;
}
-(void)reloadData{
    
    [self.leftTable reloadData];
    [self.rightCollection reloadData];
    
}

#pragma mark---左边的table 代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.allData.count;
   
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * Identifier=@"MultilevelTableViewCell";
    MultilevelTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:Identifier];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    if (!cell) {
        cell=[[NSBundle mainBundle] loadNibNamed:@"MultilevelTableViewCell" owner:self options:nil][0];
        
        
        UILabel * label=[[UILabel alloc] initWithFrame:CGRectMake(kLeftWidth-0.5, 0, 0.5, 60)];
        label.backgroundColor=tableView.separatorColor;
        
        label.tag=100;
        
        label.font = [UIFont boldSystemFontOfSize:15];
        [cell addSubview:label];
    }
    
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    rightMenu * title = self.allData[indexPath.row];
    
    cell.titile.text=title.menuName;
    
    UILabel * line=(UILabel*)[cell viewWithTag:100];
    
    
    //更改选中状态
    if (indexPath.row==self.selectIndex) {
        
        cell.titile.textColor=self.leftSelectColor;
        cell.lab.backgroundColor = self.leftSelectColor;
        cell.backgroundColor=self.leftSelectBgColor;
       line.backgroundColor=cell.backgroundColor;
    }
    
    else{
        cell.titile.textColor=self.leftUnSelectColor;
        cell.lab.backgroundColor = [UIColor grayColor];
        cell.backgroundColor=self.leftUnSelectBgColor;
        line.backgroundColor=tableView.separatorColor;

    }
    
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        cell.layoutMargins=UIEdgeInsetsZero;
    }
    
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        cell.separatorInset=UIEdgeInsetsZero;
    }
    
    
    return cell;
}


#pragma mark - 设置左边分类的行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

#pragma mark - 设置选中状态
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MultilevelTableViewCell * cell=(MultilevelTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    cell.titile.textColor=self.leftSelectColor;
    cell.backgroundColor = self.leftSelectBgColor;
    UILabel * line=(UILabel*)[cell viewWithTag:100];
    line.backgroundColor=cell.backgroundColor;
    rightMenu * title=self.allData[indexPath.row];
    _selectIndex = indexPath.row;
    //代理方法调用 
    [self.delegate sendValue:_selectIndex];
    
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    self.isReturnLastOffset=NO;
 
    [self.rightCollection reloadData];

    
    
    if (self.isRecordLastScroll) {
    
        [self.rightCollection scrollRectToVisible:CGRectMake(0, title.offsetScorller, self.rightCollection.frame.size.width, self.rightCollection.frame.size.height) animated:NO];
    }
    else{
        
         [self.rightCollection scrollRectToVisible:CGRectMake(0, 0, self.rightCollection.frame.size.width, self.rightCollection.frame.size.height) animated:NO];
    }
    

}


-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    MultilevelTableViewCell * cell=(MultilevelTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    cell.titile.textColor=self.leftUnSelectColor;
    UILabel * line=(UILabel*)[cell viewWithTag:100];
    line.backgroundColor=tableView.separatorColor;
    cell.backgroundColor=self.leftUnSelectBgColor;
    
}



#pragma mark---imageCollectionView代理
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

    if (self.allData.count==0) {
        return 0;
    }
    
    rightMenu * title=self.allData[self.selectIndex];
    return  title.nextArray.count;
 
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    rightMenu * title=self.allData[self.selectIndex];
    if (title.nextArray.count>0) {
        
        rightMenu *sub=title.nextArray[section];
        
        if (sub.nextArray.count==0)//没有下一级
        {
            return 1;
        }
        else
            return sub.nextArray.count;
        
    }
    else{
    return title.nextArray.count;
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    rightMenu * title=self.allData[self.selectIndex];
    NSArray * list;
 
    rightMenu * menu;
    
    menu=title.nextArray[indexPath.section];
    
    if (menu.nextArray.count>0) {
        menu=title.nextArray[indexPath.section];
        list=menu.nextArray;
        menu=list[indexPath.row];
    }

    //传值
    void (^select)(NSInteger left,NSInteger right,id info) = self.myblock;
    
    select(indexPath.section,indexPath.row,menu);
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MultilevelCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:kMultilevelCollectionViewCell forIndexPath:indexPath];
    rightMenu * title=self.allData[self.selectIndex];
    NSArray * list;
    
    rightMenu * meun;

    meun=title.nextArray[indexPath.section];

    if (meun.nextArray.count>0) {
        meun=title.nextArray[indexPath.section];
        list=meun.nextArray;
        meun=list[indexPath.row];
    }
    
    cell.titile.text=meun.menuName;
    cell.titile.font = [UIFont systemFontOfSize:12];
    cell.titile.textColor = [UIColor darkGrayColor];
    cell.titile.layer.borderWidth = 0.5f;
    cell.titile.layer.borderColor = [UIColor colorWithRed:211/255 green:211/255 blue:211/255 alpha:0.3].CGColor;

    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    NSString *reuseIdentifier;
    if ([kind isEqualToString: UICollectionElementKindSectionFooter ]){
        reuseIdentifier = @"footer";
    }else{
        reuseIdentifier = kMultilevelCollectionHeader;
    }
    
    rightMenu * title=self.allData[self.selectIndex];
    
    UICollectionReusableView *view =  [collectionView dequeueReusableSupplementaryViewOfKind :kind   withReuseIdentifier:reuseIdentifier   forIndexPath:indexPath];
    
    UILabel *label = (UILabel *)[view viewWithTag:1];
    label.font=[UIFont systemFontOfSize:14];
    label.textColor=UIColorFromRGB(0x686868);
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
        
        if (title.nextArray.count>0) {    
            rightMenu * menu;
            menu=title.nextArray[indexPath.section];
            label.text=menu.menuName;
        }
        else{
            label.text=@"暂无";
        }
    }
    else if ([kind isEqualToString:UICollectionElementKindSectionFooter]){
        view.backgroundColor = [UIColor lightGrayColor];
        label.text = [NSString stringWithFormat:@"这是footer:%ld",(long)indexPath.section];
    }
    return view;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((Width -kLeftWidth)/2-20, 40);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 10, 0, 10);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size={Width,44};
    return size;
}


#pragma mark---记录滑动的坐标
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.rightCollection]) {

        
        self.isReturnLastOffset=YES;
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([scrollView isEqual:self.rightCollection]) {
        
        rightMenu * title=self.allData[self.selectIndex];
        
        title.offsetScorller=scrollView.contentOffset.y;
        self.isReturnLastOffset=NO;
        
    }

 }

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([scrollView isEqual:self.rightCollection]) {
        
        rightMenu * title=self.allData[self.selectIndex];
        
        title.offsetScorller=scrollView.contentOffset.y;
        self.isReturnLastOffset=NO;
        
    }

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if ([scrollView isEqual:self.rightCollection] && self.isReturnLastOffset) {
        rightMenu * title=self.allData[self.selectIndex];
        
        title.offsetScorller=scrollView.contentOffset.y;
    }
}


#pragma mark--Tools
-(void)performBlock:(void (^)())block afterDelay:(NSTimeInterval)delay{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), block);
}

@end



@implementation rightMenu : NSObject



@end
