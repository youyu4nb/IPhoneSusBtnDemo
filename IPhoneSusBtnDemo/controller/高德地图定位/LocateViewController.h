//
//  LocateViewController.h
//  IPhoneSusBtnDemo
//
//  Created by yjm on 2019/10/22.
//  Copyright © 2019 yjm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface LocateViewController : UIViewController<AMapLocationManagerDelegate,MAMapViewDelegate>
@property (nonatomic,strong)MAMapView *mapView;
@end

NS_ASSUME_NONNULL_END
