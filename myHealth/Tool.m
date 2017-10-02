//
//  Tool.m
//  Spiny
//
//  Created by shilei on 2017/9/29.
//  Copyright © 2017年 Thibault Deutsch. All rights reserved.
//

#import "Tool.h"
#import <AFNetworking/AFNetworking.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "webViewTabBarController.h"


@implementation Tool

+(void)getDataByViewController:(UIViewController*)vc{
    [SVProgressHUD showWithStatus:@"加载中"];
    [self resultData];
}

+(void)resultData{
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain",@"text/html", nil];
    
    
    [manager POST:COMPANYURL parameters:COMPANYPARA progress:^(NSProgress * _Nonnull uploadProgress) {} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [SVProgressHUD dismiss];
        if (responseObject == NULL) {
            
            [[UIApplication sharedApplication].delegate window].rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"firstVC"];
        } else {
            NSUserDefaults *de = [NSUserDefaults standardUserDefaults];
            [de setObject:responseObject[@"data"] forKey:@"responseObject"];
            [de synchronize];
            webViewTabBarController *web=[[webViewTabBarController alloc] init];
            [[UIApplication sharedApplication].delegate window].rootViewController = web;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"--------------error-------------");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self resultData];
            
        });
    }];
    
}

@end
