//
//  QYSelectVc.m
//  02-对象持久化技术
//
//  Created by qingyun on 16/6/16.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import "QYSelectVc.h"
#import "QYStudent.h"
#import "QYSqliteTool.h"
#import "QYFmdbTool.h"

@interface QYSelectVc ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *searchTf;
@property (weak, nonatomic) IBOutlet UITableView *myTable;
//数据源
@property(strong,nonatomic)NSMutableArray *dataArr;
@end

@implementation QYSelectVc


-(void)addsubView{
    UIBarButtonItem *rightButtonItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchAllAction:)];
    self.navigationItem.rightBarButtonItem=rightButtonItem;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addsubView];
    // Do any additional setup after loading the view.
}

#pragma mark tableviewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identfier=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identfier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identfier];
    }
    //赋值操作
    QYStudent *mode=_dataArr[indexPath.row];
    cell.imageView.image=[UIImage imageWithData:mode.icon];
    cell.textLabel.text=[NSString stringWithFormat:@"ID:%ld       name:%@",mode.Id,mode.name];
    cell.detailTextLabel.text=[NSString stringWithFormat:@"age:%ld                     phone:%@",mode.age,mode.phone];
    return cell;
}

- (IBAction)searchOneAction:(id)sender {
    self.dataArr=[[QYSqliteTool shareHandel] selectOneModeFromId:_searchTf.text.integerValue];
    if (_dataArr) {
//        if(_dataArr.count==0);
        [self.myTable reloadData];
    }
    
}

- (IBAction)searchAllAction:(id)sender {
#if 0
    self.dataArr=[[QYSqliteTool shareHandel] selectAll];
#endif
    self.dataArr=[[QYFmdbTool shareHandel] selectAll];
    
    if (self.dataArr) {
       //刷新UI
        [self.myTable reloadData];
        
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
