//
//  NScoderVc.m
//  02-对象持久化技术
//
//  Created by qingyun on 16/6/13.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import "NScoderVc.h"
#import "QYmode.h"


static NSString *KfileName=@"ArchFile";

@interface NScoderVc ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTf;
@property (weak, nonatomic) IBOutlet UITextField *pwdTf;
//文件存储路径
@property (strong,nonatomic) NSString *filePath;
@end

@implementation NScoderVc


-(NSString *)filePath{
    if (_filePath) {
        return _filePath;
    }
    //1.获取documentsPath
    NSString *documentsPath=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    //2.合并文件路径
    _filePath=[documentsPath stringByAppendingPathComponent:KfileName];
    return _filePath;
}

-(void)loadDataFromLocation{
   //1.解档操作  NSData===对象, 该方法调用后会自动调用QYmode Ncoding下的解档协议 -(instancetype)initWithCoder:(NSCoder *)aDecoder
    QYmode *mode=[NSKeyedUnarchiver unarchiveObjectWithFile:self.filePath];
    if(mode){
   //2.mode赋值给UI
        _userNameTf.text=mode.userName;
        _pwdTf.text=mode.pwd;
    }
}

-(BOOL)saveDataToLocation{
    //1.初始化mode,给mode赋值
    QYmode *mode=[QYmode new];
    mode.userName=_userNameTf.text;
    mode.pwd=_pwdTf.text;
    //2.把mode序列化 存储在本地;用 NSCoder 子类 NSKeyedArchiver 序列化时会自动调用mode NSCoding协议的归档方法 -(void)encodeWithCoder:(NSCoder *)aCoder
    return  [NSKeyedArchiver archiveRootObject:mode toFile:self.filePath];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //1.从本地读取数据
    [self loadDataFromLocation];
    // Do any additional setup after loading the view.
}
- (IBAction)touchSaveAction:(id)sender {
   //2.将数据存储在本地
    if([self saveDataToLocation])NSLog(@"OK");

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
