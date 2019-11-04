//
//  ButtonMenu.m
//  IPhoneSusBtnDemo
//
//  Created by yjm on 2019/10/21.
//  Copyright © 2019 yjm. All rights reserved.
//

#import "ButtonMenu.h"
#import "WeatherViewController.h"
#import "Config.h"


//用于标注按钮最终移动位置的枚举
typedef NS_ENUM (NSUInteger, SDLocationTag) {
    SDLocationTag_Top = 1,
    SDLocationTag_Left,
    SDLocationTag_Bottom,
    SDLocationTag_Right
};

@interface ButtonMenu ()
{
    NSMutableArray *buttonList;//按钮数组
    NSArray *buttonImageList;//按钮图片数组
    
    UIImageView * _buttonViewImage;//悬浮球
    UIView * _buttonViewMenu;//弹出的菜单
    
    BOOL _isLeftView;//是否在左半边
    BOOL _isBtnMoving;//悬浮球是否在移动
    
    SDLocationTag _locationTag;
    float X;
    float Y;
    
}
@end

@implementation ButtonMenu

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, BTNWIDTH, BTNWIDTH)];
    if (self) {
        _isLeftView = frame.origin.x <= [self superview].frame.size.width / 2;
        [self createUI];
    }
    return self;
}

//创建 UI
- (void)createUI{
    _isShowMenu = NO;
    X = self.center.x;
    Y = self.center.y;
    _buttonViewImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, BTNWIDTH, BTNWIDTH)];
    _buttonViewImage.alpha = BTNALPHA;
    [self setButtonImageWithIsChick:NO];
    
    //创建目录条
    _buttonViewMenu = [[UIView alloc] init];
    _buttonViewMenu.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:MENUALPHA];
    [_buttonViewMenu setClipsToBounds:YES];
    [_buttonViewMenu setHidden:YES];
    NSLog(@"菜单宽度为：%f",MENULENGTH);
    NSLog(@"悬浮球宽度为：%f",BTNWIDTH);
    
    [self addSubview:_buttonViewMenu];//添加菜单
    [self addSubview:_buttonViewImage];//添加悬浮球
    [self addButtonForMenu];
}

//设置悬浮球的图片和点击时的透明度变化
- (void)setButtonImageWithIsChick:(BOOL)isChick{
    NSString * picName = @"IPhoneBtnB";
    if (isChick) {
        _buttonViewImage.alpha = BTNCLICKALPHA;
    }
    UIImage * image = [UIImage imageNamed:picName];
    [_buttonViewImage setImage:image];
}

#pragma mark 触摸事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    _isBtnMoving = NO;//悬浮球没有移动
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (_isShowMenu) {
        return;
    }
    _isBtnMoving = YES;//悬浮球在移动
    _buttonViewImage.alpha = BTNCLICKALPHA;
    UITouch * touch = [touches anyObject];
    CGPoint move = [touch locationInView:[self superview]];
    //防止移动出界
    if (move.x - BTNWIDTH/2 < 0.f ||
        move.x + BTNWIDTH/2 > [self superview].frame.size.width ||
        move.y - BTNWIDTH/2 < 20.f ||
        move.y + BTNWIDTH/2 > [self superview].frame.size.height)
    {
        return;
    }
    [self setCenter:move];
    _isLeftView = self.frame.origin.x < ([self superview].frame.size.width - BTNWIDTH / 2) / 2;
}

//悬浮球和菜单区域的事件
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (_isBtnMoving == NO) {//如果悬浮球没有移动
        [self setButtonImageWithIsChick:!_isShowMenu];
    }
    if (!_isBtnMoving) {
        _isShowMenu = !_isShowMenu;
        [self showMenu:_isShowMenu time:SHOWMENUTIME];
        return;
    }
    
    //悬浮球自动附着
    [self computeOfLocation:^{
        [self setButtonImageWithIsChick:NO];
        if(_isLeftView){
            NSLog(@"悬浮球附着左边");
        }else{
            NSLog(@"悬浮球附着右边");
        }
        _isBtnMoving  = NO;
        _buttonViewImage.alpha = BTNALPHA;
    }];
}

#pragma mark 是否弹出菜单及自动附着边界
//是否弹出以及弹出时间
- (void)showMenu:(BOOL)isShow time:(float)time{
    self.userInteractionEnabled = NO;//弹出后关闭触摸事件
    
    //设置圆角
    _buttonViewMenu.layer.cornerRadius = 20;
    _buttonViewMenu.layer.masksToBounds = YES;
    //弹出
    if (isShow) {
        _buttonViewImage.hidden = YES;
        [_buttonViewMenu setHidden:NO];
        [UIView animateWithDuration:time animations:^{
            [_buttonViewMenu setFrame:CGRectMake(0, 0, MENULENGTH, MENULENGTH)];
            [self setFrame:CGRectMake(MENULENGTH/6, MENULENGTH/2, MENULENGTH, MENULENGTH)];
        } completion:^(BOOL finished) {
            self.userInteractionEnabled = YES;
        }];
        NSLog(@"菜单弹出");
    //弹回
    } else {
        [self setButtonImageWithIsChick:NO];
        [UIView animateWithDuration:time animations:^{
            [_buttonViewMenu setFrame:CGRectMake(0, 0, BTNWIDTH, BTNWIDTH)];
            [self setFrame:CGRectMake(X - BTNWIDTH/2, Y - BTNWIDTH/2, BTNWIDTH, BTNWIDTH)];
        } completion:^(BOOL finished) {
            self.userInteractionEnabled = YES;
            [_buttonViewMenu setHidden:YES];
            _buttonViewImage.alpha = BTNALPHA;
            _buttonViewImage.hidden = NO;
        }];
        NSLog(@"菜单弹回");
    }
}

//自动附着边界
- (void)computeOfLocation:(void(^)())complete{
    
    float x = self.center.x;
    float y = self.center.y;
    float w = self.frame.size.width;
    float h = self.frame.size.height;
    
    CGPoint s = CGPointZero;
    s.x = x;
    s.y = y;
    
    float superWidth = [self superview].frame.size.width;
    float superHeight = [self  superview].frame.size.height;
    
    //判断悬浮球靠左还是靠右
    if (x < superWidth / 2) {//左边
        _locationTag = SDLocationTag_Left;
        _isLeftView = YES;
    } else {//右边
        _locationTag = SDLocationTag_Right;
        _isLeftView = NO;
    }
    switch (_locationTag) {
        case SDLocationTag_Top:
            s.y = 0 + w/2 + 20;
            break;
        case SDLocationTag_Left:
            s.x = 0 + h/2;
            break;
        case SDLocationTag_Bottom:
            s.y = superHeight - h / 2;
            break;
        case SDLocationTag_Right:
            s.x = superWidth - w / 2;
            break;
    }
    X = s.x;
    Y = s.y;
    [UIView animateWithDuration:0.1
                     animations:^{
                         [self setCenter:s];
                     }
                     completion:^(BOOL finished){
                         complete();
                     }];
}

#pragma mark 在按钮菜单上添加按钮
//初始化buttonList
- (void)initButtonList{
    buttonList = [[NSMutableArray alloc] init];
    buttonImageList = @[@"weather",@"express",@"scan",@"locate",@"other"];
    UIButton * weatherBtn = [[UIButton alloc] init];
    UIButton * expressBtn = [[UIButton alloc] init];
    UIButton * scanBtn = [[UIButton alloc] init];
    UIButton * locateBtn = [[UIButton alloc] init];
    UIButton * otherBtn = [[UIButton alloc] init];
    [buttonList addObject:weatherBtn];
    [buttonList addObject:expressBtn];
    [buttonList addObject:scanBtn];
    [buttonList addObject:locateBtn];
    //[buttonList addObject:otherBtn];
}

//设置按钮属性和位置
- (void)addButtonForMenu{
    [self initButtonList];
    for(int i = 0; i < buttonList.count; i++){
        UIButton *button = buttonList[i];
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        [button setImage:[UIImage imageNamed:buttonImageList[i]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickWithButton:) forControlEvents:UIControlEventTouchDown];
        static double btnX,btnY;
        int duAngle = i*(360/buttonList.count);//度数
        double angle;//角度
        if(duAngle >= 0&&duAngle < 90){//第一象限
            angle = (duAngle * 3.14159256)/180;
            btnX = 0.5 * MENULENGTH * (1 + sin(angle));
            btnY = 0.5 * MENULENGTH * (1 - cos(angle));
            if(duAngle == 0){
                btnX -= ITEMWIDTH/2;
                btnY += ITEMWIDTH/2;
            }else{
                btnX -= ITEMWIDTH*3/2;
            }
        }else if(duAngle >= 90&&duAngle < 180){//第二象限
            duAngle = duAngle - 90;
            angle = (duAngle * 3.14159256)/180;
            btnX = 0.5 * MENULENGTH * (1 + cos(angle));
            btnY = 0.5 * MENULENGTH * (1 + sin(angle));
            if(duAngle == 0){
                btnX -= ITEMWIDTH*3/2;
                btnY -= ITEMWIDTH/2;
            }else{
                btnX -= ITEMWIDTH;
                btnY -= ITEMWIDTH;
            }
        }else if(duAngle >= 180&&duAngle < 270){//第三象限
            duAngle = duAngle - 180;
            angle = (duAngle * 3.14159256)/180;
            btnX = 0.5 * MENULENGTH * (1 - sin(angle));
            btnY = 0.5 * MENULENGTH * (1 + cos(angle));
            if(duAngle == 0){
                btnX -= ITEMWIDTH/2;
                btnY -= ITEMWIDTH*3/2;
            }else{
                btnY -= ITEMWIDTH;
            }
        }else if(duAngle >= 270&&duAngle < 360){//第四象限
            duAngle = duAngle - 270;
            angle = (duAngle * 3.14159256)/180;
            btnX = 0.5 * MENULENGTH * (1 - cos(angle));
            btnY = 0.5 * MENULENGTH * (1 - sin(angle));
            if(duAngle == 0){
                btnX += ITEMWIDTH/2;
                btnY -= ITEMWIDTH/2;
            }else{
                btnX += ITEMWIDTH/2;
            }
        }
        NSLog(@"第%i个按钮坐标，x:%.2f,y:%.2f",i+1,btnX,btnY);
        [button setFrame:CGRectMake(btnX, btnY, ITEMWIDTH, ITEMWIDTH)];
        [_buttonViewMenu addSubview:button];
    }
}

#pragma mark 按钮的点击事件
- (void)clickWithButton:(UIButton *)btn{
    if (self.delegate && [self.delegate respondsToSelector:@selector(jumpVC:)]) {
        [self.delegate jumpVC:btn];
    }
}

@end

