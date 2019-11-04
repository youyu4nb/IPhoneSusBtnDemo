//
//  LocateViewController.m
//  IPhoneSusBtnDemo
//
//  Created by yjm on 2019/10/22.
//  Copyright © 2019 yjm. All rights reserved.
//

#import "LocateViewController.h"

@interface LocateViewController ()
{
    AMapLocationManager *locationManager;
    CLLocationCoordinate2D myCoordinate;
}
@end

@implementation LocateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"高德地图定位";
    [self initMap];
    [self location];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark 初始化地图
- (void)initMap{
    [AMapServices sharedServices].enableHTTPS = YES;
    
    _mapView = [[MAMapView alloc]initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication]statusBarFrame].size.height, self.view.frame.size.width, self.view.frame.size.height - (self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication]statusBarFrame].size.height))];
    
    //delegate
    [_mapView setDelegate:self];
    
    //是否显示比例尺
    [_mapView setShowsScale:YES];
    
    //设置缩放级别
    [_mapView setZoomLevel:15];
    
    //是否显示用户位置
    _mapView.showsUserLocation = YES;
    
    [self location];
    
    [self.view addSubview:_mapView];
}

#pragma mark 定位功能
- (void)location{
    
    if([CLLocationManager locationServicesEnabled]){
        
        AMapLocationManager *locationManager = [[AMapLocationManager alloc]init];
        
        [locationManager setDelegate:self];
        
        //是否允许后台定位。默认为NO。只在iOS 9.0及之后起作用。设置为YES的时候必须保证 Background Modes 中的 Location updates 处于选中状态，否则会抛出异常。由于iOS系统限制，需要在定位未开始之前或定位停止之后，修改该属性的值才会有效果。
        [locationManager setAllowsBackgroundLocationUpdates:NO];
        
        //指定定位是否会被系统自动暂停。默认为NO。
        [locationManager setPausesLocationUpdatesAutomatically:NO];
        
        //设定定位的最小更新距离。单位米，默认为 kCLDistanceFilterNone，表示只要检测到设备位置发生变化就会更新位置信息
        [locationManager setDistanceFilter:20];
        
        //设定期望的定位精度。单位米，默认为 kCLLocationAccuracyBest
        [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        
        //开始定位服务
        [locationManager startUpdatingLocation];
    }
}

#pragma mark 定位代理方法
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location{
    
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode{
    //获取定位位置
    myCoordinate.latitude = location.coordinate.latitude;
    myCoordinate.longitude = location.coordinate.longitude;
    NSLog(@"latitude = %f , longtitude = %f",myCoordinate.latitude,myCoordinate.longitude);
}

#pragma mark 地图代理方法
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    
    [userLocation setTitle:@"现在位置"];
    [self.mapView setCenterCoordinate:userLocation.coordinate animated:YES];
}


@end
