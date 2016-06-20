//
//  QYFmdbTool.m
//  02-对象持久化技术
//
//  Created by qingyun on 16/6/17.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import "QYFmdbTool.h"
#import "QYStudent.h"

#import "FMDB.h"
//数据库文件名称
#define KDBNAME @"student.db"

@interface QYFmdbTool ()
//声明一个FMDBBase数据库对象
//base 创建数据库连接对象,FMDatabase执行sql语句
@property(nonatomic,strong)FMDatabase *base;
@end


@implementation QYFmdbTool

//懒加载
-(FMDatabase *)base{
    if(_base)return _base;
    //初始化_base对象,创建数据库
      //合并数据库路径,指向你数据库的文件
      //1.获取NSdocumentsPath
       NSString *documentsPath=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
      NSString *filePath=[documentsPath stringByAppendingPathComponent:KDBNAME];
    //初始化_base对象
    _base=[FMDatabase databaseWithPath:filePath];
    
    //打开数据库
    if(![_base open]){
        NSLog(@"==error===%@",[_base lastErrorMessage]);
    }
    return _base;
}


+(instancetype)shareHandel{
    static QYFmdbTool *tool;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       // code to be executed once
        tool=[[QYFmdbTool alloc] init];
        //创建表
        [tool creatTable];
    });
    return tool;
}

-(BOOL)creatTable{
    //1.sql语句
    NSString *sql=@"create table if not exists students(Id integer primary key,name text,age integer,phone text,icon blob)";
    //执行创建表更新操作
    BOOL result=[self.base executeUpdate:sql];
    if (!result)NSLog(@"======create error==%@",[self.base lastErrorMessage]);
    return result;
}

-(BOOL)insertIntoStudent:(QYStudent *)mode{
  //1.编写sql语句
   NSString *sql=@"insert into students(name,age,phone,icon)values(?,?,?,?)";
  //2.执行sql语句
  BOOL result=[self.base executeUpdate:sql,mode.name,@(mode.age),mode.phone,mode.icon];
   if (!result) {
        NSLog(@"=====%@",[self.base lastErrorMessage]);
    }
    return result;
}

//查询的数据转换成mode
-(QYStudent *)extractModeFrom:(FMResultSet *)set{
  //1.set 结果转换一个字典
    NSMutableDictionary *dic=(NSMutableDictionary *)[set resultDictionary];
    //发序列化
    NSData *data=dic[@"retweeted_status"];
    
     NSDictionary *pars=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    [dic setObject:pars forKey:@"retweeted_status"];

    NSLog(@"=====%@",dic);
  //2.Kvc 字典转成mode
    
    
   QYStudent *mode=[QYStudent modeWithDic:dic];
   // QYStudent *mode=[[QYStudent alloc] init];
    //[set kvcMagic:mode];
    
    return mode;
}

-(NSMutableArray *)selectAll{
  //1.sql语句
    NSString *sql=@"select * from students";
  //2.执行查询
   FMResultSet *set=[self.base executeQuery:sql];
  //3.对结果进行遍历,取出数据
    NSMutableArray *dataArr=[NSMutableArray array];
    while ([set next]) {
    //从index 取出数据
        //int Id=[set intForColumnIndex:0];
        //NSLog(@"====%d",Id);
        QYStudent *mode=[self extractModeFrom:set];
        [dataArr addObject:mode];
    }
    return dataArr;
}
-(NSMutableArray *)selectOneModeFromId:(NSInteger)Id{
  //1执行SQL语句
   FMResultSet *set=[self.base executeQueryWithFormat:@"select * from students where Id=%ld",Id];
  //2.将查询结果转换mode,存储在数组里
    NSMutableArray *dataArr=[NSMutableArray array];
    while ([set next]) {
     //2.1 数据转成mode
        QYStudent *mode=[self extractModeFrom:set];
     //2.2 mode存在数组里
        [dataArr addObject:mode];
    }
    return dataArr;
}

-(BOOL)deleteModeFromName:(NSString *)name {
  //1编写sql语句
    NSString *sql=@"delete from students where name=?";
  //2.执行sql
    return [self.base executeUpdate:sql,name];
}

-(BOOL)updateValues:(NSDictionary *)pars errorMessage:(NSString**)erroMsg{
  //1.编写sql语句
    NSString *sql=@"update students set name=:name,age=:age,phone1=:phone,icon=:icon where Id=:Id";
  //2.执行sql
  BOOL result=  [self.base executeUpdate:sql withParameterDictionary:pars];
  //错误信息
     *erroMsg=[self.base lastErrorMessage];
    return result;
}



@end
