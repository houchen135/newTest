//
//  ViewController.m
//  newTest
//
//  Created by 侯琛 on 16/4/25.
//  Copyright © 2016年 侯琛. All rights reserved.
//

#import "ViewController.h"
#import "BViewController.h"
#import "WaterBall.h"
@interface ViewController ()
@property (nonatomic,strong)CAShapeLayer *layer;
@property (nonatomic,strong)WaterBall *ball;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makUi];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)makUi{
    UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(10, 30, 60, 40);
    [btn setTitle:@"next" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
    btn.backgroundColor=[UIColor grayColor];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *btn2 =[UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame=CGRectMake(100, 30, 60, 40);
    [btn2 setTitle:@"+++" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
    btn2.backgroundColor=[UIColor grayColor];
    [btn2 addTarget:self action:@selector(btnAction2:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    UIButton *btn3 =[UIButton buttonWithType:UIButtonTypeCustom];
    btn3.frame=CGRectMake(200, 30, 60, 40);
    [btn3 setTitle:@"---" forState:UIControlStateNormal];
    [btn3 setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
    btn3.backgroundColor=[UIColor grayColor];
    [btn3 addTarget:self action:@selector(btnAction3:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn3];
    
    UIView *showView =[[UIView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    showView.backgroundColor =[UIColor cyanColor];
    showView.alpha=0.6;
    [self.view addSubview:showView];
    
    // 贝塞尔曲线(创建一个圆)
    UIBezierPath *path =[UIBezierPath bezierPathWithArcCenter:CGPointMake(100/2.f, 100/2.f) radius:100/2.f startAngle:0 endAngle:M_PI*2 clockwise:YES];
    // 创建一个shapeLayer
    _layer =[CAShapeLayer layer];
    _layer.frame =showView.bounds; // 与showView的frame一致
    _layer.strokeColor = [UIColor redColor].CGColor; // 边缘线的颜色
    _layer.fillColor=[UIColor clearColor].CGColor; // 闭环填充的颜色
    _layer.lineCap =kCALineCapSquare;// 边缘线的类型
    _layer.path=path.CGPath;
    _layer.lineWidth=3.0f;
    
    
//    layer.speed=0.1f;
//    layer.lineWidth=4.0f;
//    layer.strokeStart=0.0f;
//    layer.strokeEnd=3.0f;
    
    
     // 将layer添加进图层
    [showView.layer addSublayer:_layer];
    [self.view addSubview:showView];
    
//    CABasicAnimation *patchAnimation =[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
//    patchAnimation.duration=1.0;
//    patchAnimation.fromValue =[NSNumber numberWithFloat:0.5f];
//    patchAnimation.toValue=[NSNumber numberWithFloat:0.8f];
//    [_layer addAnimation:patchAnimation forKey:nil];
    
    
    
    
    _ball =[[WaterBall alloc]initWithFrame:CGRectMake(100, 300, 200, 200)];
    _ball.speed=2;
    _ball.waveHeight=10;
    _ball.h=200;
    [self.view addSubview:_ball];
    _ball.layer.masksToBounds=YES;
    _ball.layer.cornerRadius=100;
    _ball.layer.borderWidth=2;
    _ball.layer.borderColor=[UIColor orangeColor].CGColor;
    
    

    
}

- (void)btnAction2:(UIButton *)sender{
    _ball.h-=3;
}
- (void)btnAction3:(UIButton *)sender{
    _ball.h+=3;
}
- (void)btnAction:(UIButton *)sender{
    _layer.speed=0.1;
    _layer.strokeStart=0.0f;
    _layer.strokeEnd=0.0f;
//    dispatch_time_t time =dispatch_time(DISPATCH_TIME_NOW, 3*NSEC_PER_SEC);
//    dispatch_after(time, dispatch_get_main_queue(), ^{
//        _layer.speed=0.1;
//        _layer.strokeStart=0.0f;
//        _layer.strokeEnd=1.0f;
//        _layer.lineWidth=2.0f;
//    });
    [_ball wave];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
