//
//  NewRollLabel.m
//  NewRoll
//
//  Created by 求罩 on 15/9/30.
//  Copyright (c) 2015年 网易新闻滚动. All rights reserved.
//

#import "NewRollLabel.h"

@implementation NewRollLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.textAlignment = NSTextAlignmentCenter;
        self.font = [UIFont systemFontOfSize:18];
        
        self.scale = 0.0;
    }
    return self;
}

/** 通过scale的改变改变多种参数 */
- (void)setScale:(CGFloat)scale
{
    _scale = scale;
    
    self.textColor = [UIColor colorWithRed:scale green:0.0 blue:0.0 alpha:1];
    
    CGFloat minScale = 0.7;
    CGFloat trueScale = minScale + (1-minScale)*scale;
    self.transform = CGAffineTransformMakeScale(trueScale, trueScale);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
