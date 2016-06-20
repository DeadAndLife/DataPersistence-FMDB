//
//  QYmode.m
//  02-对象持久化技术
//
//  Created by qingyun on 16/6/13.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import "QYmode.h"
//用户名
static NSString *KuserName=@"username";
//密码
static NSString *Kpwd=@"password";

@implementation QYmode
#pragma mark NScoding 协议
/*
 *解档   NSData====解码=====>objc对象
 */
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(self=[super init]){
        /**
         *  解码 赋值
         */
        //解档username
        _userName=[aDecoder decodeObjectForKey:KuserName];
        //解档pwd
        _pwd=[aDecoder decodeObjectForKey:Kpwd];

    }
    return self;
}

/**
 * 归档   OBjc====编码======>NSData
 */
-(void)encodeWithCoder:(NSCoder *)aCoder{
   //编码归档
    //归档用户名
    [aCoder encodeObject:_userName forKey:KuserName];
    //归档密码
    [aCoder encodeObject:_pwd forKey:Kpwd];
}



@end
