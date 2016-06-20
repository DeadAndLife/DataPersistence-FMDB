//
//  QYStudent.m
//  02-对象持久化技术
//
//  Created by qingyun on 16/6/16.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import "QYStudent.h"

@implementation QYStudent

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{


}

+(instancetype)modeWithDic:(NSDictionary *)dic{
    QYStudent *student=[[QYStudent alloc] init];
    [student setValuesForKeysWithDictionary:dic];
    return student;
}


@end
