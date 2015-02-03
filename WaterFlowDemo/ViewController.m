//
//  ViewController.m
//  WaterFlowDemo
//
//  Created by hi on 15/1/29.
//  Copyright (c) 2015年 GML. All rights reserved.
//

#import "ViewController.h"
#import "WaterflowView.h"
#import "WaterflowCell.h"

// 颜色
#define Color(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define ColorRGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
// 随机色
#define RandomColor Color(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

@interface ViewController ()<waterflowViewDataSource,waterflowViewDelegate>

@property (nonatomic,strong) WaterflowView *waterFlowView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.waterFlowView = [[WaterflowView alloc] initWithFrame:self.view.bounds];
    self.waterFlowView.dataSource = self;
    self.waterFlowView.delegate = self;
    [self.view addSubview:self.waterFlowView];
    [self.waterFlowView reloadData];

}

/**
 *  返回一个waterflow的行数
 *  @return 返回行数
 */
-(NSInteger)numberOfCellInWaterflowView:(WaterflowView*)waterflowView
{
    return 500;
}

/**
 *  返回cell单元格的样式
 *
 *  @param waterView 所在的view
 *  @param index     所在的单元格位置
 *
 */
- (WaterflowCell *)waterView:(WaterflowView *)waterView cellAtIndexPath:(NSInteger)index
{

    static NSString *cellID = @"waterView";
    WaterflowCell *cell = [waterView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[WaterflowCell alloc] init];
        cell.backgroundColor = RandomColor;
        
    }
    cell.titleLabel.textAlignment = NSTextAlignmentCenter;
    cell.titleLabel.text = [NSString stringWithFormat:@"%ld",(long)index];
    return cell;
    
}
- (CGFloat)waterflowView:(WaterflowView *)waterflowView heightAtIndexPath:(NSInteger)index
{
    switch (index % 3) {
        case 0:return 50;
            break;
        case 1:return 120;
            break;
        case 2:return 90;
            break;
        default:return 110;
            break;
    }
}


@end
