//
//  PlistViewController.m
//  02-对象持久化技术
//
//  Created by qingyun on 16/6/13.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import "PlistViewController.h"
//姓名
static NSString *Kname=@"name";
//年龄
static NSString *Kage=@"age";
//性别
static NSString *Ksex=@"sex";
//头像
static NSString *Kicon=@"icon";
//信息完整度
static NSString *Kinfo=@"info";
//保存文件的名称
static NSString *KfileName=@"Person.plist";

@interface PlistViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *ageTextField;
@property (weak, nonatomic) IBOutlet UISwitch *switchSex;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UISlider *sliderInfo;
//文件路径
@property(strong,nonatomic)NSString *filePath;

@end

@implementation PlistViewController



-(NSString *)filePath{
    if(_filePath)return _filePath;
    //1.获取documents路径
    NSString *documentsPath=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    //2.合并文件路径
    _filePath=[documentsPath stringByAppendingPathComponent:KfileName];
    
    return _filePath;
}

-(void)loadDataFromLocation{
    //1.读取plist文件装换成字典
    NSDictionary *pars=[[NSDictionary alloc] initWithContentsOfFile:self.filePath];
    if (pars) {
    //2.获取字典的值,赋值给UI
        NSString *name=pars[Kname];
        _nameTextField.text=name;
        _ageTextField.text=[pars[Kage] stringValue];
        _switchSex.on=[pars[Ksex] boolValue];
        NSData *data=pars[Kicon];
        _iconImage.image=[UIImage imageWithData:data];
        _sliderInfo.value=[pars[Kinfo] floatValue];
    }
}

-(BOOL)saveDataToLocation{
   //1.声明一个字典
    NSMutableDictionary *pars=[NSMutableDictionary dictionary];
   //2.设置Key-value
    NSString *name=_nameTextField.text;
    if(name)[pars setValue:name forKey:Kname];
    
    NSInteger age=_ageTextField.text.integerValue;
    [pars setValue:@(age) forKey:Kage];
    
    BOOL onSex=_switchSex.on;
    [pars setObject:@(onSex) forKey:Ksex];
    
    UIImage *icon=[UIImage imageNamed:@"1.jpg"];
    NSData *data=UIImageJPEGRepresentation(icon, 1);
    [pars setObject:data forKey:Kicon];
    
    [pars setObject:@(_sliderInfo.value) forKey:Kinfo];
   //3.将字典保存在Plist文件
    
   return [pars writeToFile:self.filePath atomically:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //1.读取本地缓存文件
    [self loadDataFromLocation];
    
    // Do any additional setup after loading the view.
}

- (IBAction)saveAction:(id)sender {
   //2.将数据保存在本地plist文件
    if ([self saveDataToLocation])NSLog(@"====ok");
    
}

@end
