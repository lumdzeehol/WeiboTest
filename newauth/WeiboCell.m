//
//  WeiboCell.m
//  newauth
//
//  Created by lumdzeehol on 16/9/4.
//  Copyright © 2016年 lumdzeehol. All rights reserved.
//

#import "WeiboCell.h"
#import "UIImageView+WebCache.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface WeiboCell ()


@end

@implementation WeiboCell

//- (void)awakeFromNib {
//    [super awakeFromNib];
//    // Initialization code
//    
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"WeiboCell" owner:nil options:nil]firstObject];
    }
    return self;
}

-(WeiboCell*)setCellWithWeibo:(NSDictionary*)dict{
    
    
    self.name.text = [dict[@"user"] objectForKey:@"screen_name"];
    
//    self.icon.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dict[@"user"] objectForKey:@"profile_image_url"]]]];
    [self.icon sd_setImageWithURL:[NSURL URLWithString:[dict[@"user"] objectForKey:@"profile_image_url"]]];
//    NSLog(@"the frame is %f",self.imageView.frame.origin.x);
    
    NSString *src = dict[@"source"];
    if (src.length>1) {
        NSRange left = [src rangeOfString:@">"];
        NSRange right = [src rangeOfString:@"</"];
        NSRange rangeofSource = NSMakeRange(left.location + left.length, right.location - left.location - left.length);
        
        NSMutableString *srcStr = [[NSMutableString alloc] initWithString:@"来自"];
        NSString *realSrc = [src substringWithRange:rangeofSource];
        [srcStr appendString:realSrc];
        
        self.source.text = srcStr;

    }
    
    self.publicTime.text = [[[dict[@"created_at"] componentsSeparatedByString:@" "] objectAtIndex:3] substringToIndex:5];
    
    self.contentLabel.text  = dict[@"text"];
    
    self.separatorInset = UIEdgeInsetsZero;
    
    return self;
}

/*
    返回contentLabel的高度的高度
 */
-(CGFloat)heightOfCell{
//    
//    CGSize contentSize = [self.contentLabel.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-30, 20000.0f) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:nil context:nil].size;
//    CGFloat height = contentSize.height;
//    [self.contentLabel  sizeToFit];
    [self setNeedsLayout];
    [self layoutIfNeeded];

    return CGRectGetMaxY(self.contentLabel.frame)+20.0f;
}


@end
