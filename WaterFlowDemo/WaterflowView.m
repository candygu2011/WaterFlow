//
//  WaterflowView.m
//  WaterFlowDemo
//
//  Created by hi on 15/1/29.
//  Copyright (c) 2015年 GML. All rights reserved.
//

#import "WaterflowView.h"
#import "WaterflowCell.h"


#define WaterflowViewDefaultColumns 3   //  默认返回列数
#define WaterflowViewDefaultMargin 8     // 默认间距
#define WaterflowViewDefaultCellH 70     // 默认的cell高度

@interface WaterflowView ()
/**
 *  所有cell的frame数据
 */
@property(nonatomic,strong)NSMutableArray *cellFrames;
/**
 *  正在展示的cell
 */
@property(nonatomic,strong)NSMutableDictionary *displayingCells;

@property(nonatomic,strong)NSMutableSet *reusableCells;


@end


@implementation WaterflowView
-(NSMutableArray *)cellFrames{
    if (_cellFrames == nil) {
        self.cellFrames = [NSMutableArray array];
    }
    return _cellFrames;
}

-(NSMutableDictionary *)displayingCells
{
    if (_displayingCells == nil) {
        self.displayingCells = [NSMutableDictionary dictionary];
        
    }
    return _displayingCells;
}

- (NSMutableSet *)reusableCells
{
    if (_reusableCells == nil) {
        self.reusableCells = [NSMutableSet set];
    }
    return _reusableCells;
}


-(void)reloadData
{
    // cell的总数
    NSInteger numberOfCells = [self.dataSource numberOfCellInWaterflowView:self];
    // cell的列数
    NSInteger numberOfColums = [self numberOfColumns];
    
    // 间距
    CGFloat topM = [self marginForType:WaterflowViewMarginTypeTop];
    CGFloat bottomM = [self marginForType:WaterflowViewMarginTypeBottom];
    CGFloat leftM = [self marginForType:WaterflowViewMarginTypeLeft];
    CGFloat rightM = [self marginForType:WaterflowViewMarginTypeRight];
    CGFloat columM = [self marginForType:WaterflowViewMarginTypeColumn];
    CGFloat rowM = [self marginForType:WaterflowViewMarginTypeRow];
    NSLog(@"%f",self.frame.size.width);
    
    //cell宽度
    CGFloat cellWidth = (self.frame.size.width - leftM-rightM-(numberOfColums - 1)*columM)/numberOfColums ;
    
    // cell高度: 新增的cell加载到最短列所处位置
    // 用一个c语言数组存放所有列的最大Y值
    CGFloat maxYOfColumns[numberOfColums];
    for (int i = 0; i<numberOfColums; i++) {
        maxYOfColumns[i] = 0.0;
    }
    for (int i = 0; i<numberOfCells; i++) {
        
        // cell处在第几列（最短的那列）
        NSInteger cellColumn = 0;
        // cell所处那列最大的Y值(最短一列  最大的Y值)
        CGFloat maxYOfCellColumn = maxYOfColumns[cellColumn];
        for (int j  = 1; j< numberOfColums; j++) {
            if (maxYOfColumns[j]< maxYOfCellColumn) {
                cellColumn = j;
                maxYOfCellColumn = maxYOfColumns[j];
            }
        }
        
        // 询问代理
        CGFloat cellHeight = [self heightAtIndex:i];
        
        // cell的位置
        CGFloat cellX = leftM+cellColumn *(cellWidth + columM);
        CGFloat cellY = 0;
        if (maxYOfCellColumn == 0.0) {
            cellY = topM;
        }else{
            cellY = maxYOfCellColumn + rowM;
        }
        
        // 添加frame到数组中
        CGRect cellFrame = CGRectMake(cellX, cellY, cellWidth, cellHeight);
        
        [self.cellFrames addObject:[NSValue valueWithCGRect:cellFrame]];
        //更新最短那一列的最大Y值
        maxYOfColumns[cellColumn] = CGRectGetMaxY(cellFrame);
        
        
    }
    
    // 设置contentSize
    CGFloat contentH = maxYOfColumns[0];
    for (int j = 1; j<numberOfColums; j++) {
        if (maxYOfColumns[j] > contentH) {
            contentH = maxYOfColumns[j];
        }
    }
    
    contentH += bottomM;
    self.contentSize = CGSizeMake(0, contentH);
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    NSInteger numberOfCells = self.cellFrames.count;

    for (int i = 0; i<numberOfCells; i++) {
        
        CGRect cellFrame = [self.cellFrames[i] CGRectValue];
        WaterflowCell *cell = self.displayingCells[@(i)];
        
        if ([self isInScreen:cellFrame]) {
            
            if (cell == nil) {
                cell = [self.dataSource waterView:self cellAtIndexPath:i];
                cell.frame = cellFrame;
                [self addSubview:cell];
                
                self.displayingCells[@(i)] = cell;
                
            }
        }else{
            if (cell) {
                [cell removeFromSuperview];
                [self.displayingCells removeObjectForKey:@(i)];
                [self.reusableCells addObject:cell];
                
            }
        }

    }
    
    
}

-(id)dequeueReusableCellWithIdentifier:(NSString *)identifier
{
    
    __block WaterflowCell *reusableCell = nil;
    [self.reusableCells enumerateObjectsUsingBlock:^(WaterflowCell * cell, BOOL *stop) {
      
        if ([cell.identifier isEqualToString:identifier]) {
            reusableCell = cell;
        }
        *stop = YES;
    }];
    if (reusableCell) {
        [self.reusableCells removeObject:reusableCell];
    }
    return reusableCell;
    
    
}




-(NSInteger)numberOfColumns{
    
    
    if ([self.dataSource respondsToSelector:@selector(numberOfColumnsInWaterflowView:)]) {
        
        return [self.dataSource numberOfColumnsInWaterflowView:self];
        
    }else{
        
        return WaterflowViewDefaultColumns;
    }
    
}
-(CGFloat)marginForType:(WaterflowViewMarginType)tyoe
{
    if ([self.delegate respondsToSelector:@selector(waterflowView:marginForType:)]) {
        return [self.delegate waterflowView:self marginForType:tyoe];
    }else{
        return WaterflowViewDefaultMargin;
    }
}

-(CGFloat)heightAtIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(waterflowView:heightAtIndexPath:)]) {
        return [self.delegate waterflowView:self heightAtIndexPath:index];
    }else{
        return WaterflowViewDefaultCellH;
    }
}

#pragma mark - 私有方法
/**
 *  判断一个frame有无显示在屏幕上
 *
 *  @param type 屏幕的尺寸
 *
 */
- (BOOL)isInScreen:(CGRect)frame
{
    return (CGRectGetMaxY(frame) > self.contentOffset.y && CGRectGetMinY(frame) < self.contentOffset.y + self.frame.size.height);
}


@end
