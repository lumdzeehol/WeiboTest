//
//  HomeViewController.m
//  newauth
//
//  Created by lumdzeehol on 16/9/4.
//  Copyright © 2016年 lumdzeehol. All rights reserved.
//

#import "AFNetworking.h"
#import "MJRefresh.h"
#import "HomeViewController.h"
#import "Weibo.h"
#import "WeiboCell.h"
#import "SendWeiboController.h"
#import "WeiboDetailController.h"

@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *weiboList;

@property (nonatomic,strong) NSMutableArray *heightArray;

@property (nonatomic,strong)  WeiboCell *demoCell;



-(void)sendWeibo;
-(void)refreshWeibo;
-(void)loadWeibo;
- (IBAction)swipeLeft:(id)sender;
- (IBAction)swipeRight:(id)sender;
-(void)showRefreshIndicator:(NSInteger) refreshCount;
@end

@implementation HomeViewController

-(NSMutableArray *)weiboList{
    if (_weiboList == nil) {
        _weiboList = [NSMutableArray array];
    }
    return _weiboList;
}

-(NSMutableArray *)heightArray{
    if (_heightArray == nil) {
        _heightArray = [NSMutableArray array];
    }
    return _heightArray;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"sssss"];
    NSLog(@"%@",[NSThread currentThread]);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(sendWeibo)];

    self.demoCell = (WeiboCell*)[[[NSBundle mainBundle] loadNibNamed:@"WeiboCell" owner:nil options:nil] firstObject];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.opaque = YES;
    self.tableView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1.00];
    self.tableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshWeibo)];
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[WeiboCell class] forCellReuseIdentifier:@"WeiboCell"];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
    
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipeRight];

    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.tableView.mj_header beginRefreshing];
}

-(void)sendWeibo{
    SendWeiboController *sendCtrl = [[SendWeiboController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:sendCtrl];
    
    [self presentViewController:nav animated:YES completion:nil];
//    [self.navigationController pushViewController:sendCtrl animated:YES];
}

-(void)refreshWeibo{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        [self loadWeibo];
    }];
    [queue addOperation:operation];
}

-(void)loadWeibo{
    //    <---    获取weibo    --->
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableString *publicTimeLineUrl = [[NSMutableString alloc] initWithString:@"https://api.weibo.com/2/statuses/home_timeline.json"];
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = [defaults objectForKey:@"access_token"];
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session GET:publicTimeLineUrl parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray *statuses = responseObject[@"statuses"];
        
        NSInteger originCount = self.weiboList.count;
        NSInteger maxId = 0;
        NSInteger upperBound = statuses.count;
        NSArray *subArr=[NSArray array];
        
        if (self.weiboList.count != 0) {
        maxId = [[[self.weiboList firstObject] objectForKey:@"id"] integerValue];
            NSLog(@"%li",maxId);
            for (int i=0 ; i<statuses.count; i++) {
                
                if ([[statuses[i] objectForKey:@"id"] integerValue] <= maxId) {
                    upperBound = i;
                    NSLog(@"i  = %d",i );
                    break;
                }
            }
            subArr = [statuses subarrayWithRange:NSMakeRange(0, upperBound)];
//            NSLog(@"SubARr.count is %li",subArr.count);
            [self.weiboList insertObjects:subArr atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, subArr.count)]];
        }else{
            [self.weiboList addObjectsFromArray:statuses];
        }
        
        NSLog(@"self.weibolist.count = %li",self.weiboList.count);
        [self.heightArray removeAllObjects];
        [self.tableView.mj_header endRefreshing];
        [self showRefreshIndicator:self.weiboList.count - originCount];
//        NSLog(@"weibolist.count is %li",self.weiboList.count);
        [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    //    <---    获取weibo    --->
}

-(void)showRefreshIndicator:(NSInteger) refreshCount{
    UILabel *indicatorLabel = [[UILabel alloc] init];
    indicatorLabel.textAlignment = NSTextAlignmentCenter;
    indicatorLabel.text = [NSString stringWithFormat:@"更新了%li条微博",refreshCount];
    indicatorLabel.textColor = [UIColor whiteColor];
    indicatorLabel.backgroundColor = [UIColor colorWithRed:1.00 green:0.52 blue:0.06 alpha:1.00];
    indicatorLabel.frame = CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.frame.size.height - 35, self.navigationController.view.frame.size.width, 35);

    [self.navigationController.view insertSubview:indicatorLabel belowSubview:self.navigationController.navigationBar];
    [UIView animateWithDuration:0.5 animations:^{
        indicatorLabel.transform = CGAffineTransformMakeTranslation(0, indicatorLabel.frame.size.height);
    } completion:^(BOOL finished) {
       [UIView animateWithDuration:1.0 delay:1.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
           indicatorLabel.transform = CGAffineTransformIdentity;
       } completion:^(BOOL finished) {
           [indicatorLabel removeFromSuperview];
       }];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - tableview datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.weiboList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WeiboCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WeiboCell"];
    if (cell == nil) {
        cell = [[WeiboCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WeiboCell"];
    }
    [cell setCellWithWeibo:self.weiboList[indexPath.row]];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [self.heightArray[indexPath.row] floatValue] - 5.0f)];
    view.backgroundColor =[UIColor whiteColor];
    [cell addSubview:view];
    [cell sendSubviewToBack:view];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height;
    
    //如果当前行行高已经存入heightarray中，则从array中去
    //否则计算出高度，存入heightarray中
    if (self.heightArray.count > indexPath.row) {
        height = [self.heightArray[indexPath.row] floatValue];
    }
    else{
        [_demoCell setCellWithWeibo:self.weiboList[indexPath.row]];
        
        height = [_demoCell heightOfCell];
        [self.heightArray addObject:[NSNumber numberWithDouble:height]];
    }
    
    return height;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //点击tableview中的微博cell，进入detailcontroller，显示该微博详细
    
    WeiboDetailController *detailController = [[WeiboDetailController alloc] init];
    detailController.weibo = self.weiboList[indexPath.row];
    [self.navigationController pushViewController:detailController animated:YES];
}


#pragma mark - Gestrue
/*
    手势响应方法的实现
 */

- (IBAction)swipeRight:(id)sender{
    NSInteger selectedIndex = [self.tabBarController selectedIndex];
    
    NSArray *viewControllerArray = self.tabBarController.viewControllers;
    if (selectedIndex < viewControllerArray.count - 1) {
        
        UIView *fromView = [self.tabBarController selectedViewController].view;
        
        UIView *toView = [self.tabBarController.viewControllers objectAtIndex:selectedIndex + 1].view;
        
        [UIView transitionFromView:fromView toView:toView duration:0.5f options:UIViewAnimationOptionCurveEaseInOut completion:^(BOOL finished) {
            if (finished) {
                [self.tabBarController setSelectedIndex:selectedIndex + 1];
            }
            
        }];
    }
}

-(void)swipeLeft:(id)sender{
    NSInteger selectedIndex = [self.tabBarController selectedIndex];
    
    if (selectedIndex > 0) {
        UIView *fromView = [self.tabBarController selectedViewController].view;
        
        UIView *toView = [self.tabBarController.viewControllers objectAtIndex:selectedIndex - 1].view;
        
        [UIView transitionFromView:fromView toView:toView duration:0.5f options:UIViewAnimationOptionCurveEaseInOut completion:^(BOOL finished) {
            if (finished) {
                [self.tabBarController setSelectedIndex:selectedIndex -1];
            }
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
