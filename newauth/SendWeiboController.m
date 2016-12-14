//
//  SendWeiboController.m
//  newauth
//
//  Created by lumdzeehol on 16/10/19.
//  Copyright © 2016年 lumdzeehol. All rights reserved.
//

#import "SendWeiboController.h"
#import "AFNetworking.h"

@interface SendWeiboController ()

-(void)sendThatWeibo;

@end

@implementation SendWeiboController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"发送微博";
    
    //设置导航栏右按钮为发送按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送le " style:UIBarButtonItemStyleDone target:self action:@selector(sendThatWeibo)];
    self.view.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1.00];
    
    //微博文本框
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 300)];
    [self.view addSubview:self.textView];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)sendThatWeibo{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *str = self.textView.text;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //access_token令牌 和 status微博 作为参数
    params[@"access_token"] = [defaults objectForKey:@"access_token"];
    params[@"status"] = str;
    //向新浪微博更新接口发送post请求
    [manager POST:@"https://api.weibo.com/2/statuses/update.json" parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success!!!!");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"defeat!!!");
    }];

    //发送成功后使sendweibo控制器消失
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        NSLog(@"%@",self.navigationController.presentingViewController);
    }];
}


@end
