//
//  ADShop.h
//  瀑布流
//
//  Created by 王奥东 on 16/7/17.
//  Copyright © 2016年 王奥东. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ADShop : NSObject

/** 图片的高 */
@property (nonatomic,assign) NSInteger height;

/** 图片的宽*/
@property (nonatomic,assign) NSInteger width;

/**
 *  图片的名字
 */
@property (nonatomic,copy) NSString *icon;

/**
 *  服装价格
 */
@property (nonatomic,copy) NSString *price;

/** 图片对象*/
@property (nonatomic,strong) UIImage *image;

/**
 *  实例化方法,用来初始化对象
 *
 *  @param dict 字典对象
 *
 *  @return 当前类的实例化对象
 */
-(instancetype)initWithDict:(NSDictionary *)dict;

/**
 *  类方法,用来初始化对象
 *
 *  @param dict 字典对象
 *
 *  @return 当前类的实例化对象
 */
+ (instancetype)shopWithDict:(NSDictionary *)dict;

/**
 *  加载数据的方法
 *
 *  @param fileName 传入文件的全路径
 *
 *  @return 数组数据,存放模型对象的数组
 */
+(NSArray *)shopWithFile:(NSString *)fileName;





@end
