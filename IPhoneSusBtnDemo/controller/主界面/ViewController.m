//
//  ViewController.m
//  IPhoneSusBtnDemo
//
//  Created by yjm on 2019/10/21.
//  Copyright © 2019 yjm. All rights reserved.
//

#import "ViewController.h"
#import "ButtonMenu.h"
#import "WeatherViewController.h"
#import "LocateViewController.h"
#import "ScanViewController.h"
#import "ExpressViewController.h"
#import "OtherViewController.h"

#define SHOWMENUTIME 0.3 //菜单动画速度
typedef NS_ENUM(NSUInteger, GradientType) {
    GradientTypeTopToBottom = 0,//从上到下
    GradientTypeLeftToRight = 1,//从左到右
    GradientTypeLeftTopToRightBottom = 2,//从左上到右下
    GradientTypeLeftBottomToRightTop = 3,//从左下到右上
};

@interface ViewController ()<ButtonMenuDelegate,UIAlertViewDelegate>
{
    ButtonMenu *btn;
    __weak IBOutlet UIImageView *imageView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self createByCAGradientLayer:[UIColor blackColor] endColor:[UIColor whiteColor] layerFrame:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height/2) direction:0];
//    [self createByCAGradientLayer:[UIColor whiteColor] endColor:[UIColor blackColor] layerFrame:CGRectMake(0, imageView.frame.size.height/2, imageView.frame.size.width, imageView.frame.size.height/2) direction:0];
    [self createByCAGradientLayer:[UIColor blackColor] endColor:[UIColor whiteColor] layerFrame:imageView.frame direction:3];//从左下到右上由黑到白的渐变色背景
    btn = [[ButtonMenu alloc] initWithFrame:CGRectMake(0, 60, 0, 0)];
    btn.delegate = self;//设置代理
    [self.view addSubview:btn];

}
- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//非悬浮球和菜单区域的事件
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if(btn.isShowMenu){
        btn.isShowMenu = !btn.isShowMenu;
        [btn showMenu:btn.isShowMenu time:SHOWMENUTIME];
        return;
    }
}

#pragma mark 跳转代理方法
- (void)jumpVC:(nonnull UIButton *)btn {
    self.navigationController.navigationBarHidden = NO;
    UIBarButtonItem *backItem = [UIBarButtonItem new];
    backItem.tintColor = [UIColor blackColor];
    backItem.title = @"返回";
    WeatherViewController *wvc = [[WeatherViewController alloc] init];
    ExpressViewController *evc = [[ExpressViewController alloc] init];
    ScanViewController *svc = [[ScanViewController alloc] init];
    LocateViewController *lvc = [[LocateViewController alloc] init];
    OtherViewController *ovc = [[OtherViewController alloc] init];
    self.navigationItem.backBarButtonItem = backItem;
    switch (btn.tag) {
        case 0:
            NSLog(@"点击了查天气按钮");
            [self.navigationController pushViewController:wvc animated:YES];
            break;
        case 1:
            NSLog(@"点击了查快递按钮");
            [self.navigationController pushViewController:evc animated:YES];
            break;
        case 2:
        {
            NSLog(@"点击了扫一扫按钮");
            [self.navigationController pushViewController:svc animated:YES];
            svc.hasScan = ^(NSString *codeInfo) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"二维码内容" message:codeInfo delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
                    [alertView show];
                alertView.delegate = self;
            };
        }
            break;
        case 3:
            NSLog(@"点击了高德地图定位按钮");
            [self.navigationController pushViewController:lvc animated:YES];
            break;
        case 4:
            NSLog(@"点击了其他按钮");
            [self.navigationController pushViewController:ovc animated:YES];
            break;
        default:
            break;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController popViewControllerAnimated:true];
}

//渐变色背景
-(void)createByCAGradientLayer:(UIColor *)startColor endColor:(UIColor *)endColor layerFrame:(CGRect)frame direction:(GradientType)direction{
    CAGradientLayer *layer = [CAGradientLayer new];
    //存放渐变的颜色的数组
    layer.colors = @[(__bridge id)startColor.CGColor, (__bridge id)endColor.CGColor];
    //起点和终点表示的坐标系位置，(0,0)表示左上角，(1,1)表示右下角
    switch (direction) {
        case GradientTypeTopToBottom://从上到下渐变
            layer.startPoint = CGPointMake(0.0, 0.0);
            layer.endPoint = CGPointMake(0.0, 1.0);
            break;
        case GradientTypeLeftToRight://从左到右渐变
            layer.startPoint = CGPointMake(0.0, 0.0);
            layer.endPoint = CGPointMake(1.0, 0.0);
            break;
        case GradientTypeLeftTopToRightBottom://从左上到右下渐变
            layer.startPoint = CGPointMake(0.0, 0.0);
            layer.endPoint = CGPointMake(1.0, 1.0);
            break;
        case GradientTypeLeftBottomToRightTop://从左下到右上渐变
            layer.startPoint = CGPointMake(0.0, 1.0);
            layer.endPoint = CGPointMake(1.0, 0.0);
            break;
        default:
            break;
    }
    layer.frame = frame;
    [self.view.layer addSublayer:layer];
}

@end
