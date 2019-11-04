//
//  WeatherData.h
//  IPhoneSusBtnDemo
//
//  Created by yjm on 2019/10/22.
//  Copyright © 2019 yjm. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WeatherData : NSObject
@property (nonatomic,copy)NSString *date;
@property (nonatomic,copy)NSString *temperature;
@property (nonatomic,copy)NSString *weather;
@property (nonatomic,copy)NSString *direct;
@end

NS_ASSUME_NONNULL_END
