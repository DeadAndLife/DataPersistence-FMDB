//
//  QYStudent.h
//  02-对象持久化技术
//
//  Created by qingyun on 16/6/16.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QYStudent : NSObject
@property(nonatomic,strong)NSString *name;
@property(nonatomic,assign)NSInteger age;
@property(nonatomic,strong)NSString *phone;
@property(nonatomic,strong)NSData *icon;
@property(nonatomic)NSInteger Id;

+(instancetype)modeWithDic:(NSDictionary *)dic;

@end
