//
//  ViewController.m
//  TableViewCellExpand
//
//  Created by 陈绪混 on 2016/12/11.
//  Copyright © 2016年 Chenxuhun. All rights reserved.
//

#import "ViewController.h"

#define mWidth [UIScreen mainScreen] .bounds.size.width
#define mHeight [UIScreen mainScreen] .bounds.size.height

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong)NSMutableArray *isExpandArr; // 是否展开数组
@property(nonatomic, strong)NSMutableArray *expandSourceArr; // 扩展后的列表的数据源

@property(nonatomic, strong)UITableView *expandTableView;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"简单易理解展开Cell";

    // 配置TableView
    [self.view addSubview:self.expandTableView];
    
    // 给每个分区添加未选中状态
    self.isExpandArr = [NSMutableArray array];
    for (int i = 0; i < self.expandSourceArr.count; i++)
    {
        [self.isExpandArr addObject:@"NO"];
    }
}

#pragma mark UITableViewDelegate Method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.expandSourceArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.isExpandArr[section] isEqual:@"YES"])
    {
        return [[self.expandSourceArr objectAtIndex:section] count];
    }
    else return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identfier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identfier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identfier];
    }
    // Tip: expandSourceArr中有2个对象，所以这样赋值才对，不然崩掉。
    //NSLog(@"HH %lu",(unsigned long)[[self.expandSourceArr objectAtIndex:indexPath.section] count]);
    if ([[self.expandSourceArr objectAtIndex:indexPath.section] count] > indexPath.row)
    {
        cell.textLabel.text = [[self.expandSourceArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }
    
    if ([self.isExpandArr[indexPath.section]  isEqual: @"NO"] &&
        indexPath.row == 1 &&
        [[self.expandSourceArr objectAtIndex:indexPath.section] count] != 2)
    {
        cell.textLabel.text = nil;
        cell.textLabel.text = @"展开Cell";
    }
    return cell;
}

// 点击行开始做数据加载
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 渐变行
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 装着新的数据数据
    NSMutableArray *sourceArr = [NSMutableArray array];
    
    // 获取当前点击的Cell
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:indexPath.section]];
    
    // 判断展开状态
    if ([self.isExpandArr[indexPath.section] isEqual:@"NO"]) // 增加数据 操作
    {
        // 取反
        self.isExpandArr[indexPath.section] = @"YES";
        // 赋值
        cell.textLabel.text = [[self.expandSourceArr objectAtIndex:indexPath.section] objectAtIndex:1];
        
        // 循环取值展示cell
        for (int i = 2; i < [[self.expandSourceArr objectAtIndex:indexPath.section] count]; i++)
        {
            // 取得当前分区行indexPath
            NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:indexPath.section];
            
            // 赋值给新数组
            [sourceArr addObject:index];
        }
        
        // 动态插入数据
        [self.expandTableView insertRowsAtIndexPaths:sourceArr withRowAnimation:UITableViewRowAnimationBottom];
    }
    else // 删除数据 操作
    {
        if (indexPath.row == 0)
        {
            self.isExpandArr[indexPath.section] = @"NO";
            cell.textLabel.text = @"展开Cell";
            for (int i = 2; i < [[self.expandSourceArr objectAtIndex:indexPath.section] count]; i++)
            {
                // 取得当前的分区行indexPath
                NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:indexPath.section];
                
                // 赋值给新数组
                [sourceArr addObject:index];
            }
            
            //  删除数据
            [self.expandTableView deleteRowsAtIndexPaths:sourceArr withRowAnimation:UITableViewRowAnimationTop];
        }
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([[self.expandSourceArr objectAtIndex:indexPath.section] count] == 2)
    {
        return nil;
    }
    
    if ([self.isExpandArr[indexPath.section] isEqual: @"YES"])
    {
        return indexPath;
    }
    else
    {
        if (indexPath.row == 1)
        {
            return indexPath;
        }
        else
        {
            return nil;
        }
    }
}

- (UITableView *)expandTableView
{
    if (!_expandTableView)
    {
        self.expandTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, mWidth, mHeight) style:UITableViewStyleGrouped];
        self.expandTableView.dataSource = self;
        self.expandTableView.delegate = self;
    }
    return _expandTableView;
}

- (NSMutableArray *)expandSourceArr
{
    if (!_expandSourceArr)
    {
        self.expandSourceArr = [NSMutableArray array];
        
        // 初始化两个数据给到展开后的分区Cell
        NSArray *arr0 = [NSArray arrayWithObjects:@"我的基友",@"1",@"2",@"3",@"4",@"5", nil];
        NSArray *arr1 = [NSArray arrayWithObjects:@"我的盟友",@"B",@"C",@"D",@"E",@"F",@"I", nil];
        
        [self.expandSourceArr addObject:arr0];
        [self.expandSourceArr addObject:arr1];
        
        //NSLog(@"-- %@",self.expandSourceArr);
    }
    return _expandSourceArr;
}
@end
