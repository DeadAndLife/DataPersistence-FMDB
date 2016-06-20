//
//  QYmode.h
//  02-对象持久化技术
//
//  Created by qingyun on 16/6/13.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QYmode : NSObject<NSCoding>


@property(nonatomic,strong) NSString *userName;
@property(nonatomic,strong) NSString *pwd;

@end
