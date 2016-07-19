//
//  ADWaterfallFlowLayout.m
//  瀑布流
//
//  Created by 王奥东 on 16/7/17.
//  Copyright © 2016年 王奥东. All rights reserved.
//

#import "ADWaterfallFlowLayout.h"

@interface ADWaterfallFlowLayout ()

//这个数组中存放的就是每个控件改变后的属性
@property(nonatomic,strong)NSMutableArray *attNumArray;

//代表当前最小Y所在的列数
@property(nonatomic,assign)NSInteger currentCol;

//存放最大Y的数组
@property(nonatomic,strong)NSMutableArray *maxYarray;

//代表当前最小的Y
@property(nonatomic,assign)CGFloat currentMinY;

@end


@implementation ADWaterfallFlowLayout

//对于collection，需要注意系统有提供方法可获取一组中有多少个cell
//也有方法可获取每个cell的属性。
//瀑布流重点在于每个cell的x、y、W、H都需要自己计算
//将改变后的属性添加到一个数组里，返回可视区域的控件属性时，就返回此数组
//通过系统提供的方法返回的数据为每一个cell的x、y、W、H
//但我们返回之前也获得了每个cell的最高Y
//宽是根据我们所设置的间距、列数所算出来的，固定的。
//高是图片原本的宽高比例乘现在的宽所得到的。
//坐标X是根据当前列数与间距计算的，当前列数从0开始
//坐标Y是最小Y+行间距计算的。
//最小Y是通过保存的上一行的最高Y值来比较出来的。
//最高Y值：cell的Y值+控件的高度，有多少列就保存多少值，用于计算下一行cell的初始Y值
//而后保存当前行的每一列的最高Y值：当前cell的Y+控件的高度
//将计算出的每个cell最高Y保存在一个数组里
//通过声明一个最小的值来循环比较数组里的所有值，而后得到当前行中Y最小的那列。
//当我们获取到最小的Y值之后，保存最小Y所在的列数
//由于第一行的Y是没有最小Y值的，所以上一行的Y值即为nil的情况下
//要让其有个初始值0，有多少列就有多少值，代表第一行的上一行最高Y值为0
//x计算所需的列数也是保存最小Y时设置的列数


-(NSMutableArray *)attNumArray{
    if (!_attNumArray) {
        _attNumArray = [NSMutableArray array];
    }
    return _attNumArray;
}


//初始化一个数组,存放对应控件最大的Y
-(NSMutableArray *)maxYarray{
    if (_maxYarray == nil) {
        
        //初始化时跟它设置对应数量的Y，这个数量就是列数
        //有多少列，就设置多少个初始化的Y,这个Y是0
        _maxYarray = [NSMutableArray array];
        for (int i = 0 ; i < self.itemCount; i++) {
            [_maxYarray addObject:@"0"];
        }
        
    }
    
    return _maxYarray;
}


//layout运行加载前调用的方法
-(void)prepareLayout{
    [super prepareLayout];


    self.attNumArray = nil;
    
    //初始化的时候为空，后面调用的时候会由于值为Nil而又有值
    self.maxYarray = nil;
    // 设置单独item的属性
    //根据当前组的索引 获取item的数量
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];

    self.minimumLineSpacing = 10;
    self.minimumInteritemSpacing = 10;
    //遍历item的数量
    for (int i = 0; i < itemCount; i++) {
        //获取item的索引,然后根据索引获取到item的属性，获取到改变后的属性
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
    
        UICollectionViewLayoutAttributes *attribute = [self layoutAttributesForItemAtIndexPath:indexPath];
        
        //把改变后的控件属性添加到数组
        [self.attNumArray addObject:attribute];
        
    }
    
    //添加footerView

    //获取footerView,必须使用这个类调用
    UICollectionViewLayoutAttributes *footerViewAtt = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];

    //自定义layout时，footerView在属性的时候需要手动设置frame
//    self.footerReferenceSize 获取footerView在视图化界面中的宽高
    footerViewAtt.frame = CGRectMake(0, [self getMaxY], self.collectionView.bounds.size.width, self.footerReferenceSize.height);
    
    //添加footerView
    [self.attNumArray addObject:footerViewAtt];
 
    

}

//通过此方法获取当前控件的属性
-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{

    
    //获取控件的属性
    UICollectionViewLayoutAttributes *itemAtt = [super layoutAttributesForItemAtIndexPath:indexPath];
    
    //改变控件属性
    //计算X Y W H
    
    //(屏幕的宽 - item之间的间距 - sectionInset) / item的数量
    //item之间的间距 = 单个间距(item之间最小的间距) * 间距的数量(item的数量 - 1)
    CGFloat itemW = (self.collectionView.bounds.size.width - self.minimumInteritemSpacing * (self.itemCount - 1) - self.sectionInset.left - self.sectionInset.right) / self.itemCount;
  
    //高的计算
    //获取到宽高比例，拿比例与计算后的宽相乘
    //图片高/图片宽 * 图片的宽 = 图片的高
    CGFloat itemH = [self getImageViewWHreation:indexPath]*itemW;
    
    //获取到一个最小的Y
    //Y = 数组中最小的Y + 行间距
    CGFloat itemY = self.currentMinY + self.minimumLineSpacing;
    
    //X的计算 = sectionInset.left + 当前列 *(控件宽+间距)
    CGFloat itemX = self.sectionInset.left + self.currentCol *(itemW + self.minimumInteritemSpacing);
 
    //更新控件最大的Y
    //控件的Y + 控件的高度
    self.maxYarray[self.currentCol] = @(itemY + itemH);
    itemAtt.frame = CGRectMake(itemX, itemY, itemW, itemH);
    
    //返回改变后的控件属性
    return itemAtt;
    
}

//返回宽高比例  高 / 宽
-(CGFloat )getImageViewWHreation:(NSIndexPath *)indexPath{

    return [self.dataSource waterfallFlowLayoutWithWHreation:self AtIndexPath:indexPath];
}


//返回可视区域的控件属性
//系统想展现界面，是通过可视区域的方法进行返回的
//此方法也决定控件是否显示
//如果有一个控件不在返回的数组attNumArray中，它就不会显示

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    return self.attNumArray;
}


//设置控件可滚动的区域
-(CGSize)collectionViewContentSize{
    
    //最大的Y + insetBottom + footerView的高度
    return CGSizeMake(0, [self getMaxY] + self.sectionInset.bottom + self.footerReferenceSize.height);
    
}


//获得最大的Y
-(CGFloat)getMaxY{

    CGFloat maxY = 0;
    
    for (int i = 0; i < self.maxYarray.count ; i++) {
        
        CGFloat currentMaxY = [self.maxYarray[i] doubleValue];
        if (currentMaxY > maxY) {
            maxY = currentMaxY;
        }
        
    }
    
    return maxY;
}


//设置item的列数，不设置则默认为3
-(NSUInteger)itemCount{
    if (_itemCount == 0) {
        _itemCount = 3;
    }
    return _itemCount;
}




// 获取最小的Y
-(CGFloat)currentMinY{
    
    _currentMinY = MAXFLOAT;
    
    //遍历存放Y的数组
    for (int i = 0 ; i < self.maxYarray.count ; i++) {
        
        CGFloat currentY = [self.maxYarray[i] doubleValue];
        //判断获取的Y和之前的Y哪个小，就存谁
        if (currentY < _currentMinY) {
            //当前的Y
            _currentMinY = currentY;
            //当前的列数
            self.currentCol = i;
        }
    }
    
    return _currentMinY;
}







@end
