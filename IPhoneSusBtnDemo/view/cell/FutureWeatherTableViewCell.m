//
//  FutureWeatherTableViewCell.m
//  IPhoneSusBtnDemo
//
//  Created by yjm on 2019/10/22.
//  Copyright © 2019 yjm. All rights reserved.
//

#import "FutureWeatherTableViewCell.h"

@implementation FutureWeatherTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setuplayout];
}

//设置边距
- (void)setFrame:(CGRect)frame{
    static CGFloat margin = 10;
    frame.origin.x += margin;
    frame.origin.y += margin;
    frame.size.height -= margin;
    frame.size.width -= 2 * margin;
    [super setFrame:frame];
}

- (void)setuplayout {
    self.contentView.layer.borderWidth = 1.0f;//设置边框
    self.contentView.layer.cornerRadius = 5.0f;//设置圆角
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
