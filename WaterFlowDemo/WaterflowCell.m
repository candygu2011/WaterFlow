//
//  WaterflowCell.m
//  WaterFlowDemo
//
//  Created by hi on 15/1/29.
//  Copyright (c) 2015年 GML. All rights reserved.
//

#import "WaterflowCell.h"

@implementation WaterflowCell
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupInitView];

        
    }
    
    return self;
}

-(void)setupInitView{
    
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    [self addSubview:label];
    self.titleLabel = label;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.titleLabel.frame =  CGRectMake(5, 5, self.bounds.size.width - 10, self.bounds.size.height - 10);
    
}



@end
