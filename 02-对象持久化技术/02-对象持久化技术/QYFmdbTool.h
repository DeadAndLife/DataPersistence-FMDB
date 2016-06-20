  //
//  QYFmdbTool.h
//  02-对象持久化技术
//
//  Created by qingyun on 16/6/17.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import <Foundation/Foundation.h>
@class QYStudent;

@interface QYFmdbTool : NSObject
+(instancetype)shareHandel;

//1.插入数据
-(BOOL)insertIntoStudent:(QYStudent *)mode;

//2.查询所有的数据
-(NSMutableArray *)selectAll;

//3查询单个记录
-(NSMutableArray *)selectOneModeFromId:(NSInteger)Id;

//4.更新数据
-(BOOL)updateValues:(NSDictionary *)pars errorMessage:(NSString**)erroMsg;

//5.删除一个数据
-(BOOL)deleteModeFromName:(NSString *)name;


@end
