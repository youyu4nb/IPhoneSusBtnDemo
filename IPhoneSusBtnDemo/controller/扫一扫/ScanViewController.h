//
//  ScanViewController.h
//  IPhoneSusBtnDemo
//
//  Created by yjm on 2019/10/22.
//  Copyright © 2019 yjm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ScanViewController : UIViewController
@property (nonatomic, copy) void(^hasScan)(NSString *codeInfo);
@end

NS_ASSUME_NONNULL_END
