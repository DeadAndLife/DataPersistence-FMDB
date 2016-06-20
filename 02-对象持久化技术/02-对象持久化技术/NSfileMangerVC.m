//
//  NSfileMangerVC.m
//  02-对象持久化技术
//
//  Created by qingyun on 16/6/13.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import "NSfileMangerVC.h"
//文件名称
#define KFILE @"test.txt"
//文件夹名称
#define KDIRECTRORYNAME @"MYTEST"

@interface NSfileMangerVC ()
@property (weak, nonatomic) IBOutlet UITextField *myTextFile;
//文件保存路径
@property(strong,nonatomic)NSString *filePath;

@end

@implementation NSfileMangerVC

-(NSString *)filePath{
    if(_filePath)return _filePath;
    //1.创建文件夹
      //1.1获取文件管理器对象
      NSFileManager *manger=[NSFileManager defaultManager];
      //1.2合并文件夹路径
      //1.2.1获取沙盒documents路径
      NSString *documentsPath=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
      //1.2.2合并文件夹路径
      NSString *directoryPath=[documentsPath stringByAppendingPathComponent:KDIRECTRORYNAME];
      //1.3创建文件夹
      NSError *error;
    if (![manger createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:&error]) {
        NSLog(@"=失败====%@",error);
        return nil;
    }
    //2.创建文件路径
    //2.1合并文件路径
    NSString *path=[directoryPath stringByAppendingPathComponent:KFILE];
    //2.2创建文件
      //2.2.1判断当前文件是否存在
    if(![manger fileExistsAtPath:path]){
      //2.2.2创建文件
       if(![manger createFileAtPath:path contents:nil attributes:nil])return nil;
    }
     //文件路径赋值
    _filePath=path;
    return _filePath;
}



-(void)loadDataFromLocation{
   //1.读取文件转成nsstring对象
    NSString *file=[[NSString alloc] initWithContentsOfFile:self.filePath encoding:NSUTF8StringEncoding error:nil];
   //2.填充UI
    if (file) {
        _myTextFile.text=file;
    }
}

-(BOOL)saveDataToLocation{
    //1.获取UITextField的内容
    if (_myTextFile.text.length==0) {
        return NO;
    }
    //2.写入文件到本地
    return [_myTextFile.text writeToFile:self.filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    //1.从本地加载数据
    [self loadDataFromLocation];
    
    // Do any additional setup after loading the view.
}
- (IBAction)touchSave:(id)sender {
      //2.将数据保存本地
    if ([self saveDataToLocation]) {
        NSLog(@"========存入数据成功");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
