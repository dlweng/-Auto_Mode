//
//  GosDeviceExtendCell.h
//  GOpenSource_AppKit
//
//  Created by danly on 2017/2/10.
//  Copyright © 2017年 Gizwits. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GosDeviceExtendCell;
@protocol GosDeviceExtendCellDelegete <NSObject>

//- (void)deviceExtendCellEndEditing:(GosDeviceExtendCell *)cell;
- (void)deviceExtendCellBeginEditing:(GosDeviceExtendCell *)cell;
- (void)deviceExtendCellEditStop:(GosDeviceExtendCell *)cell value:(NSString *)value;

@end

@interface GosDeviceExtendCell : UITableViewCell

// 标识
@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, copy) NSString *title;
// 当前的扩展值
@property (nonatomic, strong) NSString *value;
// 当前cell是否可控
@property (nonatomic, assign) BOOL isWrite;

@property (nonatomic, weak) id<GosDeviceExtendCellDelegete> delegate;

@property (weak, nonatomic) IBOutlet UITextView *valueTextView;

@end
