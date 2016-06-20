//
//  QYDeleteVC.m
//  02-对象持久化技术
//
//  Created by qingyun on 16/6/16.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import "QYDeleteVC.h"
#import "QYStudent.h"
#import "QYSqliteTool.h"
#import "QYFmdbTool.h"

@interface QYDeleteVC ()
@property (weak, nonatomic) IBOutlet UITextField *deleteTextField;

@end

@implementation QYDeleteVC
- (IBAction)deleteOnAction:(UIButton *)sender {
    NSString *str = _deleteTextField.text;
#if 0
    QYSqliteTool *tool = [QYSqliteTool shareHandel];
    if ([tool deleteModeFromName:str]) {
        NSLog(@"====delete OK");
    }
#endif
    QYFmdbTool *tool=[QYFmdbTool shareHandel];
    if ([tool deleteModeFromName:str]) {
        NSLog(@"=====delete Ok");
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
