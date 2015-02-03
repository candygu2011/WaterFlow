//
//  WaterflowView.h
//  WaterFlowDemo
//
//  Created by hi on 15/1/29.
//  Copyright (c) 2015年 GML. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    WaterflowViewMarginTypeTop,
    WaterflowViewMarginTypeBottom,
    WaterflowViewMarginTypeLeft,
    WaterflowViewMarginTypeRight,
    WaterflowViewMarginTypeColumn,
    WaterflowViewMarginTypeRow,
}WaterflowViewMarginType;
@class WaterflowView,WaterflowCell;
/**
 *  数据源方法
 */
@protocol waterflowViewDataSource <NSObject>
@required
/**
 *  返回一个waterflow的行数
 *  @return 返回行数
 */
-(NSInteger)numberOfCellInWaterflowView:(WaterflowView*)waterflowView;

/**
 *  返回cell单元格的样式
 *
 *  @param waterView 所在的view
 *  @param index     所在的单元格位置
 *
 */
- (WaterflowCell *)waterView:(WaterflowView *)waterView cellAtIndexPath:(NSInteger)index;


@optional
/**
 *  一共多少列
 */
- (NSUInteger)numberOfColumnsInWaterflowView:(WaterflowView *)waterflowView;


@end


@protocol waterflowViewDelegate <UIScrollViewDelegate>
@optional

/**
 *  返回index对应得cell高度
 *  @param index 对应的位置
*  @return 每行的高度
 */
- (CGFloat)waterflowView:(WaterflowView *)waterflowView heightAtIndexPath:(NSInteger)index;


/**
 *  设置行间距
 */
- (CGFloat)waterflowView:(WaterflowView *)waterflowView marginForType:(WaterflowViewMarginType)type;

/**
 * 选中cell方法
 */
- (void)waterflowView:(WaterflowView *)waterflowView didSelectedAtIndex:(NSUInteger)index;


@end


@interface WaterflowView : UIScrollView
@property (nonatomic,weak) id<waterflowViewDataSource>dataSource;
@property (nonatomic,weak) id<waterflowViewDelegate>delegate;
/**
 *  刷新数据(只要调用这个方法，会重新向数据源和代理发送请求，请求)
 */
- (void)reloadData;


/**
 *  根据表示去缓存池去查找
 *
 *  @return
 */
- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier;

@end
