//
//  BezierPathView.m
//  Dome
//
//  Created by liubaojian on 16/8/27.
//  Copyright © 2016年 liubaojian. All rights reserved.
//

#import "showsView.h"
#import <objc/runtime.h>

//由角度获取弧度 有弧度获取角度
#define degreesToRadian(x) (M_PI * (x) / 180.0)
#define radianToDegrees(radian) (radian*180.0)/(M_PI)
#define  TILE_SIZE  30
#define  WIDTH      50

@implementation showsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

- (void)setTypeStr:(NSString *)typeStr
{
   
    _typeStr = typeStr;
    if ([typeStr intValue]>3) {
        
        
        imgaeV1 =[[UIImageView alloc] initWithFrame:CGRectMake(10,100,300,210)];
        imgaeV1.image = [UIImage  imageNamed:@"lijuli.jpg"];
        imgaeV1.backgroundColor = [UIColor clearColor];
        [self addSubview:imgaeV1];
        
        switch ([typeStr intValue]) {
            case 4:
                [self startAnimation];
                break;
            case 5:
                [self startAnimation1];
                break;
            case 6:
                [self startAnimation2];
                break;
            case 7:
                [self opacityForever_Animation:1];
                break;
            case 8:
                [self opacityTimes_Animation:3 durTimes:1];
                break;
            case 9:
                [self animateCicleAlongPath];
                break;
                
            default:
                break;
        }
    }
    else{
        SEL selector = NSSelectorFromString([NSString stringWithFormat:@"showView%@",typeStr]);
        IMP imp = [self methodForSelector:selector];
        void (*func)(id, SEL) = (void *)imp;
        func(self, selector);
    }
}
- (void)showView0
{
    UIImageView *imgaeV =[[UIImageView alloc] initWithFrame:CGRectMake(10,100,300,210)];
    imgaeV.image = [UIImage  imageNamed:@"lijuli.jpg"];
    imgaeV.backgroundColor = [UIColor clearColor];
    [self addSubview:imgaeV];
    CAShapeLayer *layer = [self createMaskLayerWithView:imgaeV];
    imgaeV.layer.mask = layer;

}
/**
 *  动态显示音量／油量等上升或者下降
 */
- (void)showView1
{
    
    self.backgroundColor = [UIColor whiteColor];
    
    UIView *outView = [[UIView alloc]initWithFrame:CGRectMake(130, 100, 60, 120)];
    outView.backgroundColor = [UIColor whiteColor];
    outView.layer.borderWidth = 1;
    outView.layer.borderColor = [UIColor blackColor].CGColor;
    outView.layer.cornerRadius = 30;
    outView.clipsToBounds = YES;
    [self addSubview:outView];
    
    changeLayer = [CAShapeLayer layer];
    changeLayer.fillColor = [UIColor greenColor].CGColor;
    [outView.layer addSublayer:changeLayer];
    
    //拼接路径
    CAShapeLayer *someLayer = [CAShapeLayer layer];
    UIBezierPath *someLayerPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(160, 190) radius:60 startAngle:M_PI endAngle:2*M_PI clockwise:NO];
    UIBezierPath *someLayerPath1 = [UIBezierPath bezierPath];
    [someLayerPath1 moveToPoint:CGPointMake(160, 250)];
    [someLayerPath1 addLineToPoint:CGPointMake(160, 300)];
    [someLayerPath1 closePath];
    [someLayerPath appendPath:someLayerPath1];
    //设置layer 属性
    someLayer.fillColor = [UIColor clearColor].CGColor;
    someLayer.strokeColor = [UIColor blackColor].CGColor;
    someLayer.path = someLayerPath.CGPath;
    [self.layer addSublayer:someLayer];
    
    time1 = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(getrandomValue) userInfo:nil repeats:YES];
    [time1 fire];
    /*
     外部轮廓View主要控制显示大小和显示的圆角效果。
     内部的Layer主要控制动态显示的高度，虽然他是矩形的。
     但是当把该Layer加入到View中，而该View设置了_dynamicView.clipsToBounds = YES;。
     内部的Layer超过外部轮廓的部分，则会被切除掉。
     */
    
}

- (void)showView2
{
    CAShapeLayer *shapeLayer=[CAShapeLayer layer];
    shapeLayer.strokeEnd=0.8f;
    shapeLayer.strokeStart=0.0f;
    UIBezierPath*path=[UIBezierPath bezierPathWithOvalInRect:CGRectMake(100, 100, 100, 100)];
    shapeLayer.path=path.CGPath;
    shapeLayer.fillColor=[UIColor clearColor].CGColor;
    shapeLayer.lineWidth=2.0f;
    shapeLayer.strokeColor=[UIColor redColor].CGColor;
    [self.layer addSublayer:shapeLayer];

//
    
    CAShapeLayer *shapeLayer1 = [CAShapeLayer layer];
    UIBezierPath *path1 = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(90, 300, 140, 140)];
    shapeLayer1.path = path1.CGPath;
    shapeLayer1.fillColor = [UIColor clearColor].CGColor;
    shapeLayer1.lineWidth = 2.0f;
    shapeLayer1.strokeColor = [UIColor redColor].CGColor;
    [self.layer addSublayer:shapeLayer1];
    CABasicAnimation *pathAnima = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnima.duration = 1.5f;
    pathAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnima.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnima.toValue = [NSNumber numberWithFloat:1.0f];
    pathAnima.fillMode = kCAFillModeForwards;
    pathAnima.removedOnCompletion = NO;
    [shapeLayer1 addAnimation:pathAnima forKey:nil];
}

-(void)showView3
{
    CGSize size=[UIScreen mainScreen].bounds.size;
    
    //获得根图层
    CALayer *layer=[[CALayer alloc]init];
    //设置背景颜色,由于QuartzCore是跨平台框架，无法直接使用UIColor
    layer.backgroundColor=[UIColor colorWithRed:0 green:146/255.0 blue:1.0 alpha:1.0].CGColor;
    //设置中心点
    layer.position=CGPointMake(size.width/2, size.height/2);
    //设置大小
    layer.bounds=CGRectMake(0, 0, WIDTH,WIDTH);
    //设置圆角,当圆角半径等于矩形的一半时看起来就是一个圆形
    layer.cornerRadius=WIDTH/2;
    //设置阴影
    layer.shadowColor=[UIColor grayColor].CGColor;
    layer.shadowOffset=CGSizeMake(2, 2);
    layer.shadowOpacity=.9;
    [self.layer addSublayer:layer];
    
}

//***************************************************    尖角化   ***************************************
//构建一个Mask 化的 CAShapeLayer
- (CAShapeLayer *)createMaskLayerWithView : (UIView *)view
{
    
    CGFloat viewWidth = CGRectGetWidth(view.frame);
    CGFloat viewHeight = CGRectGetHeight(view.frame);
    CGFloat rightSpace = 20;
    CGFloat topSpace = 20;
    CGPoint point1 = CGPointMake(0, 0);
    CGPoint point2 = CGPointMake(viewWidth-rightSpace, 0);
    CGPoint point3 = CGPointMake(viewWidth-rightSpace, topSpace);
    CGPoint point4 = CGPointMake(viewWidth, topSpace);
    CGPoint point5 = CGPointMake(viewWidth-rightSpace, topSpace+15.);
    CGPoint point6 = CGPointMake(viewWidth-rightSpace, viewHeight);
    CGPoint point7 = CGPointMake(0, viewHeight);
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:point1];
    [path addLineToPoint:point2];
    [path addLineToPoint:point3];
    [path addLineToPoint:point4];
    [path addLineToPoint:point5];
    [path addLineToPoint:point6];
    [path addLineToPoint:point7];
    [path closePath];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    return layer;
}

//****************************************************   音量变化效果  **************************************************


- (void)getrandomValue
{
    int x = arc4random() % 120;
    [self refreshUIWithVoicePower:x];
}

-(void)refreshUIWithVoicePower : (int)voicePower{
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0,voicePower,60,120-voicePower) cornerRadius:0];
    path.lineWidth = 4;
    changeLayer.path = path.CGPath;
}
- (void)endTimer;
{
    [time1 invalidate];
    time1 = nil;
}


//******************************************************   Layer操作    **********************************************
#pragma mark 点击放大
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if ([_typeStr intValue] == 3) {
        
        UITouch *touch=[touches anyObject];
        CALayer *layer=self.layer.sublayers[0];
        CGFloat width=layer.bounds.size.width;
        if (width==WIDTH) {
            width=WIDTH*3;
        }else{
            width=WIDTH;
        }
        layer.bounds=CGRectMake(0, 0, width, width);
        layer.position=[touch locationInView:self];
        layer.cornerRadius=width/2;
    }
 
}


//******************************************************   CABasicAnimation    **********************************************

-(void)startAnimation
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(50, 50)];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(300, 300)];
    animation.duration = 3.0f;
    animation.repeatCount = 1;
    animation.removedOnCompletion = NO; //完成后是否回到原来状态，如果为NO 就是停留在动画结束时的状态
    //animation.fillMode = kCAFillModeRemoved;//动画完成后返回到原来状态
    //animation.fillMode = kCAFillModeBackwards;
    animation.fillMode = kCAFillModeForwards;//当动画完成时，保留在动画结束的状态
    [imgaeV1.layer addAnimation:animation forKey:nil];
}

-(void)startAnimation1
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    animation.fromValue = [NSNumber numberWithFloat:0.0f];
    animation.toValue   = [NSNumber numberWithFloat:70.0f];
    animation.duration = 2;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;

    
    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    animation1.fromValue = [NSNumber numberWithFloat:0.0f];
    animation1.toValue   = [NSNumber numberWithFloat:60.0f];
    animation1.duration = 2;
    animation1.fillMode = kCAFillModeForwards;
    animation1.removedOnCompletion = NO;

    
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.duration = 1;
    groupAnimation.autoreverses  = YES;
    groupAnimation.repeatCount = 1;
    [groupAnimation setAnimations:[NSArray arrayWithObjects:animation,animation1, nil]];
    [imgaeV1.layer addAnimation:groupAnimation forKey:nil];
}

//组合动画
-(void)startAnimation2
{
    //界限
    CABasicAnimation *boundsAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
    boundsAnimation.fromValue = [NSValue valueWithCGRect: imgaeV1.bounds];
    boundsAnimation.toValue = [NSValue valueWithCGRect:CGRectZero];
    //透明度变化
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    opacityAnimation.toValue = [NSNumber numberWithFloat:0.5];
    
    //位置移动
    CABasicAnimation *animation  = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.fromValue =  [NSValue valueWithCGPoint: imgaeV1.layer.position];
    CGPoint toPoint = imgaeV1.layer.position;
    toPoint.y += 180;
    animation.toValue = [NSValue valueWithCGPoint:toPoint];
    
    //旋转动画
    CABasicAnimation* rotationAnimation =
    [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];//"z"还可以是“x”“y”，表示沿z轴旋转
    rotationAnimation.toValue = [NSNumber numberWithFloat:(2 * M_PI) * 3];
    // 3 is the number of 360 degree rotations
    
    // Make the rotation animation duration slightly less than the other animations to give it the feel
    // that it pauses at its largest scale value
    rotationAnimation.duration = 3.0f;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]; //缓入缓出
    //rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
//    //缩放动画
//    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//    scaleAnimation.fromValue = [NSNumber numberWithFloat:0.0];
//    scaleAnimation.toValue = [NSNumber numberWithFloat:1.0];
//    scaleAnimation.duration = 3.0f;
//    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    //组合动画
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = 3.0f;
    animationGroup.autoreverses = YES;   //是否重播，原动画的倒播
    animationGroup.repeatCount = NSNotFound;//HUGE_VALF;     //HUGE_VALF,源自math.h
    [animationGroup setAnimations:[NSArray arrayWithObjects:rotationAnimation,boundsAnimation,opacityAnimation,animation, nil]];
    
    //将上述两个动画编组
    
    [imgaeV1.layer addAnimation:animationGroup forKey:@"animationGroup"];
}

//永久闪烁的动画
-(void)opacityForever_Animation:(float)time
{
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue=[NSNumber numberWithFloat:1.0];
    animation.toValue=[NSNumber numberWithFloat:0.0];
    animation.autoreverses=YES;
    animation.duration=time;
    animation.repeatCount=FLT_MAX;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    
    [imgaeV1.layer addAnimation:animation forKey:@"opacityForever"];
}
/**************************************************************************/

//有闪烁次数的动画

-(void)opacityTimes_Animation:(float)repeatTimes durTimes:(float)time;
{
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue=[NSNumber numberWithFloat:1.0];
    animation.toValue=[NSNumber numberWithFloat:0.4];
    animation.repeatCount=repeatTimes;
    animation.duration=time;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animation.autoreverses=YES;
    
    [imgaeV1.layer addAnimation:animation forKey:@"opacityTimes"];
    
}

-(void)animateCicleAlongPath
{
    //准备关键帧动画
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.calculationMode = kCAAnimationPaced;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.duration = 5.0f;
    pathAnimation.repeatCount = 200;
    //pathAnimation.autoreverses = YES; //原路返回，而不是从头再来
    //设置动画路径
    //CGPoint endPoint = CGPointMake(310, 450);
    

     /*
    //CGContextAddQuadCurveToPoint 去使用添加一个二次Bezier曲线，
      CGPathAddCurveToPoint        去使用添加一个三次Bezier曲线，
     */
    
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    CGPathMoveToPoint(curvedPath, NULL, 100, 200);
    CGPathAddQuadCurveToPoint(curvedPath, NULL, 200, 60, 300, 200);
    CGPathAddQuadCurveToPoint(curvedPath, NULL, 400, 500, 300, 500);
    CGPathAddQuadCurveToPoint(curvedPath, NULL, 200, 600, 100, 600);
    CGPathAddQuadCurveToPoint(curvedPath, NULL, 400, -100, 100, 200);
    
    //已经有了路径，我们要告诉动画  路径
    pathAnimation.path = curvedPath;
    CGPathRelease(curvedPath);  //这里要手工释放
    
    [imgaeV1.layer addAnimation:pathAnimation forKey:nil];
    
}




@end
