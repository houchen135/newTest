//
//  WaterBall.h
//  newTest
//
//  Created by 侯琛 on 16/5/15.
//  Copyright © 2016年 侯琛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaterBall : UIView
@property (nonatomic, assign) CGFloat speed;
@property (nonatomic, assign) CGFloat waveHeight;
@property (nonatomic, assign) CGFloat h;
- (void)wave;
@end
