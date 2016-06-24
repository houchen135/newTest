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
#import <CoreMotion/CoreMotion.h>
@interface ViewController ()
@property (nonatomic,strong)CAShapeLayer *layer;
@property (nonatomic,strong)WaterBall *ball;
@property (nonatomic,strong)CMMotionManager *motionManager;
@property (nonatomic,strong)NSTimer *updateTimer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makUi];
    [self makeWaterBallDeflection];
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
    
    
    // 水球初始化
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
    NSLog(@"%f",_ball.h);
}
- (void)btnAction3:(UIButton *)sender{
    _ball.h+=3;
    NSLog(@"%f",_ball.h);
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
- (void)makeWaterBallDeflection{
    //  在iOS4之前，加速度计由UIAccelerometer类来负责采集工作,iOS4开始增加一个一个专门负责该方面处理的框架，就是Core Motion Framework
    //  Core Motion主要负责三种数据：加速度值，陀螺仪值，设备motion值。实际上，这个设备motion值就是通过加速度和旋转速度进行 fusing变换算出来的，基本原理后面会介绍。Core Motion在系统中以单独的后台线程的方式去获得原始数据，并同时执行一些motion算法来提取更多的信息，然后呈献给应用层做进一步处理。Core Motion框架包含有一个专门的Manager类，CMMotionManager，然后由这个manager去管理三种和运动相关的数据封装类，而 且，这些类都是CMLogItem类的子类，所以相关的motion数据都可以和发生的时间信息一起保存到对应文件中，有了时间戳，两个相邻数据之间的实 际更新时间就很容易得到了。这个东西是非常有用的，比如有些时候，你得到的是50Hz的采样数据，但希望知道的是每一秒加速度的平均值。
    
    //  从Core Motion中获取数据主要是两种方式，一种是Push，就是你提供一个线程管理器NSOperationQueue，再提供一个Block（有点像C中 的回调函数），这样，Core Motion自动在每一个采样数据到来的时候回调这个Block，进行处理。在这中情况下，block中的操作会在你自己的主线程内执行。另一种方式叫做 Pull，在这个方式里，你必须主动去像Core Motion Manager要数据，这个数据就是最近一次的采样数据。你不去要，Core Motion Manager就不会给你。当然，在这种情况下，Core Motion所有的操作都在自己的后台线程中进行，不会有任何干扰你当前线程的行为。
    
    
    //  初始化 motionManager
    _motionManager = [[CMMotionManager alloc] init];
    if(!_motionManager.accelerometerAvailable){
        // 设备上没有加速器硬件
    }
    // motionManager更新频率是0.01s
    _motionManager.accelerometerUpdateInterval = 0.01;
    
    
    
#pragma mark ------pull方式获取---------
    // 开始更新设备信息(动作)
    [_motionManager startDeviceMotionUpdates];
    
    // 开始更新设备信息(加速度)
    [_motionManager startAccelerometerUpdates];
    // 用一个计时器不停地多次取 加速器的信息(pull方法需要自己取加速器的信息)
    _updateTimer = [NSTimer scheduledTimerWithTimeInterval:0.15 target:self selector:@selector(upDataMontionManagerData)userInfo:nil repeats:YES];
    
    
#pragma mark ------push方式获取---------
}
- (void)upDataMontionManagerData{
    CMDeviceMotion *deviceMotion = _motionManager.deviceMotion;
    CMAccelerometerData *accelerometerData =_motionManager.accelerometerData;
    
    
    
//    NSLog(@"roll=%f",deviceMotion.attitude.roll);
//    NSLog(@"yaw==%f",deviceMotion.attitude.yaw);
//    NSLog(@"pitch===%f",deviceMotion.attitude.pitch);
//    
//    
//    NSLog(@"gravity.x==%f",deviceMotion.gravity.x);
//    NSLog(@"gravity.y===%f",deviceMotion.gravity.y);
//    NSLog(@"gravity.z====%f",deviceMotion.gravity.z);
//    
//    
//    NSLog(@"acceleration.x==%f",accelerometerData.acceleration.x);
//    NSLog(@"acceleration.y===%f",accelerometerData.acceleration.y);
//    NSLog(@"acceleration.z====%f",accelerometerData.acceleration.z);
    

    // 根据加速器获得的设备的三个方向的加速的的的值根据反正切函数求得手机的偏转角（只能获得弧度）
    // 手机上下（听筒为上，上为正）为Y轴   左右（音量键为左，右为正）为X轴    前后为（屏幕朝向方向为前，前为正）Z轴
    double a = atan2(accelerometerData.acceleration.x, accelerometerData.acceleration.y);
    
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.01];
    [UIView setAnimationDelegate:self];
    _ball.transform =CGAffineTransformMakeRotation(M_PI+a);
    
    
    double b = atan2(accelerometerData.acceleration.z, accelerometerData.acceleration.y);
    if (b<=0) {
        _ball.h=175-(1-fabs(b)/M_PI)*100;
    }
//    NSLog(@"b=====%f",(1-fabs(b)/M_PI));
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
