//
//  NSString+Rounding.h
//  GOpenSource_AppKit
//
//  Created by danly on 2017/2/9.
//  Copyright © 2017年 Gizwits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Rounding)

/***
 获取给定浮点值指定小数位的值，采用四舍五入的方式
 price: 给定的浮点值
 position: 小数点后保留的位数
 ***/
+ (NSString *)notRounding:(double)price afterPoint:(NSUInteger)position;

// 获取num值保留positon位有效数字后的字符串
+ (NSString *)getStringFromNum:(CGFloat)num afterPoint:(NSUInteger)position;

// 获取小数点后有多少位
+ (NSUInteger)getDecimalPointLength:(NSString *)decimal;

@end
