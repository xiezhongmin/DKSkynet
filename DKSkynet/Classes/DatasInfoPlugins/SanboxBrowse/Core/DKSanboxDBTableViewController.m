//
//  DKSanboxDBTableViewController.m
//  DKSkynet
//
//  Created by admin on 2022/7/22.
//

#import "DKSanboxDBTableViewController.h"
#import "DKSanboxDBManager.h"
#import "DKSanboxDBShowView.h"
#import "DKSanboxDBRowView.h"
#import "DKSanboxDBCell.h"

@interface DKSanboxDBTableViewController () <UITableViewDelegate, UITableViewDataSource, DKSanboxDBRowViewDelegate>

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) DKSanboxDBShowView *showView;
@property (nonatomic, copy) NSArray *dataAtTable;

@end

@implementation DKSanboxDBTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = [DKSanboxDBManager shareManager].tableName;
    self.view.backgroundColor = [UIColor whiteColor];

    NSArray *dataAtTable = [[DKSanboxDBManager shareManager] dataAtTable];
    self.dataAtTable = dataAtTable;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.bounces  = NO;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    UITableView *tableView = [[UITableView alloc] init];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.scrollView addSubview:tableView];
    self.tableView = tableView;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    if (self.dataAtTable.count) {
        NSDictionary *dict = self.dataAtTable.firstObject;
        NSUInteger num = [dict allKeys].count;
        self.tableView.frame = CGRectMake(0, 0, num * 200, self.scrollView.frame.size.height);
        self.scrollView.contentSize = CGSizeMake(self.tableView.frame.size.width, self.tableView.bounds.size.height);
    }
}

#pragma mark - UITableViewDelegate, UITableViewDataSource -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataAtTable.count == 0 ? 0 : 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    DKSanboxDBRowView *headerView = nil;
    if (headerView == nil) {
        headerView = [[DKSanboxDBRowView alloc] init];
    }
    
    NSDictionary *dict = self.dataAtTable.firstObject;
    headerView.dataArray = [dict allKeys];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataAtTable.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DKSanboxDBCell *cell = [tableView dequeueReusableCellWithIdentifier:kDKSanboxDBCellIdentifier];
    if (cell == nil) {
        cell = [[DKSanboxDBCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kDKSanboxDBCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.rowView.delegate = self;
    }
    
    cell.rowView.type = (indexPath.row % 2 == 0) ? DKSanboxDBRowViewTypeOne : DKSanboxDBRowViewTypeTwo;
    NSDictionary *dict = self.dataAtTable[indexPath.row];
    [cell renderCellWithArray:[dict allValues]];
    
    return cell;
}

#pragma mark -- DoraemonDBRowViewTypeDelegate -

- (void)rowView:(DKSanboxDBRowView *)rowView didLabelTaped:(UILabel *)label{
    NSString *content = label.text;
    [self showText:content];
}

#pragma mark -- 显示弹出文案 -

- (void)showText:(NSString *)content
{
    if (self.showView) {
        [self.showView removeFromSuperview];
    }
    DKSanboxDBShowView *showView = [[DKSanboxDBShowView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:showView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissView)];
    showView.userInteractionEnabled = YES;
    [showView addGestureRecognizer:tap];
    [showView showText:content];
    self.showView = showView;
}

- (void)dismissView
{
    if (self.showView) {
        [self.showView removeFromSuperview];
    }
}

@end
