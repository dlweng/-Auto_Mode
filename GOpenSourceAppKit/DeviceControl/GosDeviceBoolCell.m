/**
 * GizDeviceBoolCell.m
 *
 * Copyright (c) 2014~2015 Xtreme Programming Group, Inc.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "GosDeviceBoolCell.h"

@interface GosDeviceBoolCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UISwitch *valueSwitch;

@end

@implementation GosDeviceBoolCell

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:NO animated:animated];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = title;
}

- (void)setValue:(BOOL)value
{
    _value = value;
    [self.valueSwitch setOn:value animated:YES];
}

- (IBAction)switchChanged:(id)sender
{
    _value = self.valueSwitch.on;
    if([self.delegate respondsToSelector:@selector(deviceBoolCell:switchDidUpdateValue:)])
    {
        [self.delegate deviceBoolCell:self switchDidUpdateValue:_value];
    }
}

- (void)setUserInteractionEnabled:(BOOL)userInteractionEnabled
{
    [super setUserInteractionEnabled:userInteractionEnabled];
    self.valueSwitch.enabled = userInteractionEnabled;
}

- (void)setIsWrite:(BOOL)isWrite
{
    _isWrite = isWrite;
    self.valueSwitch.userInteractionEnabled = isWrite;
    if (isWrite)
    {
        self.titleLabel.textColor = [UIColor blackColor];
    }
    else
    {
        self.titleLabel.textColor = [UIColor darkGrayColor];
    }
}

@end
