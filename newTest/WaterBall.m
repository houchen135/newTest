//
//  WaterBall.m
//  newTest
//
//  Created by 侯琛 on 16/5/15.
//  Copyright © 2016年 侯琛. All rights reserved.
//

#import "WaterBall.h"

@implementation WaterBall
{
    CADisplayLink *_link;
    CGFloat _offset;
    CAShapeLayer *_layer;
    CGFloat _waveWidth;
    
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self =[super initWithCoder:aDecoder]) {
        [self initLayerAndProperty];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self =[super initWithFrame: frame]) {
        [self initLayerAndProperty];
    }
    return self;
}
- (void)initLayerAndProperty{
    _waveWidth =self.frame.size.width;
    _layer =[CAShapeLayer layer];
    _layer.opacity=0.5;
    _layer.frame=self.bounds;
    [self.layer addSublayer:_layer];
}
- (void)wave{
    _link =[CADisplayLink displayLinkWithTarget:self selector:@selector(doAni)];
    [_link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}
- (void)srop{
    [_link invalidate];
    _link=nil;
}
- (void)doAni{
    _offset+=_speed;
    CGMutablePathRef pathRef =CGPathCreateMutable();
    CGFloat startY=_waveHeight*sinf(_offset*M_PI/_waveWidth);
    CGPathMoveToPoint(pathRef, NULL, 0, startY);
    for (CGFloat i=0.0; i<_waveWidth; i++) {
        CGFloat y =1.1*_waveHeight*sinf(2.5*M_PI*i/_waveWidth+_offset*M_PI/_waveWidth)+_h;
        CGPathAddLineToPoint(pathRef, NULL, i, y);
    }
    CGPathAddLineToPoint(pathRef, NULL, _waveWidth, self.frame.size.height);
    CGPathAddLineToPoint(pathRef,NULL, 0, self.frame.size.height);
    CGPathCloseSubpath(pathRef);
    
    _layer .path=pathRef;
    _layer.fillColor =[UIColor greenColor].CGColor;
    CGPathRelease(pathRef);

    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
