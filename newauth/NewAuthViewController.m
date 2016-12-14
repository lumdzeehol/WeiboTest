//
//  NewAuthViewController.m
//  newauth
//
//  Created by lumdzeehol on 16/11/23.
//  Copyright © 2016年 lumdzeehol. All rights reserved.
//

#import "NewAuthViewController.h"
#import "AFNetworking.h"

@interface NewAuthViewController ()<UIWebViewDelegate>

@property (nonatomic,strong) UIWebView *webView;

@end

@implementation NewAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [super viewDidLoad];
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://api.weibo.com/oauth2/authorize?client_id=1616196730&redirect_uri=https://api.weibo.com/oauth2/default.html&response_type=code"]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
    NSString *url = webView.request.URL.absoluteString;
    if ([url hasPrefix:@"https://api.weibo.com/oauth2/default.html?"]) {
        NSRange codePos = [url rangeOfString:@"code="];
        NSRange codeRange = NSMakeRange(codePos.location + codePos.length, url.length - codePos.location - codePos.length);
        NSString *code = [url substringWithRange:codeRange];
        [defaults setObject:code forKey:@"code"];
        NSMutableString *requestStr = [[NSMutableString alloc] initWithString:@"https://api.weibo.com/oauth2/access_token?client_id=1616196730&client_secret=577c408bf9e60710f4ee897db4118b01&redirect_uri=https://api.weibo.com/oauth2/default.html&grant_type=authorization_code&code="];
        [requestStr appendString:code];
        
        [requestStr dataUsingEncoding:NSUTF8StringEncoding];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager POST:requestStr parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
            ;
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"!!!!%@",responseObject[@"access_token"]);
            [defaults setObject:responseObject[@"access_token"] forKey:@"access_token"];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"!!!!!!%@",error);
        }];
    }
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
