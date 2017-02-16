//
//  GosDeviceExtendCell.m
//  GOpenSource_AppKit
//
//  Created by danly on 2017/2/10.
//  Copyright © 2017年 Gizwits. All rights reserved.
//

#import "GosDeviceExtendCell.h"

#define EffectiveNum @"0123456789ABCDEF"

@interface GosDeviceExtendCell()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

// 用于存储textView的旧值，便于与用户输入的新值做比较
@property (nonatomic, copy) NSString *oldText;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, assign) NSInteger oldFocusLocation;

@end

@implementation GosDeviceExtendCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // 添加textView变化通知
    self.valueTextView.scrollEnabled = NO;
    self.valueTextView.delegate = self;
    self.valueTextView.keyboardType = UIKeyboardTypeASCIICapable;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:NO animated:animated];
}

#pragma mark - UITextViewTextDidChangeNotification
// 获取客户新输入的字符
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        // 输入结束
        if ([self.delegate respondsToSelector:@selector(deviceExtendCellEditStop:value:)])
        {
            [self.delegate deviceExtendCellEditStop:self value:self.value];
        }
        [textView resignFirstResponder];
        return NO;
    }
    NSLog(@"text = %@", text);
    NSLog(@"range.location = %zd, range.length = %zd", range.location, range.length);
    
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:EffectiveNum] invertedSet];
    NSString *filtered = [[text componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    
    NSLog(@"text = %@", text);
    NSLog(@"cs = %@", cs);
    NSLog(@"filtered = %@", filtered);
    NSLog(@"changText焦点： %zd", textView.selectedRange.location);
    
    self.oldFocusLocation = textView.selectedRange.location;
    return [text isEqualToString:filtered];
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSInteger newFocusLocation = textView.selectedRange.location;
    if(newFocusLocation >= self.oldFocusLocation)
    {
        // 增加字符，移动焦点
        // 新增字符的个数
        NSInteger newNum = newFocusLocation - self.oldFocusLocation;
        
        if ((self.oldFocusLocation + 1) % 3 == 0)
        {
            newFocusLocation += (newNum + 1) / 2;
        }
        else if((self.oldFocusLocation + 2) % 3 == 0)
        {
            newFocusLocation += (newNum)/2;
        }
    }
    
    // 移动焦点
    textView.text = [self getFormateStringByStr:textView.text];
    textView.selectedRange = NSMakeRange(newFocusLocation, 0);
    
    [self refreshCellByValue];
    self.value = [self getStrByDeleteSpace:textView.text];
    NSLog(@"焦点： %zd", textView.selectedRange.location);
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([self.delegate respondsToSelector:@selector(deviceExtendCellBeginEditing:)])
    {
        [self.delegate deviceExtendCellBeginEditing:self];
    }
}

//- (void)textViewDidEndEditing:(UITextView *)textView
//{
//    if ([self.delegate respondsToSelector:@selector(textViewDidEndEditing:)])
//    {
//        [self.delegate deviceExtendCellEndEditing:self];
//    }
//    
//}

- (void)refreshCellByValue
{
    CGRect bounds = self.valueTextView.bounds;
    CGSize maxSize = CGSizeMake(bounds.size.width, MAXFLOAT);
    CGSize newSize = [self.valueTextView sizeThatFits:maxSize];
    bounds.size = newSize;
    
    self.valueTextView.bounds = bounds;
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

#pragma 字符串格式转换
// 获取去除空格的字符串
- (NSString *)getStrByDeleteSpace:(NSString *)str
{
    return [str stringByReplacingOccurrencesOfString:@" " withString:@""];
}

// 将一个普通字符串格式化成每隔两位加一个空格的形式
// str字符串格式: 63423
// return的字符串格式: 63 42 3
- (NSString *)getFormateStringByStr:(NSString *)str
{
    // 删除所有空格
    str = [NSMutableString stringWithFormat:@"%@", [str stringByReplacingOccurrencesOfString:@" " withString:@""]];
    NSInteger length = str.length;
    if (length <= 2)
    {
        return str;
    }
    
    // 计算格式化后的字符串长度
    NSInteger formateLength = (length / 2 - 1) + length;
    if (length % 2 > 0)
    {
        formateLength++;
    }
    NSLog(@"formateLength = %zd", formateLength);
    
    // 每两位添加一个空格
    NSMutableString *endStr = [NSMutableString stringWithString:str];
    
    for (int i = 0; i < formateLength; ++i)
    {
        if (i > 0 && (i+1) % 3 == 0)
        {
            NSString *tempStr = [endStr substringToIndex:i];
            tempStr = [tempStr stringByAppendingString:@" "];
            [endStr replaceCharactersInRange:NSMakeRange(0, i) withString:tempStr];
            
        }
    }
    
    return endStr;
}

#pragma mark - Properity
- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = title;
}

- (void)setIsWrite:(BOOL)isWrite
{
    _isWrite = isWrite;
    if (!isWrite)
    {
        self.titleLabel.textColor = [UIColor darkGrayColor];
        self.valueTextView.textColor = [UIColor darkGrayColor];
        self.userInteractionEnabled = NO;
    }
}

- (void)setValue:(NSString *)value
{
    _value = value;
    self.valueTextView.text = [self getFormateStringByStr:value];
}

- (UITableView *)tableView
{
    if (_tableView == nil)
    {
        UIView *tableView = self.superview;
        if (![tableView isKindOfClass:[UITableView class]] && tableView)
        {
            _tableView = (UITableView *)(tableView.superview);
        }
    }
    return _tableView;
}


//- (void)textViewDidChange:(UITextView *)textView
//{
//    NSMutableString *text = [NSMutableString stringWithFormat:@"%@", textView.text];
//    
//    NSInteger textLength = text.length;
//    // 当前焦点位置
//    NSUInteger focusLocation = textView.selectedRange.location;
//    
//    if (self.oldText.length == text.length)
//    {
//        return;
//    }
//    
//    if (self.oldText.length > text.length)
//    {
//        // 删除字符
//        if ((focusLocation+1)%3 == 0)
//        {
//            // 在3n-1的位置，即前面删除的是一个空格，需要多删除前一个字符,若没有删除，每次格式化后，又会增加一个空格，导致空格一直删除失败
//            
//            // 先删除焦点前的字符
//            [text deleteCharactersInRange:NSMakeRange(focusLocation-1, 1)];
//            focusLocation--;
//            textLength--;
//        }
//        
//        if (textLength > 0 && textLength % 3 == 0)
//        {
//            textLength++;
//        }
//        
//        // 获取格式化字符串
//        text = [self getFormateString:text textLength:textLength];
//        textView.text = text;
//        textView.selectedRange = NSMakeRange(focusLocation, 0);
//        self.oldText = text;
//        
//    }
//    else
//    {
//        // 增加字符
//        // 获取输入的值
//        NSString *inputChar;
//        if (focusLocation> 0)
//        {
//            inputChar = [text substringWithRange:NSMakeRange(focusLocation-1, 1)];
//        }
//        else
//        {
//            return;
//        }
//        
//        // 判断输入字符是否0-9，A-F中的字符
//        NSRange range = [inputChar rangeOfString:@"[0-9]|[A-F]" options:NSRegularExpressionSearch];
//        if (range.location == NSNotFound)
//        {
//            // 输入值无效
//            [text deleteCharactersInRange:NSMakeRange(focusLocation-1, 1)];
//            textView.text = text;
//            textView.selectedRange = NSMakeRange(focusLocation-1, 0);
//        }
//        else
//        {
//            // 输入值有效
//            if (textLength > 0 && textLength % 3 == 0)
//            {
//                textLength++;
//                focusLocation++;
//            }
//            
//            //删除所有空格
//            text = [self getFormateString:text textLength:textLength];
//            textView.text = text;
//            self.oldText = text;
//            textView.selectedRange = NSMakeRange(focusLocation, 0);
//        }
//    }
//    
//    [self refreshCellByValue];
//    
//    self.value = [self getStrByDeleteSpace:text];
//    if ([self.delegate respondsToSelector:@selector(deviceExtendCell:valueChanged:)])
//    {
//        [self.delegate deviceExtendCell:self valueChanged:self.value];
//    }
//
//}





//// 监听回车事件
//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//    if ([text isEqualToString:@"\n"]) {
//        
//        [textView resignFirstResponder];
//        return NO;
//    }
//    
//    return YES;
//}




#pragma mark - 字符串的格式化处理
//// 将一个普通字符串格式化成每隔两位加一个空格的形式
//// str字符串格式: 63423
//// return的字符串格式: 63 42 3
//- (NSString *)getFormateStringByStr:(NSString *)str
//{
//    NSInteger length = str.length;
//    if (length <= 2)
//    {
//        return str;
//    }
//    
//    // 计算格式化后的字符串长度
//    NSInteger formateLength = (length / 2 - 1) + length;
//    if (length % 2 > 0)
//    {
//        formateLength++;
//    }
//    NSLog(@"formateLength = %zd", formateLength);
//    
//    // 每两位添加一个空格
//    NSMutableString *endStr = [NSMutableString stringWithString:str];
//    
//    for (int i = 0; i < formateLength; ++i)
//    {
//        if (i > 0 && (i+1) % 3 == 0)
//        {
//            NSString *tempStr = [endStr substringToIndex:i];
//            tempStr = [tempStr stringByAppendingString:@" "];
//            [endStr replaceCharactersInRange:NSMakeRange(0, i) withString:tempStr];
//            
//        }
//    }
//    
//    return endStr;
//}
//
//// 获取格式化字符串
//// text：用户在界面输入的字符串, textLength: 经过计算格式化后实际的字符串长度
//// text的格式: 多种形式，如： 43 233
//// return的字符串格式: 43 23 3
//- (NSMutableString *)getFormateString:(NSMutableString *)text textLength:(NSInteger)textLength
//{
//    //删除所有空格
//    text = [NSMutableString stringWithFormat:@"%@", [text stringByReplacingOccurrencesOfString:@" " withString:@""]];
//    
//    for (int i = 0; i < textLength; ++i)
//    {
//        if (i > 1  && ((i+1) % 3 == 0))
//        {
//            NSString *temp = [text substringToIndex:i];
//            temp = [temp stringByAppendingString:@" "];
//            [text replaceCharactersInRange:NSMakeRange(0, i) withString:temp];
//        }
//    }
//    
//    return text;
//}


@end
