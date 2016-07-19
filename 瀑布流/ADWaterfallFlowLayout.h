//
//  ADWaterfallFlowLayout.h
//  瀑布流
//
//  Created by 王奥东 on 16/7/17.
//  Copyright © 2016年 王奥东. All rights reserved.
//
#import <UIKit/UIKit.h>

@class ADWaterfallFlowLayout;

@protocol ADWaterfallFlowLayoutDataSource <NSObject>

@required
//宽高比率 高/宽
-(CGFloat)waterfallFlowLayoutWithWHreation:(ADWaterfallFlowLayout *)flowLayout AtIndexPath:(NSIndexPath *)indexPath;

@end

@interface ADWaterfallFlowLayout : UICollectionViewFlowLayout

//一行上item的数量
@property(nonatomic,assign)NSUInteger itemCount;

//数据源代理对象
@property(nonatomic,weak)id<ADWaterfallFlowLayoutDataSource> dataSource;



@end




