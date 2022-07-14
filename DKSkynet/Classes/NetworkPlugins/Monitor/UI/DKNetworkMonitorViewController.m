//
//  DKNetworkMonitorViewController.m
//  DKSkynet
//
//  Created by admin on 2022/7/4.
//

#import "DKNetworkMonitorViewController.h"
#import <DKKit/DKKit.h>
#import "DKNetworkRecorder.h"
#import "DKNetworkMonitorViewModel.h"
#import "DKNetworkMonitorCell.h"
#import "DKNetworkMonitorDetailViewController.h"
#import "DKNetworkRecordsStorage.h"

@interface DKNetworkMonitorViewController () <
    DKNetworkRecorderDelegate,
    UISearchControllerDelegate,
    UISearchResultsUpdating,
    UISearchBarDelegate,
    UITableViewDelegate,
    UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray <DKNetworkTransaction *> *incomeTransactionsNew;
@property (nonatomic, strong) DKNetworkMonitorViewModel *viewModel;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *headerLabel;
@property (nonatomic, assign) BOOL isLoadingData;
@property (nonatomic, assign) BOOL isInsertingData;
@property (nonatomic, assign) BOOL isFirstActive;

@end

@implementation DKNetworkMonitorViewController

- (void)dealloc
{
    self.viewModel = nil;
    [[DKNetworkRecorder defaultRecorder] removeDelegate:self];
    NSLog(@"DKNetworkMonitorViewController - dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[DKNetworkRecorder defaultRecorder] addDelegate:self];
    self.viewModel = [[DKNetworkMonitorViewModel alloc] init];
    self.incomeTransactionsNew = @[].mutableCopy;

    [self buildUI];
    
    [self loadTransactions];
}

- (void)buildUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"网络监控";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeBtnClicked:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"清除" style:UIBarButtonItemStylePlain target:self action:@selector(clearBtnClicked:)];
    
    self.searchController = ({
        UISearchController *searchController = [[UISearchController alloc] init];
        searchController.hidesNavigationBarDuringPresentation = NO;
        searchController.delegate = self;
        searchController.dimsBackgroundDuringPresentation = NO;
        searchController.searchBar.delegate = self;
        searchController.searchResultsUpdater = self;
        searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
        [self.view addSubview:searchController.searchBar];
        self.definesPresentationContext = YES;
        searchController;
    });

    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] init];
        tableView.delegate = self;
        tableView.dataSource = self;
        if (@available(iOS 15.0, *)) {
            tableView.sectionHeaderTopPadding = 0;
        } else {
            // Fallback on earlier versions
        }
        [tableView registerClass:[DKNetworkMonitorCell class] forCellReuseIdentifier:kDKNetworkMonitorCellIdentifier];
        [self.view addSubview:tableView];
        tableView;
    });
}

- (void)closeBtnClicked:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clearBtnClicked:(UIButton *)sender
{
    [[DKNetworkRecordsStorage shared] removeAllNetworkTransactions:^{
        [self.viewModel removeAllTransactions];
        [self.tableView reloadData];
    }];
}

- (void)loadTransactions
{
    if (!self.headerLabel) {
        self.headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width - 20, 30)];
    }
    self.headerLabel.text = @"Loading ...";
    self.isLoadingData = YES;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.viewModel loadTransactions];
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [self.tableView reloadData];
            self.isLoadingData = NO;
            
            NSInteger totalRequest = 0;
            NSInteger totalResponse = 0;
            for (DKNetworkTransaction *transaction in self.viewModel.networkTransactions) {
                totalRequest += transaction.requestLength;
                totalResponse += transaction.responseLength;
            }
            NSInteger total = totalRequest + totalResponse;
            self.headerLabel.text = [NSString stringWithFormat:@"⇅ %@, ↑ %@, ↓ %@",
                                     [NSByteCountFormatter stringFromByteCount:total
                                                                    countStyle:NSByteCountFormatterCountStyleBinary],
                                     [NSByteCountFormatter stringFromByteCount:totalRequest
                                                                    countStyle:NSByteCountFormatterCountStyleBinary],
                                     [NSByteCountFormatter stringFromByteCount:totalResponse
                                                                    countStyle:NSByteCountFormatterCountStyleBinary]];
        });
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (self.searchController.isActive) {
        [self.view setNeedsLayout];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

    if (!self.view.window && self.searchController.isActive) {
        [self.searchController setActive:NO];
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGFloat top = [self p_navigationBarTopLayoutGuide].length;
    CGFloat tableTop = top + self.searchController.searchBar.height;
    CGFloat tableHeight = DK_SCREEN_HEIGHT - tableTop;
    self.tableView.frame = CGRectMake(0, tableTop, DK_SCREEN_WIDTH, tableHeight);
    
    if (self.searchController.isActive) {
        self.searchController.searchBar.top = 0;
    } else {
        self.searchController.searchBar.top = top;
    }
}

- (id<UILayoutSupport>)p_navigationBarTopLayoutGuide {
    UIViewController *cur = self;
    while (cur.parentViewController && ![cur.parentViewController isKindOfClass:UINavigationController.class]) {
        cur = cur.parentViewController;
    }

    return cur.topLayoutGuide;
}


#pragma mark - DKNetworkRecorder -

- (void)recorderNewTransaction:(DKNetworkTransaction *)transaction
{
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        @synchronized(self.incomeTransactionsNew) {
            [self.incomeTransactionsNew insertObject:transaction atIndex:0];
        }

        [self tryUpdateTransactions];
    });
}

- (void)tryUpdateTransactions
{
    if (self.isLoadingData || self.isInsertingData || self.searchController.isActive) {
        return;
    }
    
    NSInteger addedRowCount = 0;
    @synchronized(self.incomeTransactionsNew) {
        if (self.incomeTransactionsNew.count == 0)
            return;

        addedRowCount = [self.incomeTransactionsNew count];
        [self.viewModel incomeNewTransactions:[self.incomeTransactionsNew copy]];
        [self.incomeTransactionsNew removeAllObjects];
    }
    
    if (addedRowCount != 0 && !self.viewModel.isPresentingSearch) {
        // insert animation if we're at the top.
        if (self.tableView.contentOffset.y <= 0.f) {
            [CATransaction begin];

            self.isInsertingData = YES;
            [CATransaction setCompletionBlock:^{
                self.isInsertingData = NO;
                [self tryUpdateTransactions];
            }];

            NSMutableArray *indexPathsToReload = [NSMutableArray array];
            for (NSInteger row = 0; row < addedRowCount; row++) {
                [indexPathsToReload addObject:[NSIndexPath indexPathForRow:row inSection:0]];
            }
            [self.tableView insertRowsAtIndexPaths:indexPathsToReload withRowAnimation:UITableViewRowAnimationAutomatic];

            [CATransaction commit];
        } else {
            // Maintain the user's position if they've scrolled down.
            CGSize existingContentSize = self.tableView.contentSize;
            [self.tableView reloadData];
            CGFloat contentHeightChange = self.tableView.contentSize.height - existingContentSize.height;
            self.tableView.contentOffset = CGPointMake(self.tableView.contentOffset.x, self.tableView.contentOffset.y + contentHeightChange);
        }
    }
}

- (void)recorderTransactionUpdated:(DKNetworkTransaction *)transaction currentState:(DKNetworkTransactionState)state
{
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        for (DKNetworkMonitorCell *cell in [self.tableView visibleCells]) {
            if ([cell.transaction isEqual:transaction]) {
                [cell setNeedsLayout];
                break;
            }
        }
    });
}


#pragma mark - UITableViewDataSource -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchController.isActive) {
        return self.viewModel.filteredNetworkTransactions.count;
    } else {
        return self.viewModel.networkTransactions.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DKNetworkMonitorCell *cell = [tableView dequeueReusableCellWithIdentifier:kDKNetworkMonitorCellIdentifier forIndexPath:indexPath];

    NSArray *transactions = nil;
    if (self.searchController.isActive) {
        transactions = [self.viewModel filteredNetworkTransactions];
    } else {
        transactions = [self.viewModel networkTransactions];
    }
    
    if (indexPath.row < transactions.count) {
        cell.transaction = transactions[indexPath.row];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [DKNetworkMonitorCell preferredCellHeight];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (!self.headerLabel) {
        self.headerLabel = [[UILabel alloc] init];
    }
    self.headerLabel.textColor = [UIColor colorWithWhite:0.0667 alpha:1];
    self.headerLabel.font = [UIFont systemFontOfSize:12.0];
    self.headerLabel.textAlignment = NSTextAlignmentLeft;
    self.headerLabel.numberOfLines = 1;
    UIView *headerView = [[UIView alloc] init];
    [headerView addSubview:self.headerLabel];
    headerView.backgroundColor = [UIColor colorWithRed:243.0 / 255 green:242.0 / 255 blue:242.0 / 255 alpha:1.0];

    return headerView;
}

#pragma mark - UITableViewDelegate -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DKNetworkMonitorDetailViewController *detailViewController = [[DKNetworkMonitorDetailViewController alloc] init];
    DKNetworkTransaction *transaction;
    if (self.searchController.isActive) {
        transaction = self.viewModel.filteredNetworkTransactions[indexPath.row];
    } else {
        transaction = self.viewModel.networkTransactions[indexPath.row];
    }
    detailViewController.transaction = transaction;
    [self.navigationController pushViewController:detailViewController animated:YES];
}


#pragma mark - UISearchControllerDelegate -

- (void)willPresentSearchController:(UISearchController *)searchController {
    self.viewModel.isPresentingSearch = YES;
}

- (void)didPresentSearchController:(UISearchController *)searchController {
    self.viewModel.isPresentingSearch = NO;

    UIView *searchBarContainer = searchController.searchBar.superview;
    UIView *searchBar = searchController.searchBar;
    if (!CGPointEqualToPoint(searchBarContainer.frame.origin, CGPointZero)) {
        CGFloat top = [self p_navigationBarTopLayoutGuide].length;
        CGRect frame = CGRectMake(0, top, searchBarContainer.bounds.size.width, searchBarContainer.bounds.size.height);
        searchBarContainer.frame = frame;
    }
    if (!CGPointEqualToPoint(searchBar.frame.origin, CGPointZero)) {
        CGRect frame = CGRectMake(0, 0, searchBar.bounds.size.width, searchBar.bounds.size.height);
        searchBar.frame = frame;
    }
}

- (void)willDismissSearchController:(UISearchController *)searchController {
    [self.tableView reloadData];
}

#pragma mark - UISearchBarDelegate -

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length > 0) {
        searchBar.text = [searchText lowercaseString];
    }
    
    [self updateSearchResults];
}

- (void)updateSearchResults
{
    NSString *searchString = self.searchController.searchBar.text;
    __weak typeof(self) wself = self;
    [self.viewModel updateSearchResultsWithText:searchString completion:^{
        [wself.tableView reloadData];
    }];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

#pragma mark - UISearchResultsUpdating -

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    [self updateSearchResults];
}

@end
