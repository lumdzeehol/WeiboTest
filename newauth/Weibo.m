//
//  Weibo.m
//  newauth
//
//  Created by lumdzeehol on 16/9/5.
//  Copyright © 2016年 lumdzeehol. All rights reserved.
//

#import "Weibo.h"

@implementation Weibo

-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
    NSDictionary *userDict = [dict objectForKey:@"user"];
    self.icon = [userDict objectForKey:@"profile_image_url"];
    self.name = [userDict objectForKey:@"screen_name"];
    self.publicTime = [dict objectForKey:@"created_at"];
    self.source = [dict objectForKey:@"source"];
    self.contentText = [dict objectForKey:@"text"];
    self.idStr = [dict objectForKey:@"idstr"];
    }
    return self;
}


@end
