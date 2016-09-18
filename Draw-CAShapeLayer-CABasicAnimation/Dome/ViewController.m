//
//  ViewController.m
//  Dome
//
//  Created by liubaojian on 16/8/27.
//  Copyright © 2016年 liubaojian. All rights reserved.
//

#import "ViewController.h"
#import "ShowViewController.h"


#define HEIGHT                   [UIScreen mainScreen].bounds.size.height
#define WIDTH                    [UIScreen mainScreen].bounds.size.width


@interface ViewController ()
<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *tableV;
    NSArray *ttleArray;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"CAShapeLayer相关及CABasicAnimation动画";
    self.automaticallyAdjustsScrollViewInsets = NO;
    tableV = [[UITableView alloc] initWithFrame:CGRectMake(0,64,WIDTH, HEIGHT-65) style:UITableViewStylePlain];
    tableV.backgroundColor=[UIColor whiteColor];
    tableV.delegate=self;
    tableV.dataSource=self;
    tableV.scrollEnabled=YES;
    tableV.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:tableV];

    ttleArray = @[@"裁出一个尖角",
                  @"模拟音量大小跳动",
                  @"圆形进度条",
                  @"Layer操作",
                  @"中心位置移动",
                  @"横向纵向移动",
                  @"旋转，缩放，移动，组合动画",
                  @"永久闪烁的动画",
                  @"有闪烁次数的动画",
                  @"关键帧动画（多设置个关键点）"];
    
    //在沙盒中生成一个PDF文件
    [self drawContentToPdfContext];
    tableV.tableFooterView = [UIView new];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return ttleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"firstCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = ttleArray[indexPath.row];
    cell.tag = indexPath.row;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    ShowViewController *showVC = [[ShowViewController alloc]init];
    showVC.cellTag = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    showVC.titleStr = ttleArray[indexPath.row];
    [self.navigationController pushViewController:showVC animated:YES];
    
}

//生成一个PDF
-(void)drawContentToPdfContext{
    
    //沙盒路径（也就是我们应用程序文件运行的路径）
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[[paths firstObject] stringByAppendingPathComponent:@"myPDF.pdf"];
    NSLog(@"%@",path);
    //启用pdf图形上下文
    /**
     path:保存路径
     bounds:pdf文档大小，如果设置为CGRectZero则使用默认值：612*792
     pageInfo:页面设置,为nil则不设置任何信息
     */
    UIGraphicsBeginPDFContextToFile(path,CGRectZero,[NSDictionary dictionaryWithObjectsAndKeys:@"Kenshin Cui",kCGPDFContextAuthor, nil]);
    
    //由于pdf文档是分页的，所以首先要创建一页画布供我们绘制
    UIGraphicsBeginPDFPage();
    
    NSString *title=@"Welcome to Apple Support";
    NSMutableParagraphStyle *style=[[NSMutableParagraphStyle alloc]init];
    NSTextAlignment align=NSTextAlignmentCenter;
    style.alignment=align;
    [title drawInRect:CGRectMake(26, 20, 300, 50) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSParagraphStyleAttributeName:style}];
    NSString *content=@"Learn about Apple products, view online manuals, get the latest downloads, and more. Connect with other Apple users, or get service, support, and professional advice from Apple.";
    NSMutableParagraphStyle *style2=[[NSMutableParagraphStyle alloc]init];
    style2.alignment=NSTextAlignmentLeft;
    //    style2.firstLineHeadIndent=20;
    [content drawInRect:CGRectMake(26, 56, 300, 255) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor grayColor],NSParagraphStyleAttributeName:style2}];
    
    UIImage *image=[UIImage imageNamed:@"IMG_1102.JPG"];
    [image drawInRect:CGRectMake(316, 20, 290, 305)];
    
    //创建新的一页继续绘制其他内容
    UIGraphicsBeginPDFPage();
    UIImage *image3=[UIImage imageNamed:@"IMG_1102.JPG"];
    [image3 drawInRect:CGRectMake(6, 20, 600, 629)];
    
    //结束pdf上下文
    UIGraphicsEndPDFContext();
    
    
}


@end
