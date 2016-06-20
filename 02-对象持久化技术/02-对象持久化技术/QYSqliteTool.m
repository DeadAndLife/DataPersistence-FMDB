//
//  QYSqliteTool.m
//  02-对象持久化技术
//
//  Created by qingyun on 16/6/16.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import "QYSqliteTool.h"
#import "QYStudent.h"
#include <sqlite3.h>

#define DBNAME @"student.db"

//1.static 静态全局变量,只能在.m访问
//2.db 数据库连接对象,db不为NULL,说明数据库是打开的
static sqlite3 *db;

@implementation QYSqliteTool

+(instancetype)shareHandel{
    static QYSqliteTool *tool;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //该方法只会执行一次
        tool=[[QYSqliteTool alloc] init];
        [tool createTable];
    });
    return tool;
}

//打开数据库
-(BOOL)openDB{
    //判断当前数据库是否已经打开
    if(db)return db;
    
    //1.合并路径
    NSString *path=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *dbPath=[path stringByAppendingPathComponent:DBNAME];
    //2.打开数据库连接对象
    /**
     *  打开数据库,创建数据库连接对象
     *
     *  @param filename#> 数据库存放的地址  (UTF-8)
     *  @param ppDb#>     数据库连接对象的指针
     *
     *  @return 数据库连接对象
     */
    int result=sqlite3_open([dbPath UTF8String], &db);
    if (result==SQLITE_OK) {
        NSLog(@"open db OK");
        return YES;
    }
       NSLog(@"open db error");
    return NO;
}

-(BOOL)closeDB{
    //1.关闭数据库,销毁数据库连接对象
    if(sqlite3_close(db)!=SQLITE_OK)return NO;

    //2.db指向NULL
    db=NULL;
    return YES;
}



//.创建表
-(BOOL)createTable{
   //1.打开数据库
    if (![self openDB]) return NO;
   //2.编写sql语句
    NSString *sql=@"create table if not exists students(Id integer primary key,name text,age integer,phone text,icon blob)";
    //3.执行sql语句
    char *errmsg;
    int result=sqlite3_exec(db, [sql UTF8String], NULL, NULL, &errmsg);
    if (result!=SQLITE_OK) {
        NSLog(@"====%s",errmsg);
        //释放错误信息
        sqlite3_free(errmsg);
        return NO;
    }
    return YES;
}


-(BOOL)insertIntoStudent:(QYStudent *)mode{
    //1.打开数据库
    if(![self openDB])return NO;
    //2.编写sql语句
    NSString *sql=@"insert into students(name,age,phone,icon)values(?,?,?,?)";
    //3.将sql语句转化成预编译对象
      //3.1声明预编译对象
       sqlite3_stmt *stmt;
       //第三个参数表示sql的长度,-1 全部
       //第五个参数表示sql的地址,一般对我们没有用NULL
     int result=sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, NULL);
      if (result!=SQLITE_OK) {
        NSLog(@"=====%s",sqlite3_errmsg(db));
        return NO;
      }
      //3.2bind参数给预编译对象
       //第二个参数表示参数的位置 1 开始
       //第四个参数表示字符串的长度 -1 全部
       //第五个参数表示字符串的地址,NULL
       sqlite3_bind_text(stmt, 1, [mode.name UTF8String], -1, NULL);
       sqlite3_bind_int(stmt, 2, (int)mode.age);
       sqlite3_bind_text(stmt, 3, [mode.phone UTF8String], -1, NULL);
       const void * bytes=mode.icon.bytes;
       sqlite3_bind_blob(stmt, 4, bytes,(int)mode.icon.length, NULL);
    //4.执行预编译对象
    //如果执行'insert,update,delete'等没有返回值的操作要用SQLITE_DONE
    //如果执行 'selecte'有返回结果值,那么需要用 SQLITE_ROW,循环读取数据;
    result=sqlite3_step(stmt);
    if (result!=SQLITE_DONE) {
         NSLog(@"=====%s",sqlite3_errmsg(db));
        //释放预编对象
        sqlite3_finalize(stmt);
        return NO;
    }
    //5.释放预编译对象
    sqlite3_finalize(stmt);

    return YES;
}

-(QYStudent *)extractModebyStmt:(sqlite3_stmt *)stmt{
     //1.取出Id值
     int Id=sqlite3_column_int(stmt, 0);
     //2.取出name
     const unsigned char *name=sqlite3_column_text(stmt, 1);
     //3.取出age
     int age=sqlite3_column_int(stmt, 2);
     //4.取出Phone
     const unsigned char *phone=sqlite3_column_text(stmt, 3);
     //5.取出Icon
     const void *icon=sqlite3_column_blob(stmt, 4);
     int size=sqlite3_column_bytes(stmt, 4);
    //给mode赋值
    QYStudent *studnet=[[QYStudent alloc] init];
    studnet.Id=Id;
    studnet.age=age ;
    if (name) {
        studnet.name=[NSString stringWithUTF8String:(const char *)name];
    }
    if (phone) {
       studnet.phone=[NSString stringWithUTF8String:(const char *)phone];
    }

    NSData *iconData=[NSData dataWithBytes:icon length:size];
    studnet.icon=iconData;
    return studnet;
}
//查询所有数据
-(NSMutableArray *)selectAll{
 //1.打开数据库
    if (![self openDB])return nil;
 //2.编写sql语句
    NSString *sql=@"select * from students";
 //3.sql语句转化成预编译对象
    //3.1声明预编译对象
    sqlite3_stmt *stmt;
    //3.2转化预编译对象
    //第三个参数表示sql的长度 -1全部
    //第五个参数表示sql的地址,对我们没有用NULL
    sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, NULL);
    //3.3bind参数
 //4.执行预编对象
    NSMutableArray *dataArr=[NSMutableArray array];
    //如果执行的是"selecte"有返回值,要用SQLITE_ROW进行循环读取,
    //其他操作可以用SQLITE_DONE,没有返回结果
    while (sqlite3_step(stmt)==SQLITE_ROW) {
      //从预编译对象中取出每一列的值,赋值给mode
        QYStudent *mode=[self extractModebyStmt:stmt];
        [dataArr addObject:mode];
    }
 //5.释放预编译对象
    sqlite3_finalize(stmt);

    return dataArr;
}

-(NSMutableArray *)selectOneModeFromId:(NSInteger)Id{
    //1.打开数据库
    if(![self openDB])return nil;
    //2.编写sql语句
    NSString *sql=[NSString stringWithFormat:@"select * from students where Id=%ld",Id];
    //3.将SQL语句转化成预编译对象
      //3.1.声明预编对象
    sqlite3_stmt *stmt;
      //第三个参数表示sql长度-1 表示全部
      //第五个参数表示sql地址,一般没有用,NUll
    int result=sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, NULL);
    if (result!=SQLITE_OK) {
        return nil;
    }
    //4.执行预编译对象
      //如果执行的是"selecte"有返回值,要用SQLITE_ROW进行循环读取,
      //其他操作没有返回值,要用SQLITE_DONE
     NSMutableArray *dataArr=[NSMutableArray array];
     while (sqlite3_step(stmt)==SQLITE_ROW) {
         //把mode装到数组中
        [dataArr addObject:[self extractModebyStmt:stmt]];
    }
    //5.销毁预编对象
    sqlite3_finalize(stmt);
    //6.关闭数据库,销毁数据库连接对象
    [self closeDB];
    return dataArr;
}

-(BOOL)updateValues:(QYStudent *)mode forID:(NSInteger)Id{
  //1.打开数据库
    if(![self openDB])return NO;
  //2.编写sql语句
    NSString *sql=[NSString stringWithFormat:@"update students set name='%@',age=%ld,phone='%@',icon=? where Id=%ld",mode.name,mode.age,mode.phone,Id];
  //3.将SQL语句转化成预编译对象
    //3.1声明预编译对象
    sqlite3_stmt *stmt;
    //第三个参数表示sql长度,-1表示全部
    //第五个参数表示sql地址,一般没有用,NUll
    int result=sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, NULL);
    if(result!=SQLITE_OK){
        NSLog(@"======%s",sqlite3_errmsg(db));
        return NO;}
     //3.2bind参数
    sqlite3_bind_blob(stmt, 1, [mode.icon bytes], (int)mode.icon.length, NULL);
    
  //4.执行预编译对象
    if (sqlite3_step(stmt)!=SQLITE_DONE) {
        NSLog(@"=====%s",sqlite3_errmsg(db));
        //销毁预编译对象
        sqlite3_finalize(stmt);
        return NO;
    }
  //5.销毁预编译对象
    sqlite3_finalize(stmt);
  //6.关闭数据库
    [self closeDB];
    
  return YES;
}

-(BOOL)deleteModeFromName:(NSString *)name{
    //1.打开数据库
    if(![self openDB])return NO;
    //2.编写sql语句
    NSString *sql=[NSString stringWithFormat:@"delete from students where name='%@'",name];
    //3.将sql语句转化成预编译对象
      //3.1声明预编译对象
    sqlite3_stmt *stmt;
    //第三个参数表示SQL的长度,-1表示全部
    //第五个参数表示sql的地址,一般没有用,NUll
    if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, NULL)!=SQLITE_OK) {
        NSLog(@"=====%s",sqlite3_errmsg(db));
        return NO;
    }
    //4.执行预编对象
    if(sqlite3_step(stmt)!=SQLITE_DONE){
        NSLog(@"=====%s",sqlite3_errmsg(db));
        sqlite3_finalize(stmt);
        return NO;
    }
    //5.销毁预编对象
    sqlite3_finalize(stmt);
    //6.关闭数据库
    [self closeDB];
    return YES;
}


@end
