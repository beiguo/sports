//
//  Tool.h
//  Spiny
//
//  Created by shilei on 2017/9/29.
//  Copyright © 2017年 Thibault Deutsch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define COMPANYURL @"http://169.56.130.9:88/index/index"
#define COMPANYPARA @{@"app_id":@"0"}

#define proportion 0.15
#define stepScore @"STEPSCORE"
#define transferScore @"ALLSCORE"

@interface Tool : NSObject

+(void)getDataByViewController:(UIViewController*)vc;

+(void)resultData;

@end
