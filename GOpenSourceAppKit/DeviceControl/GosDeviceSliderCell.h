//
//  GosDeviceSliderCell.h
//  GOpenSource_AppKit
//
//  Created by danly on 2017/2/9.
//  Copyright © 2017年 Gizwits. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GosDeviceSliderCell;
@protocol GosDeviceSliderCellDelegate <NSObject>

- (void)deviceSlideCell:(GosDeviceSliderCell *)cell updateValue:(CGFloat)value;

@end

@interface GosDeviceSliderCell : UITableViewCell

@property (nonatomic, copy) NSString *title;
// 最大步值
@property (nonatomic, assign) NSInteger max;
// 分辨率 = 步长
@property (nonatomic, copy) NSString *radio;
// 初始值
@property (nonatomic, copy) NSString *addition;
// 当前值
@property (nonatomic, assign) CGFloat value;

@property (nonatomic, weak) id<GosDeviceSliderCellDelegate> delegate;

// 设置完界面属性后，必须调用这个方法初始化界面
- (void)initUI;

@end
