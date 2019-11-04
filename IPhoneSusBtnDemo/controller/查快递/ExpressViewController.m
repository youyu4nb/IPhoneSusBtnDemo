//
//  ExpressViewController.m
//  IPhoneSusBtnDemo
//
//  Created by yjm on 2019/10/22.
//  Copyright © 2019 yjm. All rights reserved.
//

#import "ExpressViewController.h"
#import "AFNetworking.h"
#import "ExpressData.h"
#import "ExpressTableViewCell.h"
#import "Config.h"
#import "RequestUrlString.h"


@interface ExpressViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,retain) NSMutableArray *expresslist;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *company;
@property (weak, nonatomic) IBOutlet UITextField *expressNum;
@property (weak, nonatomic) IBOutlet UILabel *status;

@end

//增加分类,用于将网络请求的json字典串转化为字符串
@implementation NSDictionary (Log)
- (NSString *)jsonString{
    if (self == nil) {
        return nil;
    }
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonDic = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return jsonDic;
}
@end

@implementation ExpressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"查快递";
    [self.tableView registerNib:[UINib nibWithNibName:@"ExpressTableViewCell" bundle:nil] forCellReuseIdentifier:@"ExpressCell"];
    self.tableView.tableFooterView = [[UIView alloc]init];//取出cell的下划线
}

- (IBAction)queryExpress:(id)sender {
    [self post];
    [_company endEditing:YES];
    [_expressNum endEditing:YES];
}

#pragma mark 发送POST请求
- (void)post{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer]; //请求HTTP格式
    manager.responseSerializer = [AFJSONResponseSerializer serializer]; // 响应JSON格式
    
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded;UTF-8" forHTTPHeaderField:@"Content-Type"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json", @"text/javascript", nil];
    
    NSString *url = expressUrl;
    NSDictionary *parameters = @{@"com":self.company.text,
                                 @"no":self.expressNum.text,
                                 @"key":ExpressAppKey};
    
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"uploadProgress %@", uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.expresslist = [NSMutableArray new];//清空expresslist
        //判断请求次数是否用完
        if([responseObject[@"resultcode"] isEqual:@"112"]){
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"难顶了" message:responseObject[@"reason"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"只能溜了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                //响应事件
                NSLog(@"action = %@", action);
            }];
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }else{//如果请求次数没用完
            NSLog(@"请求成功：%@",[responseObject jsonString]);
            NSDictionary *result = responseObject[@"result"];
            NSString *error_code = [NSString stringWithFormat:@"%@",responseObject[@"error_code"]];
            if([error_code isEqualToString:@"0"]){//成功
                NSArray *list = result[@"list"];
                for(NSDictionary *item in list){
                    ExpressData *expressData = [ExpressData new];
                    expressData.datetime = item[@"datetime"];
                    expressData.remark = item[@"remark"];
                    [self.expresslist addObject:expressData];
                }
                [self.tableView reloadData];//刷新数据
            }else{//失败
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"失败" message:responseObject[@"reason"] delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
                [alertView show];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败：%@",error);
    }];
}

#pragma mark UITableViewDelegate
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ExpressTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ExpressCell"];
    ExpressData *expressData = _expresslist[indexPath.row];
    cell.datetime.text = expressData.datetime;
    cell.remark.text = expressData.remark;
    return cell;
}

//设置cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   return self.tableView.frame.size.height/_expresslist.count;
}

//设置行数
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _expresslist.count;
}

@end
