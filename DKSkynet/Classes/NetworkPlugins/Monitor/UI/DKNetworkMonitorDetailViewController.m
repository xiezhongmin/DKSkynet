//
//  DKNetworkMonitorDetailViewController.m
//  DKSkynet
//
//  Created by admin on 2022/7/8.
//

#import "DKNetworkMonitorDetailViewController.h"
#import "DKNetworkTransaction.h"
#import "DKNetworkRecorder.h"
#import "DKNetworkMonitorDetailWebCell.h"
#import "DKNetworkMonitorDetailMultilineCell.h"
#import "DKNetworkMonitorDetailSection.h"
#import "DKNetworkMonitorDetailViewModel.h"
#import "DKNetworkCurlLogger.h"
#import <DKSkynet/DKSkynetUtility.h>

@interface DKNetworkMonitorDetailViewController () <DKNetworkRecorderDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) DKNetworkMonitorDetailViewModel *viewModel;

@end

@implementation DKNetworkMonitorDetailViewController

- (void)dealloc
{
    [[DKNetworkRecorder defaultRecorder] removeDelegate:self];
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // do nothing
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[DKNetworkRecorder defaultRecorder] addDelegate:self];
    
    self.viewModel = [[DKNetworkMonitorDetailViewModel alloc] init];
        
    [self.tableView registerClass:[DKNetworkMonitorDetailMultilineCell class] forCellReuseIdentifier:kDKNetworkMonitorDetailMultilineCellIdentifier];
    
//    [self.tableView registerClass:[DKNetworkMonitorDetailWebCell class] forCellReuseIdentifier:kDKNetworkMonitorDetailWebCellIdentifier];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Copy" style:UIBarButtonItemStyleDone target:self action:@selector(actionBtnTapped:)];
    
    [self.viewModel rebuildTableSections:self.transaction];
}

- (void)actionBtnTapped:(id)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    NSString *curlString = [DKNetworkCurlLogger curlCommandString:_transaction.request];
    NSMutableString *allDetailString = [NSMutableString stringWithFormat:@"# %@\n", self.title];
    NSMutableString *mainDetailString = [NSMutableString stringWithFormat:@"# %@\n", self.title];
    
    for (DKNetworkMonitorDetailSection *section in self.viewModel.sections) {
        if ([section.title isEqualToString:kDKNetworkMonitorDetailTableSectionGeneral]) {
            [mainDetailString appendFormat:@"\n## %@\n", section.title];
            for (int i = 0; i < 4; i++) {
                DKNetworkMonitorDetailRow *row = section.rows[i];
                [mainDetailString appendFormat:@"* %@:   %@\n", row.title, row.detailText];
            }
        }
        if ([section.title isEqualToString:kDKNetworkMonitorDetailTableSectionRequestBody]) {
            [mainDetailString appendFormat:@"\n## %@\n", section.title];
            for (DKNetworkMonitorDetailRow *row in section.rows) {
                [mainDetailString appendFormat:@"* %@:   %@\n", row.title, row.detailText];
            }
        }
        if ([section.title isEqualToString:kDKNetworkMonitorDetailTableSectionResponseBody]) {
            [mainDetailString appendFormat:@"\n## %@\n", section.title];
            for (DKNetworkMonitorDetailRow *row in section.rows) {
                [mainDetailString appendFormat:@"* %@:   %@\n", row.title, row.detailText];
            }
        }
        
        [allDetailString appendFormat:@"\n## %@\n", section.title];
        for (DKNetworkMonitorDetailRow *row in section.rows) {
            [allDetailString appendFormat:@"* %@:   %@\n", row.title, row.detailText];
        }
 
    }
    UIAlertAction *copyURLAction = [UIAlertAction actionWithTitle:@"Copy Curl"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *_Nonnull action) {
                                                              [[UIPasteboard generalPasteboard] setString:curlString];
                                                          }];
    UIAlertAction *copyMainAction = [UIAlertAction actionWithTitle:@"Copy Main Detail"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *_Nonnull action) {
                                                              [[UIPasteboard generalPasteboard] setString:[mainDetailString copy]];
                                                          }];
    UIAlertAction *copyAllAction = [UIAlertAction actionWithTitle:@"Copy All Detail"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *_Nonnull action) {
                                                              [[UIPasteboard generalPasteboard] setString:[allDetailString copy]];
                                                          }];
    UIAlertAction *airDropAction = [UIAlertAction actionWithTitle:@"AirDrop All Detail"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *_Nonnull action) {
                                                              UIActivityViewController *airDropVC = [[UIActivityViewController alloc] initWithActivityItems:@[ curlString, allDetailString ] applicationActivities:nil];
                                                              [self presentViewController:airDropVC animated:YES completion:nil];
                                                          }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:copyURLAction];
    [alertController addAction:copyMainAction];
    [alertController addAction:copyAllAction];
    [alertController addAction:airDropAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)setTransaction:(DKNetworkTransaction *)transaction
{
    if (![_transaction isEqual:transaction]) {
        _transaction = transaction;
        self.title = [NSString stringWithFormat:@"%@", [transaction.request.URL lastPathComponent]];
    }
}

#pragma mark - private -

- (DKNetworkMonitorDetailRow *)rowModelAtIndexPath:(NSIndexPath *)indexPath
{
    DKNetworkMonitorDetailSection *sectionModel = self.viewModel.sections[indexPath.section];
    return sectionModel.rows[indexPath.row];
}


#pragma mark - DKNetworkRecorderDelegate -

- (void)recorderTransactionUpdated:(DKNetworkTransaction *)transaction currentState:(DKNetworkTransactionState)state
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (transaction == self.transaction ) {
            [self.viewModel rebuildTableSections:transaction];
            [self.tableView reloadData];
        }
    });
}

#pragma mark - UITableViewDataSource, UITableViewDelegate -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.viewModel.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    DKNetworkMonitorDetailSection *sectionModel = self.viewModel.sections[section];
    return [sectionModel.rows count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DKNetworkMonitorDetailRow *rowModel = [self rowModelAtIndexPath:indexPath];
    if (rowModel.style == DKNetworkMonitorDetailRowWeb) {
        // 此处 cell 重用比较耗性能, 解决: 为每个 cell 都拥有一个独立的标识
        NSString *cellIdentifier = [NSString stringWithFormat:@"%@-%ld", kDKNetworkMonitorDetailWebCellIdentifier, indexPath.row];
        DKNetworkMonitorDetailWebCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[DKNetworkMonitorDetailWebCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            [cell webViewLoadString:rowModel.detailText];
        }
        return cell;
    } else {
        DKNetworkMonitorDetailMultilineCell *cell = [tableView dequeueReusableCellWithIdentifier:kDKNetworkMonitorDetailMultilineCellIdentifier forIndexPath:indexPath];
        cell.textLabel.attributedText = [[self.viewModel class] attributedTextForRow:rowModel];
        cell.accessoryType = rowModel.selectionFuture ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
        cell.selectionStyle = rowModel.selectionFuture ? UITableViewCellSelectionStyleDefault : UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    DKNetworkMonitorDetailSection *sectionModel = self.viewModel.sections[section];
    return sectionModel.title;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DKNetworkMonitorDetailRow *rowModel = [self rowModelAtIndexPath:indexPath];
    if (rowModel.cacheCellHeight) {
        return rowModel.cacheCellHeight;
    }
    
    CGFloat cellHeight = 0;
    NSAttributedString *attributedText = [[self.viewModel class] attributedTextForRow:rowModel];
    if (rowModel.style == DKNetworkMonitorDetailRowDefault) {
        BOOL showsAccessory = rowModel.selectionFuture != nil;
        cellHeight = [DKNetworkMonitorDetailMultilineCell preferredHeightWithAttributedText:attributedText inTableViewWidth:self.tableView.bounds.size.width style:UITableViewStyleGrouped showsAccessory:showsAccessory];
    } else {
        NSString *title = rowModel.title ? [NSString stringWithFormat:@"%@: ", rowModel.title] : @"";
        NSString *detailText = rowModel.detailText ?: @"";
        NSString *htmlString = [NSString stringWithFormat:@"<head><meta name='viewport' content='initial-scale=1.0'></head><body><pre>%@</pre></body>", [DKSkynetUtility stringByEscapingHTMLEntitiesInString:[title stringByAppendingString:detailText]]];
        NSInteger count = 0;
        for (int i = 0; i < htmlString.length; i++) {
            if ([[htmlString substringWithRange:NSMakeRange(i, 1)] isEqualToString:@"\n"]) {
                count += 1;
            }
        }
        cellHeight = count ? count * ([[self.viewModel class] defaultTableCellFont].pointSize + 3) + 20.0 : 26.0;
    }
    
    rowModel.cacheCellHeight = cellHeight;
    
    return cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DKNetworkMonitorDetailRow *rowModel = [self rowModelAtIndexPath:indexPath];
    UIViewController *viewControllerToPush = nil;
    if (rowModel.selectionFuture) {
        viewControllerToPush = rowModel.selectionFuture();
    }

    if (viewControllerToPush) {
        [self.navigationController pushViewController:viewControllerToPush animated:YES];
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Cell Copying -

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    return action == @selector(copy:);
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    if (action == @selector(copy:)) {
        DKNetworkMonitorDetailRow *rowModel = [self rowModelAtIndexPath:indexPath];
        [[UIPasteboard generalPasteboard] setString:rowModel.detailText];
    }
}

@end

