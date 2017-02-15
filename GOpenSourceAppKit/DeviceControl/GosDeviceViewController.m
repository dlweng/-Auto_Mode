//
//  GizDeviceViewController.m
//  GOpenSource_AppKit
//
//  Created by danly on 2017/2/7.
//  Copyright © 2017年 Gizwits. All rights reserved.
//

#import "GosDeviceViewController.h"
#import "GosDeviceSliderCell.h"
#import "GosDeviceLabelCell.h"
#import "GosDeviceBoolCell.h"
#import "GosDeviceEnumCell.h"
#import "GosDeviceEnumSelectionController.h"
#import "GosDeviceExtendCell.h"

#define GosDeviceSliderCellReuseIdentifier @"GosDeviceSliderCellReuseIdentifier"
#define GosDeviceLabelCellReuseIdentifier @"GosDeviceLabelCellReuseIdentifier"
#define GosDeviceBoolCellReuseIdentifier @"GosDeviceBoolCellReuseIdentifier"
#define GosDeviceEnumCellReuseIdentifier @"GosDeviceEnumCellReuseIdentifier"
#define GosDeviceExtendCellReuseIdentifier @"GosDeviceExtendCellReuseIdentifier"

@interface GosDeviceViewController ()<UITableViewDataSource, UITableViewDelegate, GosDeviceSliderCellDelegate, GosDeviceBoolCellDelegate, GosDeviceEnumCellDelegate, GosDeviceExtendCellDelegete>

@property (nonatomic, strong) GizWifiDevice *device;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, assign) BOOL keyboardIsMove;

@end

@implementation GosDeviceViewController

- (instancetype)initWithDevice:(GizWifiDevice *)device
{
    if (self = [super init])
    {
        self.device = device;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupTableView];
    [self setKeyboardNotification];
}

- (void)setupTableView
{
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:@"GosDeviceSliderCell" bundle:nil] forCellReuseIdentifier:GosDeviceSliderCellReuseIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"GosDeviceLabelCell" bundle:nil] forCellReuseIdentifier:GosDeviceLabelCellReuseIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"GosDeviceBoolCell" bundle:nil] forCellReuseIdentifier:GosDeviceBoolCellReuseIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"GosDeviceEnumCell" bundle:nil] forCellReuseIdentifier:GosDeviceEnumCellReuseIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"GosDeviceExtendCell" bundle:nil] forCellReuseIdentifier:GosDeviceExtendCellReuseIdentifier];
    
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    switch (indexPath.row)
    {
        case 0:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GosDeviceExtendCellReuseIdentifier forIndexPath:indexPath];
            GosDeviceExtendCell *extendCell = (GosDeviceExtendCell *)cell;
            extendCell.title = @"扩展可写";
            extendCell.value = @"FFE463248234354332384732894723942385674723484";
            extendCell.isWrite = YES;
            extendCell.tag = indexPath.row;
            extendCell.delegate = self;
            return cell;
        }
        case 1:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GosDeviceLabelCellReuseIdentifier forIndexPath:indexPath];
            GosDeviceLabelCell *labelCell = (GosDeviceLabelCell *)cell;
            labelCell.title = @"数值可写";
            labelCell.value = 100;
            labelCell.tag = indexPath.row;
            return cell;
        }
        case 2:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GosDeviceBoolCellReuseIdentifier forIndexPath:indexPath];
            GosDeviceBoolCell *boolCell = (GosDeviceBoolCell *)cell;
            boolCell.title = @"布尔可写";
            boolCell.value = YES;
            boolCell.tag = indexPath.row;
            boolCell.delegate = self;
            boolCell.isWrite = YES;
            return cell;
        }
        case 3:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GosDeviceBoolCellReuseIdentifier forIndexPath:indexPath];
            GosDeviceBoolCell *boolCell = (GosDeviceBoolCell *)cell;
            boolCell.title = @"布尔只读";
            boolCell.value = YES;
            boolCell.tag = indexPath.row;
            boolCell.isWrite = false;
            return cell;
        }
        case 4:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GosDeviceEnumCellReuseIdentifier forIndexPath:indexPath];
            GosDeviceEnumCell *enumCell = (GosDeviceEnumCell *)cell;
            enumCell.title = @"枚举可写";
            enumCell.values = @[@"四", @"五", @"六"];
            enumCell.index = 1;
            enumCell.tag = indexPath.row;
            enumCell.isWrite = YES;
            enumCell.delegate = self;
            return cell;
        }
        case 5:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GosDeviceEnumCellReuseIdentifier forIndexPath:indexPath];
            GosDeviceEnumCell *enumCell = (GosDeviceEnumCell *)cell;
            enumCell.title = @"枚举只读";
            enumCell.values = @[@"四", @"五", @"六"];
            enumCell.index = 1;
            enumCell.tag = indexPath.row;
            enumCell.isWrite = NO;
            enumCell.delegate = self;
            return cell;
        }
        case 6:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GosDeviceExtendCellReuseIdentifier forIndexPath:indexPath];
            GosDeviceExtendCell *extendCell = (GosDeviceExtendCell *)cell;
            extendCell.title = @"扩展只读";
            extendCell.value = @"00004632482343543";
            extendCell.isWrite = NO;
            extendCell.tag = indexPath.row;
            return cell;
        }
        case 7:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GosDeviceExtendCellReuseIdentifier forIndexPath:indexPath];
            GosDeviceExtendCell *extendCell = (GosDeviceExtendCell *)cell;
            extendCell.title = @"扩展可写";
            extendCell.value = @"FFE463248234354332384732894723942385674723484";
            extendCell.isWrite = YES;
            extendCell.tag = indexPath.row;
            extendCell.delegate = self;
            return cell;
        }
        case 8:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GosDeviceSliderCellReuseIdentifier forIndexPath:indexPath];
            GosDeviceSliderCell *slideCell = (GosDeviceSliderCell *)cell;
            slideCell.max = 999;
            slideCell.value = 500;
            slideCell.title = @"数值只读";
            slideCell.addition = @"0";
            slideCell.radio = @"1";
            slideCell.tag = indexPath.row;
            [slideCell initUI];
            return cell;
        }
//        case 0:
//        {
//            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GosDeviceExtendCellReuseIdentifier forIndexPath:indexPath];
//            GosDeviceExtendCell *extendCell = (GosDeviceExtendCell *)cell;
//            extendCell.title = @"扩展可写";
//            extendCell.value = @"FFE463248234354332384732894723942385674723484";
//            extendCell.isWrite = YES;
//            extendCell.tag = indexPath.row;
//            extendCell.delegate = self;
//            return cell;
//        }
//        case 1:
//        {
//            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GosDeviceExtendCellReuseIdentifier forIndexPath:indexPath];
//            GosDeviceExtendCell *extendCell = (GosDeviceExtendCell *)cell;
//            extendCell.title = @"扩展可写";
//            extendCell.value = @"FFE463248234354332384732894723942385674723484";
//            extendCell.isWrite = YES;
//            extendCell.tag = indexPath.row;
//            extendCell.delegate = self;
//            return cell;
//        }
//        case 2:
//        {
//            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GosDeviceExtendCellReuseIdentifier forIndexPath:indexPath];
//            GosDeviceExtendCell *extendCell = (GosDeviceExtendCell *)cell;
//            extendCell.title = @"扩展可写";
//            extendCell.value = @"FFE463248234354332384732894723942385674723484";
//            extendCell.isWrite = YES;
//            extendCell.tag = indexPath.row;
//            extendCell.delegate = self;
//            return cell;
//        }
//        case 3:
//        {
//            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GosDeviceExtendCellReuseIdentifier forIndexPath:indexPath];
//            GosDeviceExtendCell *extendCell = (GosDeviceExtendCell *)cell;
//            extendCell.title = @"扩展可写";
//            extendCell.value = @"FFE463248234354332384732894723942385674723484";
//            extendCell.isWrite = YES;
//            extendCell.tag = indexPath.row;
//            extendCell.delegate = self;
//            return cell;
//        }
//        case 4:
//        {
//            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GosDeviceExtendCellReuseIdentifier forIndexPath:indexPath];
//            GosDeviceExtendCell *extendCell = (GosDeviceExtendCell *)cell;
//            extendCell.title = @"扩展可写";
//            extendCell.value = @"FFE463248234354332384732894723942385674723484";
//            extendCell.isWrite = YES;
//            extendCell.tag = indexPath.row;
//            extendCell.delegate = self;
//            return cell;
//        }
//        case 5:
//        {
//            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GosDeviceExtendCellReuseIdentifier forIndexPath:indexPath];
//            GosDeviceExtendCell *extendCell = (GosDeviceExtendCell *)cell;
//            extendCell.title = @"扩展可写";
//            extendCell.value = @"FFE463248234354332384732894723942385674723484";
//            extendCell.isWrite = YES;
//            extendCell.tag = indexPath.row;
//            extendCell.delegate = self;
//            return cell;
//        }
//        case 6:
//        {
//            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GosDeviceExtendCellReuseIdentifier forIndexPath:indexPath];
//            GosDeviceExtendCell *extendCell = (GosDeviceExtendCell *)cell;
//            extendCell.title = @"扩展可写";
//            extendCell.value = @"FFE463248234354332384732894723942385674723484";
//            extendCell.isWrite = YES;
//            extendCell.tag = indexPath.row;
//            extendCell.delegate = self;
//            return cell;
//        }
//        case 7:
//        {
//            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GosDeviceExtendCellReuseIdentifier forIndexPath:indexPath];
//            GosDeviceExtendCell *extendCell = (GosDeviceExtendCell *)cell;
//            extendCell.title = @"扩展可写";
//            extendCell.value = @"FFE463248234354332384732894723942385674723484";
//            extendCell.isWrite = YES;
//            extendCell.tag = indexPath.row;
//            extendCell.delegate = self;
//            return cell;
//        }
//        case 8:
//        {
//            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GosDeviceExtendCellReuseIdentifier forIndexPath:indexPath];
//            GosDeviceExtendCell *extendCell = (GosDeviceExtendCell *)cell;
//            extendCell.title = @"扩展可写";
//            extendCell.value = @"FFE463248234354332384732894723942385674723484";
//            extendCell.isWrite = YES;
//            extendCell.tag = indexPath.row;
//            extendCell.delegate = self;
//            return cell;
//        }

        default:
            return nil;
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.tableView endEditing:YES];
}

#pragma mark - GosDeviceSliderCellDelegate
- (void)deviceSlideCell:(GosDeviceSliderCell *)cell updateValue:(CGFloat )value
{
    NSLog(@"deviceSlideCell*****************滑块滑动到值: %f", value);
}

#pragma mark - GosDeviceBoolCellDelegate
- (void)deviceBoolCell:(GosDeviceBoolCell *)cell switchDidUpdateValue:(BOOL)value
{
    NSLog(@"deviceBoolCell布尔值发生改变: %d", value);
}

#pragma mark - GosDeviceEnumCellDelegate
- (void)deviceEnumCellDidSelected:(GosDeviceEnumCell *)cell
{
    GosDeviceEnumSelectionController *deviceEnumController = [[GosDeviceEnumSelectionController alloc] initWithEnumCell:cell];
    [deviceEnumController.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_arrow.png"] style:UIBarButtonItemStylePlain target:self action:@selector(onBackControl)]];
    [self.navigationController pushViewController:deviceEnumController animated:YES];
}

#pragma mark - GosDeviceExtendCellDelegete
- (void)deviceExtendCell:(GosDeviceExtendCell *)cell valueChanged:(NSString *)text
{
    NSLog(@"ExtendCell用户输入的值为%@", text);
}

- (void)deviceExtendCellBeginEditing:(GosDeviceExtendCell *)cell
{
    CGPoint viewCenter = self.view.center;
    if (self.tableView.center.y != viewCenter.y)
    {
        // 初始化tableView的位置,让tableView覆盖整个界面
        self.tableView.center = CGPointMake(viewCenter.x, viewCenter.y);
    }
    
    // 获取tableView的内偏移值
    CGPoint contentOffset = self.tableView.contentOffset;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat cellHeight = cell.frame.size.height;
    
    // 根据tableview内偏移值与cell的Y值，计算cell在界面的实际值
    CGFloat cellY = cell.frame.origin.y - contentOffset.y;
    CGFloat keyboardHeight = 258;
    
//    CGPoint contentOffset = self.tableView.contentOffset;
    NSLog(@"contentOffset.x = %f ,contentOffset.y = %f", contentOffset.x, contentOffset.y);
    
    // 偏移值
    CGFloat offset = 0;

    // 求键盘是否需要偏移
    if ((cellY + cellHeight) > (screenHeight - keyboardHeight))
    {
        // 弹出的键盘会遮挡到cell，需要偏移tableView
        // 偏移值
        offset = keyboardHeight - (screenHeight - (cellY + cellHeight));
        
        if ((cellY - offset) < 0)
        {
            // 移动后cell会被遮挡到上部分,设置显示到最上面部分
            offset = cellY;
        }
        
        NSLog(@"offset = %f", offset);
        [UIView animateWithDuration:0.25 animations:^{
            self.tableView.center = CGPointMake(viewCenter.x, self.tableView.center.y - offset);
        }];
    }
}


#pragma mark - keyboard事件
- (void)setKeyboardNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardFrameChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    
}

- (void)keyBoardFrameChange:(NSNotification *)notification
{
    // 移动键盘的时候恢复tableView在界面的位置
    CGPoint viewCenter = self.view.center;
    if (self.tableView.center.y != viewCenter.y)
    {
        // 初始化tableView的位置
        self.tableView.center = CGPointMake(viewCenter.x, viewCenter.y);
    }
}


// 结束编辑
- (void)deviceExtendCellEndEditing:(GosDeviceExtendCell *)cell
{
    [self.tableView endEditing:YES];
    
    // 结束编辑时恢复tableView在界面的位置
    CGPoint viewCenter = self.view.center;
    if (self.tableView.center.y != viewCenter.y)
    {
        // 初始化tableView的位置
        self.tableView.center = CGPointMake(viewCenter.x, viewCenter.y);
    }
}

- (void)onBackControl {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableView *)tableView
{
    if (_tableView == nil)
    {
        UITableView *tb = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        [self.view addSubview:tb];
        _tableView = tb;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

@end
