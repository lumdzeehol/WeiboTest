//
//  ViewController.m
//  newauth
//
//  Created by lumdzeehol on 16/9/1.
//  Copyright © 2016年 lumdzeehol. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "HomeViewController.h"

@interface ViewController ()<UIWebViewDelegate>

@property (nonatomic,strong) UIWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:self.webView];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSLog(@"%@",[defaults objectForKey:@"access_token"]);
    [defaults removeObjectForKey:@"access_token"];
    // Do any additional setup after loading the view, typically from a nib.
//    [self performSelector:@selector(presentHomeVC) withObject:nil afterDelay:0.1];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:@"https://api.weibo.com/2/statuses/public_timeline.json?access_token=2.005yRCOG0I55ow1579cee8350Xxzmf" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
        NSString *url = @"https://api.weibo.com/oauth2/authorize?client_id=869037640&response_type=code&redirect_uri=https://api.weibo.com/oauth2/default.html";
        self.webView.delegate = self;
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
        [self.webView loadRequest:request];
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    NSString *url = self.webView.request.URL.absoluteString;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:@"access_token"] == nil) {
        
        if ([url hasPrefix:@"https://api.weibo.com/oauth2/default.html?"]) {
        
 
        NSRange codeRange;
        codeRange = [url rangeOfString:@"code="];
        
        NSRange rangeOfCode = NSMakeRange(codeRange.location + codeRange.length, url.length - codeRange.length - codeRange.location);
        
        NSString *codeString = [url substringWithRange:rangeOfCode]; //获取code
        
        NSMutableString *muString = [[NSMutableString alloc] initWithString:@"https://api.weibo.com/oauth2/access_token?client_id=869037640&client_secret=05a7736897a3073799215594ef05b5f5&grant_type=authorization_code&redirect_uri=https://api.weibo.com/oauth2/default.html&code="];
        [muString appendString:codeString];//调取access_token的url
        NSLog(@"%@",muString);
         
        NSURL *urlString = [NSURL URLWithString:muString];
        
        [muString dataUsingEncoding:NSUTF8StringEncoding];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager POST:muString parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSLog(@"token : %@",responseObject[@"access_token"]);
            [defaults setObject:responseObject[@"access_token"] forKey:@"access_token"];
            NSString *tokenString = [defaults objectForKey:@"access_token"];
            NSLog(@"请求成功,token is : %@",tokenString);
            HomeViewController *homeVC = [[HomeViewController alloc] init];
            [self presentViewController:homeVC animated:YES completion:nil];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"请求失败，%@",error);
        }];
        /*
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:urlString cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
        [request setHTTPMethod:@"POST"];
        NSString *param = @"type=focus-c";
        NSData *data = [param dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:data];
        
        __block NSDictionary *dict = [[NSDictionary alloc] init];
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *task1 = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            dispatch_semaphore_signal(semaphore);
        }];
        [task1 resume];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"%@",dict[@"access_token"]);
        */
 
        }
    }
}

//-(void)presentHomeVC{
//    HomeViewController *HomeVC = [[HomeViewController alloc] init];
//    [self presentViewController:HomeVC animated:YES completion:^{
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        
//        NSLog(@"%@",[defaults objectForKey:@"access_token"]);
//    }];
//}

@end
