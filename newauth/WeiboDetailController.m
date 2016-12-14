//
//  WeiboDetailController.m
//  newauth
//
//  Created by lumdzeehol on 16/12/1.
//  Copyright © 2016年 lumdzeehol. All rights reserved.
//

#import "WeiboDetailController.h"
#import "AFNetworking.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
@interface WeiboDetailController ()
@property (strong, nonatomic)  UIImageView *icon;
@property (strong, nonatomic)  UILabel *name;
@property (strong, nonatomic)  UILabel *publicTime;
@property (strong, nonatomic)  UILabel *source;
@property (strong, nonatomic)  UILabel *contentLabel;

@end

@implementation WeiboDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.icon = [[UIImageView alloc] init];
    self.name = [[UILabel alloc] init];
    self.publicTime = [[UILabel alloc] init];
    self.source = [[UILabel alloc] init];
    self.contentLabel = [[UILabel alloc] init];
    [self.view addSubview:self.icon];
    [self.view addSubview:self.name];
    [self.view addSubview:self.publicTime];
    [self.view addSubview:self.source];
    self.contentLabel.numberOfLines = 0;
    [self.view addSubview:self.contentLabel];
    self.view.backgroundColor = [UIColor whiteColor];
    
    /*
            set model
    */
    
    self.name.text = [_weibo[@"user"] objectForKey:@"screen_name"];
    
    
    [self.icon sd_setImageWithURL:[NSURL URLWithString:[_weibo[@"user"] objectForKey:@"profile_image_url"]]];
    
    NSString *src = _weibo[@"source"];
    if (src.length>1) {
        
        //取出返回字段中<></> 之间的source信息
        NSRange left = [src rangeOfString:@">"];
        NSRange right = [src rangeOfString:@"</"];
        NSRange rangeofSource = NSMakeRange(left.location + left.length, right.location - left.location - left.length);
        
        NSMutableString *srcStr = [[NSMutableString alloc] initWithString:@"来自"];
        NSString *realSrc = [src substringWithRange:rangeofSource];
        [srcStr appendString:realSrc];
        
        self.source.text = srcStr;
        
    }
    
    self.publicTime.text = [[[_weibo[@"created_at"] componentsSeparatedByString:@" "] objectAtIndex:3] substringToIndex:5];
    
    self.contentLabel.text  = _weibo[@"text"];
    
    
    /*
            为各控件添加约束
            make constrain
    */
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@60);
        make.height.equalTo(@60);
        make.left.equalTo(self.view).with.offset(20);
        make.top.equalTo(self.mas_topLayoutGuide).with.offset(20);
    }];
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuide).with.offset(20);
        make.left.equalTo(self.icon.mas_right).with.offset(20);
    }];
    [self.publicTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.name.mas_bottom).with.offset(30);
        make.left.equalTo(self.icon.mas_right).with.offset(20);
    }];
    [self.source mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.publicTime);
        make.left.equalTo(self.publicTime.mas_right).with.offset(20);
        
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        self.contentLabel.backgroundColor = [UIColor greenColor];
        make.top.equalTo(self.icon.mas_bottom).with.offset(20);
        make.left.equalTo(self.view).with.offset(20);
        make.right.equalTo(self.view.mas_right).with.offset(20);
    }];
    
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

@end
