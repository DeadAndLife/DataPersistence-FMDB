//
//  QYUpdateVC.m
//  02-对象持久化技术
//
//  Created by qingyun on 16/6/17.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import "QYUpdateVC.h"
#import "QYStudent.h"
#import "QYSqliteTool.h"
#import "QYFmdbTool.h"
@interface QYUpdateVC ()
@property (weak, nonatomic) IBOutlet UITextField *tfAge;
@property (weak, nonatomic) IBOutlet UITextField *tfId;
@property (weak, nonatomic) IBOutlet UITextField *tfName;
@property (weak, nonatomic) IBOutlet UITextField *tfPhone;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@end

@implementation QYUpdateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)updateAction:(id)sender {
    //更新数据
    //1.将数据赋值给mode
    QYStudent *mode=[[QYStudent alloc] init];
    mode.name=_tfName.text;
    mode.age=_tfAge.text.integerValue;
    mode.phone=_tfPhone.text;
    mode.icon=UIImageJPEGRepresentation(_iconImageView.image, 1);
    mode.Id=_tfId.text.integerValue;
    //封装参数
    NSDictionary *pars=@{@"Id":@(mode.Id),@"name":mode.name,@"age":@(mode.age),@"phone":mode.phone,@"icon":mode.icon};
    
#if 0
    if (mode.Id>0) {
        if ([[QYSqliteTool shareHandel] updateValues:mode forID:mode.Id]) {
            NSLog(@"====UPdate===OK");
        }
    }
#endif
    if (mode.Id>0) {
        NSString *errorMsg;
        if (![[QYFmdbTool shareHandel]updateValues:pars errorMessage:&errorMsg]) {
            NSLog(@"=======%@",errorMsg);
        }else{
            NSLog(@"======update ok");
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
