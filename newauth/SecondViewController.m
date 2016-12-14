//
//  SecondViewController.m
//  newauth
//
//  Created by lumdzeehol on 16/11/8.
//  Copyright © 2016年 lumdzeehol. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

-(void)swipeLeft:(id)sender;
-(void)swipeRight:(id)sender;
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(self.view.center.x - 100, 100, 200, 200)];
    redView.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:redView];
    
    
    //设置手势
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    
    [self.view addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipeRight];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Gestrue
/*
    响应向右滑动
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


/*
    响应向左滑动
 */
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
