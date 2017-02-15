//
//  NSString+Rounding.m
//  GOpenSource_AppKit
//
//  Created by danly on 2017/2/9.
//  Copyright © 2017年 Gizwits. All rights reserved.
//

#import "NSString+Rounding.h"

@implementation NSString (Rounding)

/***
 获取给定浮点值指定小数位的值，采用四舍五入的方式
 price: 给定的浮点值
 position: 小数点后保留的位数
 ***/
+ (NSString *)notRounding:(double)price afterPoint:(NSUInteger)position
{
    // NSRoundPlain: 表示采用四舍五入的方式进位置
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    
    ouncesDecimal = [[NSDecimalNumber alloc] initWithDouble:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    
    return [NSString stringWithFormat:@"%@",roundedOunces];
}


// 获取num值保留positon位有效数字后的字符串
+ (NSString *)getStringFromNum:(CGFloat)num afterPoint:(NSUInteger)position
{
    NSString *result;
    switch (position) {
        case 0:
            result = [NSString stringWithFormat:@"%.0f", num];
            break;
        case 1:
            result = [NSString stringWithFormat:@"%.01f", num];
            break;
        case 2:
            result = [NSString stringWithFormat:@"%.02f", num];
            break;
        case 3:
            result = [NSString stringWithFormat:@"%.03f", num];
            break;
        case 4:
            result = [NSString stringWithFormat:@"%.04f", num];
            break;
        case 5:
            result = [NSString stringWithFormat:@"%.05f", num];
            break;
        case 6:
            result = [NSString stringWithFormat:@"%.06f", num];
            break;
    }
    return result;
}

// 获取小数点后有多少位
+ (NSUInteger)getDecimalPointLength:(NSString *)decimal
{
    NSArray *strs = [decimal componentsSeparatedByString:@"."];
    if (strs.count == 1)
    {
        return 0;
    }
    else
    {
        NSString *result = strs[1];
        return result.length;
    }
}

@end
