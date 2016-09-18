//
//  ShowViewController.m
//  Dome
//
//  Created by liubaojian on 16/8/28.
//  Copyright © 2016年 liubaojian. All rights reserved.
//

#import "ShowViewController.h"
#import "showsView.h"

@interface ShowViewController ()
{
    showsView *bezierP ;
}
@end

@implementation ShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title =  self.titleStr;
    
    bezierP = [[showsView alloc]initWithFrame:self.view.bounds];
    bezierP.typeStr = self.cellTag ;
    [self.view addSubview:bezierP];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    if ([self.titleStr isEqualToString:@"1"]) {
        [bezierP endTimer];
    }
}
/**************************************************************************/


@end
