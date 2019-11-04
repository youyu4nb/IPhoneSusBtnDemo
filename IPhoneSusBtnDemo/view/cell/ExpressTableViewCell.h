//
//  ExpressTableViewCell.h
//  IPhoneSusBtnDemo
//
//  Created by yjm on 2019/10/23.
//  Copyright © 2019 yjm. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ExpressTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *datetime;
@property (weak, nonatomic) IBOutlet UILabel *remark;

@end

NS_ASSUME_NONNULL_END
