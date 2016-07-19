//
//  ADShop.m
//  瀑布流
//
//  Created by 王奥东 on 16/7/17.
//  Copyright © 2016年 王奥东. All rights reserved.
//

#import "ADShop.h"

@implementation ADShop
-(UIImage *)image{
    
    if (_image == nil) {
        _image = [UIImage imageNamed:self.icon];
    }
    return _image;
    
}



-(instancetype)initWithDict:(NSDictionary *)dict{
    
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    
    return self;
    
}



+(instancetype)shopWithDict:(NSDictionary *)dict{
    
    
    return [[self alloc]initWithDict:dict];
}

//+(NSArray *)shopWithFile:(NSString *)fileName{
//    
//    //1.根据全路径去加载数据
//    NSArray *array = [NSArray arrayWithContentsOfFile:fileName];
//    
//    //2. 创建一个可变数组
//    NSMutableArray *nmArray = [NSMutableArray array];
//    
//    
//    //3. 遍历字典数组
//    for (NSDictionary *dict in array) {
//        //4. 字典转模型,并将模型对象添加到可变数组中
//        [nmArray addObject:[[self alloc]initWithDict:dict]];
//    }
//    
//    //5. 返回存放模型对象的数组
//    return nmArray;
//    
//    
//}
//
//
+(NSArray *)shopWithFile:(NSString *)fileName{
    
    NSArray *array = [NSArray arrayWithContentsOfFile:fileName];
    
    NSMutableArray *nmArray = [NSMutableArray array];
    
    for (NSDictionary *dict in array) {
        [nmArray addObject:[[self alloc] initWithDict:dict]];
        
    }
    
    return nmArray;
}
















@end
