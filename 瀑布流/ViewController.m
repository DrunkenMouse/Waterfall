//
//  ViewController.m
//  瀑布流
//
//  Created by 王奥东 on 16/7/17.
//  Copyright © 2016年 王奥东. All rights reserved.
//

#import "ViewController.h"
#import "ADWaterfallFlowLayout.h"
#import "ADShop.h"

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,ADWaterfallFlowLayoutDataSource>

//购物数组
@property(nonatomic, strong) NSArray *shopArray;

@property(nonatomic, strong)ADWaterfallFlowLayout *waterFallFlowLayout;

@property(nonatomic,weak)UICollectionReusableView *footerView;

@property(nonatomic,strong)UICollectionView *collectionView;

@property(nonatomic,strong)NSMutableArray *cellContentViewArr;

@end

@implementation ViewController


//懒加载
-(NSArray *)shopArray{
    if (_shopArray == nil) {
        
        _shopArray = [ADShop shopWithFile:[[NSBundle mainBundle] pathForResource:@"1.plist" ofType:nil]];
    }
    return _shopArray;
}

-(ADWaterfallFlowLayout *)waterFallFlowLayout{
    
    if (_waterFallFlowLayout == nil) {
        _waterFallFlowLayout = [[ADWaterfallFlowLayout alloc]init];
     
       
        
    }
    return _waterFallFlowLayout;
}

-(NSMutableArray *)cellContentViewArr{
    if (_cellContentViewArr == nil) {
        _cellContentViewArr = [NSMutableArray array];
    }
    return _cellContentViewArr;
}

-(UICollectionView *)collectionView{
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:self.waterFallFlowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
       
    }
    return _collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.waterFallFlowLayout.dataSource = self;
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellStr];
    
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerStr];
    
    self.collectionView.backgroundColor = [UIColor orangeColor];
    
    [self.view addSubview:self.collectionView];
}


#pragma mark - ADWaterfallFlowLayoutDataSource
-(CGFloat)waterfallFlowLayoutWithWHreation:(ADWaterfallFlowLayout *)flowLayout AtIndexPath:(NSIndexPath *)indexPath{
    
    ADShop *shop = self.shopArray[indexPath.item];
    
    //获取shop的宽高比例 H / W
    return (CGFloat)shop.height / shop.width;

}

#pragma mark -- UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.shopArray.count;
}

//定义标识符
static NSString *cellStr = @"cell";
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellStr forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor purpleColor];
    //删除cell的所有子视图,防止重用
    while ([cell.contentView.subviews lastObject] != nil) {
        [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
    }
    
    //设置属性
    //先获取数据，在获取控件 然后给控件设置属性
    ADShop *shop = self.shopArray[indexPath.item];
    
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:cell.bounds];
    imageView.image = shop.image;
    [cell.contentView addSubview:imageView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(cell.bounds.size.width / 2 - 20, cell.bounds.size.height - 20 , 40, 20)];
    label.text = shop.price;
    [cell.contentView addSubview:label];
    
    return cell;
    
   
}

#pragma mark -- 加载页脚

static NSString *footerStr = @"footer";
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
   
        
        UICollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerStr forIndexPath:indexPath];
    
        reusableView.backgroundColor = [UIColor redColor];
        self.footerView = reusableView;
        
        return reusableView;
   
    
}

#pragma mark -- 界面停止滚动

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    //如果footerView存在，就清空footerView
    if (self.footerView) {
        self.footerView = nil;
        
        //加载数据
        NSMutableArray *nmArray = self.shopArray;
//        [nmArray  addObjectsFromArray:[ADShop shopWithFile:@"1.plist"]];
        
        NSArray *array = [ADShop shopWithFile:[[NSBundle mainBundle] pathForResource:@"1.plist" ofType:nil]];
        
        [nmArray addObjectsFromArray:array];
        
        self.shopArray = nmArray;
        
        [self.collectionView reloadData];
    }
}



//-(void)prepareForReuse






















@end
