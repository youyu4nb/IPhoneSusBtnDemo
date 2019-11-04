//
//  ScanViewController.m
//  IPhoneSusBtnDemo
//
//  Created by yjm on 2019/10/22.
//  Copyright © 2019 yjm. All rights reserved.
//

#import "ScanViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ScanViewController ()
@property (nonatomic, strong) AVCaptureSession *session;
@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"扫一扫";
    [self getRequest];
}

//请求相机权限
- (void)getRequest {
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (granted) {
                [self setupScan];
            } else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"没有权限" message:@"" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
                [alertView show];
            }
        });
    }];
}

//扫描二维码
- (void)setupScan {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc]init];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    self.session = [[AVCaptureSession alloc]init];
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    
    if(input != nil){
        NSLog(@"正在扫描。。。");
        [self.session addInput:input];
        [self.session addOutput:output];
        
        //二维码
        output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode];
        
        //条形码
        //    output.metadataObjectTypes=@[AVMetadataObjectTypeEAN13Code,
        //                                     AVMetadataObjectTypeEAN8Code,
        //                                     AVMetadataObjectTypeUPCECode,
        //                                     AVMetadataObjectTypeCode39Code,
        //                                     AVMetadataObjectTypeCode39Mod43Code,
        //                                     AVMetadataObjectTypeCode93Code,
        //                                     AVMetadataObjectTypeCode128Code,
        //                                     AVMetadataObjectTypePDF417Code];
        
        
        AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
        layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        layer.frame = self.view.layer.bounds;
        [self.view.layer insertSublayer:layer atIndex:10003];
        [self.session startRunning];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请使用真机" message:@"" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
        [alertView show];
    }
}

//扫描结果
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    if (metadataObjects.count > 0) {//若扫描成功
        AVMetadataMachineReadableCodeObject *metadataObject = metadataObjects[0];
        NSString *result = metadataObject.stringValue;
        
        self.hasScan(result);//显示结果
        [self.session stopRunning];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
