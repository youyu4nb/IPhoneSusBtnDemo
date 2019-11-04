//
//  ButtonMenu.h
//  IPhoneSusBtnDemo
//
//  Created by yjm on 2019/10/21.
//  Copyright © 2019 yjm. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol ButtonMenuDelegate <NSObject>
- (void)jumpVC:(UIButton*)btn;
@end

@interface ButtonMenu : UIView
@property (nonatomic) BOOL isShowMenu;//是否展示菜单
@property (nonatomic, weak) id<ButtonMenuDelegate> delegate;

/**
 *  初始化方法
 *  @param frame 设置浮动按钮的初始位置，仅位置有效，大小无效
 */
- (instancetype)initWithFrame:(CGRect)frame;
- (void)showMenu:(BOOL)isShow time:(float)time;
@end

NS_ASSUME_NONNULL_END
