//
//  UserDefautlsVC.m
//  02-对象持久化技术
//
//  Created by qingyun on 16/6/13.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import "UserDefautlsVC.h"

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

@interface UserDefautlsVC ()
@property (weak, nonatomic) IBOutlet UITextField *keyTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *ageTextField;
@property (weak, nonatomic) IBOutlet UISwitch *switchSex;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UISlider *sliderInfo;

@end

@implementation UserDefautlsVC

-(void)loadDataFromLoaction{
    //1.获取NSUserDefaults单例对象
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    //读取name=====>UI
    NSString *name=[defaults stringForKey:Kname];
    _nameTextField.text=name;

    //读取Age
    NSInteger age=[defaults integerForKey:Kage];
    _ageTextField.text=[NSString stringWithFormat:@"%ld",age];
    //读取sex
    BOOL sex=[defaults boolForKey:Ksex];
    _switchSex.on=sex;
    
    //读取icon NSdata
    NSData *data=[defaults dataForKey:Kicon];
    _iconImage.image=[UIImage imageWithData:data];
    
    //读取info
    float value=[defaults floatForKey:Kinfo];
    _sliderInfo.value=value;

}


-(void)removeKey:(NSString *)key{
   //1.获取单例对象
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
   //2.移除某一个key
    [defaults removeObjectForKey:key];
}



-(BOOL)saveDataToLocation{
   //1.获取NsuserDefaults单例对象
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
   //2.设置你要存储的值,Key-value形式存储
   //存储的文件是一个plist文件,存储路径library/preference目录下,文件名称存储为:bundle idenfier.plist
    //该对象只能存储一些设置信息,密码敏感信息不能存储在里边
    //2.1name 存储
    [defaults setObject:_nameTextField.text forKey:Kname];
    //2.2 age 存储
    [defaults setInteger:_ageTextField.text.integerValue forKey:Kage];
    //2.3 sex 存储
    [defaults setBool:_switchSex.on forKey:Ksex];
    //2.4 icon 存储
    UIImage *image=[UIImage imageNamed:@"1.jpg"];
    NSData *data=UIImageJPEGRepresentation(image, 1);
 //   NSData *data= UIImagePNGRepresentation(image);
    [defaults setObject:data forKey:Kicon];
    //2.5设置进度
    [defaults setFloat:_sliderInfo.value forKey:Kinfo];
   
    //3.同步
//    if (热[defaults synchronize]) {
//        NSLog(@"成功");
//    }

    return [defaults synchronize];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //1.从本地加载数据
    [self loadDataFromLoaction];
    
    // Do any additional setup after loading the view.
}

- (IBAction)touchSaveAction:(id)sender {
   //2.将数据存储在本地
    [self saveDataToLocation];

}

//删除单个操作
- (IBAction)removeAction:(id)sender {
    //1.获取要删除的key
    NSString *key=_keyTextFiled.text;
    //2.删除
    if (key) {
     [self removeKey:key];
    }
    
}

@end
