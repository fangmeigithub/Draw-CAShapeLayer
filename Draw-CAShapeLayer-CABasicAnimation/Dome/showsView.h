//
//  BezierPathView.h
//  Dome
//
//  Created by liubaojian on 16/8/27.
//  Copyright © 2016年 liubaojian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface showsView : UIView
{
    UIImage* clipImage;
    
    CAShapeLayer *changeLayer;
    NSTimer *time1;
    
    UIImageView *imgaeV1;
    
    NSString *_typeStr;
}
@property(copy,nonatomic)NSString *typeStr;

- (void)endTimer;
@end
