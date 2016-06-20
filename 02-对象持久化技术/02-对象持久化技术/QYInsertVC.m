//
//  QYInsertVC.m
//  02-对象持久化技术
//
//  Created by qingyun on 16/6/16.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import "QYInsertVC.h"
#import "QYStudent.h"
#import "QYSqliteTool.h"
#import "QYFmdbTool.h"

@interface QYInsertVC ()
@property (weak, nonatomic) IBOutlet UITextField *nameTf;
@property (weak, nonatomic) IBOutlet UITextField *ageTf;
@property (weak, nonatomic) IBOutlet UITextField *phoneTf;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@end

@implementation QYInsertVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)insertAction:(id)sender {
  //1.封装参数
    NSDictionary *pars=@{@"name":_nameTf.text,@"age":@(_ageTf.text.integerValue),@"phone":_phoneTf.text,@"icon":UIImageJPEGRepresentation(_iconImageView.image,1)};
   //2.将字典转换成mode
    QYStudent *mode=[QYStudent modeWithDic:pars];
    
   //3.插入到数据库
#if 0
    if ([[QYSqliteTool shareHandel] insertIntoStudent:mode]) {
        NSLog(@"insert OK!");
    }
#endif
    if ([[QYFmdbTool shareHandel] insertIntoStudent:mode]) {
        NSLog(@"insert Ok!");
    }
    
}


@end
