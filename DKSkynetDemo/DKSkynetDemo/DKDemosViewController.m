//
//  ViewController.m
//  DKSkynetDemo
//
//  Created by admin on 2022/5/26.
//

#import "DKDemosViewController.h"
#import <DKNetworkTransaction.h>
#import <DKNetworkTransactionsURLFilter.h>
#import <DKSkynet/DKSkynetStorage.h>
#import "DKNetworkMonitorDemoViewController.h"
#import <DKKit/DKKitMacro.h>
#import <DKSkynet/DKSkynet.h>

static NSString const * kDKTableSectionTitleKey = @"title";
static NSString const * kDKTableSectionRowsKey = @"rows";
static NSString const * kDKTableRowNameKey = @"name";
static NSString const * kDKTableRowClassKey = @"class";

@interface DKDemosViewController ()
@property (nonatomic, copy) NSArray <NSDictionary *> *dataSource;
@end

@implementation DKDemosViewController
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.dataSource =
    @[
        @{ kDKTableSectionTitleKey : @"Network", kDKTableSectionRowsKey: @[
            @{ kDKTableRowNameKey : @"NetworkMonitorDemo", kDKTableRowClassKey :  DKNetworkMonitorDemoViewController.class }
        ] },
        @{ kDKTableSectionTitleKey : @"CustomPlugins", kDKTableSectionRowsKey: @[
            @{ kDKTableRowNameKey : @"SettingPluginDemo", kDKTableRowClassKey :  UIViewController.class }
        ] }
    ];
}
- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // do nothing
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = DK_RGB(242, 242, 247);
    self.title = @"DKSkynet";
    NSLog(@"FileDir= %@", [DKSkynetStorage shared].storeDirectory);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataSource count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource[section][kDKTableSectionRowsKey] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class)];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(UITableViewCell.class)];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSString *content = self.dataSource[indexPath.section][kDKTableSectionRowsKey][indexPath.row][kDKTableRowNameKey];
    cell.textLabel.text = content;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *model = self.dataSource[indexPath.section][kDKTableSectionRowsKey][indexPath.row];
    UIViewController *controller = [[model[kDKTableRowClassKey] alloc] init];
    controller.view.backgroundColor = [UIColor whiteColor];
    controller.title = model[kDKTableRowNameKey];
    [self.navigationController pushViewController:controller animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.dataSource[section][kDKTableSectionTitleKey];
}

@end
