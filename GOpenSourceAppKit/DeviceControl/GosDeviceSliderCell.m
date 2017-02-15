//
//  GosDeviceSliderCell.m
//  GOpenSource_AppKit
//
//  Created by danly on 2017/2/9.
//  Copyright © 2017年 Gizwits. All rights reserved.
//

#import "GosDeviceSliderCell.h"
#import "NSString+Rounding.h"

@interface GosDeviceSliderCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@property (weak, nonatomic) IBOutlet UILabel *minLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxLabel;
@property (weak, nonatomic) IBOutlet UISlider *slide;

// 存储小数点位置
@property (nonatomic, assign) NSInteger decimalLength;
// 存储当前滑动条滑动的步数
@property (nonatomic, assign) NSInteger currentStep;

@end

@implementation GosDeviceSliderCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:NO animated:animated];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    
}

#pragma mark - updateUI
- (void)initUI
{
    NSInteger radioDecimal = [NSString getDecimalPointLength:_radio];
    NSInteger additionDecimal = [NSString getDecimalPointLength:_addition];
    // 计算小数点后面保留的有效位位数
    self.decimalLength = radioDecimal > additionDecimal ? radioDecimal : additionDecimal;
    
    // 显示最大值和最小值
    CGFloat maxValue = _radio.doubleValue * _max + _addition.doubleValue;
    self.maxLabel.text = [NSString notRounding:maxValue afterPoint:self.decimalLength];
    self.minLabel.text = [NSString notRounding:_addition.doubleValue afterPoint:self.decimalLength];
    
    [self setupSlide];
    
    // 计算并更新当前步数和当前值
    CGFloat tempCurrentStep = (_value - _addition.doubleValue) / _radio.doubleValue;
    [self updateCurrentStepAndValueByStep:tempCurrentStep];
    // 移动滚动条
    self.slide.value = _currentStep;
}

// 设置滚动条
- (void)setupSlide
{
    self.slide.maximumValue = _max;
    self.slide.minimumValue = 0;
}

//根据步值来更新当前的步数和新的当前值
- (void)updateCurrentStepAndValueByStep:(CGFloat)step
{
    // 计算当前的步数
    _currentStep = [NSString notRounding:step afterPoint:0].integerValue;
    // 根据步数重新计算当前值
    _value = (_radio.doubleValue * (CGFloat)_currentStep) + _addition.doubleValue;
    
    NSLog(@"显示到界面的value值 = %f", _value);
    NSLog(@"显示到界面的value值 = %@", [NSString stringWithFormat:@"%@", [NSString notRounding:_value afterPoint:self.decimalLength]]);
    
    
    // 显示当前值到TextField
    self.valueLabel.text = [NSString stringWithFormat:@"%@", [NSString notRounding:_value afterPoint:self.decimalLength]];
}

#pragma mark - Action
- (IBAction)slideChanging
{
    NSLog(@"正在滑动");
    [self updateCurrentStepAndValueByStep:self.slide.value];
}

- (IBAction)slideChanged
{
    [self updateCurrentStepAndValueByStep:self.slide.value];
    self.slide.value = _currentStep;
    
    if ([self.delegate respondsToSelector:@selector(deviceSlideCell:updateValue:)])
    {
        [self.delegate deviceSlideCell:self updateValue:_value];
    }
}

#pragma mark- Properity
- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = title;
}

- (void)setAddition:(NSString *)addition
{
    _addition = addition;

}

@end
