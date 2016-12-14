//
//  Weibo.h
//  newauth
//
//  Created by lumdzeehol on 16/9/5.
//  Copyright © 2016年 lumdzeehol. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Weibo : NSObject

@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *publicTime;
@property (nonatomic,copy) NSString *source;
@property (nonatomic,copy) NSString *icon;
@property (nonatomic,copy) NSString *contentText;
@property (nonatomic,copy) NSString *idStr;

-(instancetype)initWithDict:(NSDictionary *)dict;
@end

