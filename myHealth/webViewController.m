//
//  webViewController.m
//  澳门娱乐玩法介绍BBIN-AG
//
//  Created by 二哈 on 17/4/8.
//  Copyright © 2017年 二哈. All rights reserved.
//

#import "webViewController.h"
#import "Masonry.h"
#import "SVProgressHUD.h"
// UIScreen width.
#define  LL_ScreenWidth   [UIScreen mainScreen].bounds.size.width

// UIScreen height.
#define  LL_ScreenHeight  [UIScreen mainScreen].bounds.size.height
// iPhone X
#define  LL_iPhoneX (LL_ScreenWidth == 375.f && LL_ScreenHeight == 812.f ? YES : NO)

// Status bar height.
#define  LL_StatusBarHeight      (LL_iPhoneX ? 44.f : 0)

// Navigation bar height.
#define  LL_NavigationBarHeight  44.f

// Tabbar height.
#define  LL_TabbarHeight         (LL_iPhoneX ? (49.f+34.f) : 49.f)

// Tabbar safe bottom margin.
#define  LL_TabbarSafeBottomMargin         (LL_iPhoneX ? 34.f : 0.f)

// Status bar & navigation bar height.
#define  LL_StatusBarAndNavigationBarHeight  (LL_iPhoneX ? 88.f : 64.f)

#define LL_ViewSafeAreInsets(view) ({UIEdgeInsets insets; if(@available(iOS 11.0, *)) {insets = view.safeAreaInsets;} else {insets = UIEdgeInsetsZero;} insets;})
#define kMainBoundsHeight   ([UIScreen mainScreen].bounds).size.height //屏幕的高度
#define kMainBoundsWidth    ([UIScreen mainScreen].bounds).size.width //屏幕的宽度
@interface webViewController ()<UIWebViewDelegate>{
    UIWebView *_webView;
}
@property (nonatomic ,strong)NSString *url;
@end

@implementation webViewController


- (void)viewWillLayoutSubviews {
    [self shouldRotateToOrientation:(UIDeviceOrientation)[UIApplication sharedApplication].statusBarOrientation];
    
}

-(void)shouldRotateToOrientation:(UIDeviceOrientation)orientation {
    if (orientation == UIDeviceOrientationPortrait ||orientation ==
        UIDeviceOrientationPortraitUpsideDown) { // 竖屏
        NSLog(@"现在是竖屏");
        self.tabBarController.tabBar.hidden = NO;
        [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(LL_StatusBarHeight);
            make.bottom.mas_equalTo(-LL_TabbarHeight);
        }];
        [self hideTabBar:NO];
        
    } else { // 横屏
        NSLog(@"现在是横屏");
        self.tabBarController.tabBar.hidden = YES;
        
        [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        
        [self hideTabBar:YES];
    }
}

#pragma mark 隐藏tabbar
- (void) hideTabBar:(BOOL) hidden{
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0];
    
    for(UIView *view in self.tabBarController.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {   //tabbar
            if (hidden) {
                //
            } else {
                [view setFrame:CGRectMake(0, kMainBoundsHeight-LL_TabbarHeight, kMainBoundsWidth, LL_TabbarHeight)];
            }
        }
        else
        {
            //view
            if (hidden) {
                [view setFrame:CGRectMake(0, 0, kMainBoundsWidth, kMainBoundsHeight+LL_TabbarHeight)];
            } else {
                [view setFrame:CGRectMake(0, LL_StatusBarHeight, kMainBoundsWidth, kMainBoundsHeight)];
            }
        }
    }
    
    [UIView commitAnimations];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    _webView = [[UIWebView alloc] init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _webView.opaque = NO;//去掉加载webview出现的黑边
    _webView.scrollView.backgroundColor = [UIColor whiteColor];
    //让网页适配屏幕的大小
    _webView.scalesPageToFit = YES;
    //    禁用拖拽时的反弹效果
    [(UIScrollView *)[[_webView  subviews]firstObject] setBounces:NO];
    _webView.delegate = self;
    _webView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_webView];

    
    NSUserDefaults *de = [NSUserDefaults standardUserDefaults];
    NSDictionary*data = [de objectForKey:@"responseObject"];
    
    NSString *userAgent = [_webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    userAgent = [userAgent stringByAppendingString:@" Version/7.0 Safari/9537.53"];
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent": userAgent}];
    
    if ([[[[NSUserDefaults standardUserDefaults]dictionaryRepresentation]allKeys]containsObject:@"cookie"]) {
        NSArray *cookies =[[NSUserDefaults standardUserDefaults]  objectForKey:@"cookie"];
        NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
        [cookieProperties setObject:[cookies objectAtIndex:0] forKey:NSHTTPCookieName];
        [cookieProperties setObject:[cookies objectAtIndex:1] forKey:NSHTTPCookieValue];
        [cookieProperties setObject:[cookies objectAtIndex:3] forKey:NSHTTPCookieDomain];
        [cookieProperties setObject:[cookies objectAtIndex:4] forKey:NSHTTPCookiePath];
        NSHTTPCookie *cookieuser = [NSHTTPCookie cookieWithProperties:cookieProperties];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage]  setCookie:cookieuser];
    }
    
    //转义网址
    NSString *encodedString=[[data objectForKey:@"url"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *weburl = [NSURL URLWithString:encodedString];
    NSURLRequest *requst = [NSURLRequest requestWithURL:weburl];
    _webView.dataDetectorTypes = UIDataDetectorTypeAll;
    [_webView loadRequest:requst];
    
    [SVProgressHUD showWithStatus:@"加载中"];
    
}
#pragma mark -webView代理

//开始加载的时候调用
- (void)webViewDidStartLoad:(UIWebView *)webView {
     [SVProgressHUD dismiss];
    
}

//加载完成的时候调用
- (void)webViewDidFinishLoad:(UIWebView *)webView {
     [SVProgressHUD dismiss];
    for (NSHTTPCookie * cookie in [[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies] copy]) {
        if ([cookie isKindOfClass:[NSHTTPCookie class]])
        {
            if ([cookie.name isEqualToString:@"PHPSESSID"]) {
                NSNumber *sessionOnly = [NSNumber numberWithBool:cookie.sessionOnly];
                NSNumber *isSecure = [NSNumber numberWithBool:cookie.isSecure];
                NSArray *cookies = [NSArray arrayWithObjects:cookie.name, cookie.value, sessionOnly, cookie.domain, cookie.path, isSecure, nil];
                [[NSUserDefaults standardUserDefaults] setObject:cookies forKey:@"cookie"];
                break;
            }
        }
    }
    
}
//加载失败
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
     [SVProgressHUD dismiss];

    // 如果是被取消，什么也不干(如果不加这句会重复请求,报-999错误)
    if([error code] == NSURLErrorCancelled)  {
        return;
    } else {
        [SVProgressHUD showErrorWithStatus:@"服务器错误,请稍后重试"];
        NSLog(@"%@",error);
    }
}

#pragma mark -五个代理方法
//首页
-(void)homePage {
    
    
    NSUserDefaults *de = [NSUserDefaults standardUserDefaults];
    NSDictionary*data = [de objectForKey:@"responseObject"];
    
    //转义网址
    NSString *encodedString=[[data objectForKey:@"url"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *weburl = [NSURL URLWithString:encodedString];
    NSURLRequest *requst = [NSURLRequest requestWithURL:weburl];
    _webView.dataDetectorTypes = UIDataDetectorTypeAll;
    [_webView loadRequest:requst];
    
}

//前进
-(void)goforward {
    [_webView goForward];
}
//后退
-(void)goback {
    [_webView goBack];
}
//刷新
-(void)reload {
    [_webView reload];
}
//退出
-(void)exitApp{
    
    
    UIAlertController* alertVC = [UIAlertController alertControllerWithTitle:@"退出应用" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        exit(0);
    }];
    
    [alertVC addAction:cancle];
    [alertVC addAction:ok];
    
    [self presentViewController:alertVC animated:true completion:nil];
    
    /*
    ScottAlertView *alertView = [ScottAlertView alertViewWithTitle:@"退出应用" message:@""];
    
    [alertView addAction:[ScottAlertAction actionWithTitle:@"取消" style:ScottAlertActionStyleCancel handler:^(ScottAlertAction *action) {
   
    }]];
    
    [alertView addAction:[ScottAlertAction actionWithTitle:@"确认" style:ScottAlertActionStyleDestructive handler:^(ScottAlertAction *action) {
        [UIView beginAnimations:@"exitApplication" context:nil];
        
        [UIView setAnimationDuration:0.5];
        
        [UIView setAnimationDelegate:self];
        
        // [UIView setAnimationTransition:UIViewAnimationCurveEaseOut forView:self.view.window cache:NO];
        UIWindow *window = [[UIApplication sharedApplication].delegate window];
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:window cache:NO];
        
        [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
        window.bounds = CGRectMake(0, 0, 0, 0);
        
        [UIView commitAnimations];
    }]];
    
    ScottAlertViewController * alertCon = [ScottAlertViewController alertControllerWithAlertView:alertView preferredStyle:ScottAlertControllerStyleAlert transitionAnimationStyle:ScottAlertTransitionStyleDropDown];
    alertCon.tapBackgroundDismissEnable = YES;
    [self presentViewController:alertCon animated:YES completion:nil];
    
     */
}

- (void)animationFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    
    if ([animationID compare:@"exitApplication"] == 0) {
        exit(0);
    }
}


#pragma mark -- 需要设置全局支持旋转方向，然后重写下面三个方法可以让当前页面支持多个方向
// 是否支持自动转屏
- (BOOL)shouldAutorotate {
    return YES;
}
// 支持哪些屏幕方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}
// 默认的屏幕方向（当前ViewController必须是通过模态出来的UIViewController（模态带导航的无效）方式展现出来的，才会调用这个方法）
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}



@end
