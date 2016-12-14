//
//  WeiboCell.h
//  newauth
//
//  Created by lumdzeehol on 16/9/4.
//  Copyright © 2016年 lumdzeehol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Weibo.h"

@interface WeiboCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *publicTime;
@property (weak, nonatomic) IBOutlet UILabel *source;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

-(WeiboCell*)setCellWithWeibo:(NSDictionary *)dict;

-(CGFloat)heightOfCell;


@end
