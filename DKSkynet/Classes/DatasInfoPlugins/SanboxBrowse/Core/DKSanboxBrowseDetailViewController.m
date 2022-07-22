//
//  DKSanboxBrowseDetailViewController.m
//  DKSkynet
//
//  Created by admin on 2022/7/22.
//

#import "DKSanboxBrowseDetailViewController.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import <QuickLook/QuickLook.h>
#import <DKSkynet/DKSkynetToastUtil.h>
#import <DKSkynet/DKSkynetUtility.h>
#import "DKSanboxDBManager.h"
#import <DKKit/UIView+DKUtils.h>
#import "DKSanboxDBTableViewController.h"
#import "DKSanboxUtils.h"

@interface DKSanboxBrowseDetailViewController () <QLPreviewControllerDelegate, QLPreviewControllerDataSource, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, copy) NSArray *tableNameArray;
@property (nonatomic, strong) UITableView *dbTableNameTableView;

@end

@implementation DKSanboxBrowseDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self buildUI];
}

- (void)buildUI
{
    self.title = @"文件预览";
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (self.filePath.length > 0) {
        NSString *path = self.filePath;
        NSData *fileData = [NSData dataWithContentsOfFile:self.filePath];
        if (!fileData.length) {
            [DKSkynetToastUtil showToastBlack:@"文件不存在" inView:self.view];
            return;
        }
        
        if ([path hasSuffix:@".strings"] || [path hasSuffix:@".plist"]) {
            // 文本文件
            [self setContent:[[NSDictionary dictionaryWithContentsOfFile:path] description]];
        } else if ([path hasSuffix:@".DB"] || [path hasSuffix:@".db"] || [path hasSuffix:@".sqlite"] || [path hasSuffix:@".SQLITE"] || [self isSQLiteFile:self.filePath]) {
            // 数据库文件
            self.title = @"数据库预览";
            [self browseDBTable];
        } else if ([[path lowercaseString] hasSuffix:@".webp"]) {
            // webp文件
            // 待实现
        } else if ([[path lowercaseString] hasSuffix:@".json"]) {
            NSString *prettyString = [DKSkynetUtility prettyJSONStringFromData:fileData];
            [self setContent:prettyString];
        } else {
            NSString *fileString = [NSString stringWithUTF8String:fileData.bytes];
            if (fileString.length) {
//                NSString *htmlString = [NSString stringWithFormat:@"<head><meta name='viewport' content='initial-scale=1.0'></head><body><pre>%@</pre></body>", [DKSkynetUtility stringByEscapingHTMLEntitiesInString:fileString]];
                [self setContent:fileString];
            } else {
                // 其他文件 尝试使用 QLPreviewController 进行打开
                QLPreviewController *previewController = [[QLPreviewController alloc] init];
                previewController.delegate = self;
                previewController.dataSource = self;
                [self presentViewController:previewController animated:YES completion:nil];
            }
        }
    } else {
        [DKSkynetToastUtil showToastBlack:@"文件不存在" inView:self.view];
    }
}

- (void)setContent:(NSString *)text {
    _textView = [[UITextView alloc] initWithFrame:self.view.bounds];
    _textView.font = [UIFont systemFontOfSize:12.0f];
    _textView.textColor = [UIColor blackColor];
    _textView.textAlignment = NSTextAlignmentLeft;
    _textView.editable = NO;
    _textView.dataDetectorTypes = UIDataDetectorTypeLink;
    _textView.scrollEnabled = YES;
    _textView.bouncesZoom = YES;
    _textView.maximumZoomScale = 1.5;
    _textView.minimumZoomScale = 0.8;
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.layer.borderColor = [UIColor grayColor].CGColor;
    _textView.layer.borderWidth = 2.0f;
    _textView.text = text;
#if defined(__IPHONE_13_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0)
    if (@available(iOS 13.0, *)) {
        _textView.textColor = [UIColor labelColor];
        _textView.backgroundColor = [UIColor systemBackgroundColor];
    } else {
#endif
        _textView.textColor = [UIColor blackColor];
        _textView.backgroundColor = [UIColor whiteColor];
#if defined(__IPHONE_13_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0)
    }
#endif
    [self.view addSubview:_textView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_textView.text.length) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Copy" style:UIBarButtonItemStyleDone target:self action:@selector(actionCopyTapped:)];
    } else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionSharedTapped:)];
    }
  
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //
}

#pragma mark - Action -

- (void)actionCopyTapped:(id)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    NSString *copyString = _textView.text;
    
    UIAlertAction *copyAction = [UIAlertAction actionWithTitle:@"Copy"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *_Nonnull action) {
                                                              [[UIPasteboard generalPasteboard] setString:copyString];
                                                          }];
    UIAlertAction *airDropAction = [UIAlertAction actionWithTitle:@"AirDrop"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *_Nonnull action) {
                                                            [self shareFileWithPath:self.filePath];
                                                          }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:copyAction];
    [alertController addAction:airDropAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)actionSharedTapped:(id)sender
{
    [self shareFileWithPath:self.filePath];
}

- (void)shareFileWithPath:(NSString *)filePath {
    [DKSanboxUtils shareURL:[NSURL fileURLWithPath:filePath] formVC:self];
}

// 浏览数据库中所有数据表
- (void)browseDBTable
{
    [DKSanboxDBManager shareManager].dbPath = self.filePath;
    self.tableNameArray = [[DKSanboxDBManager shareManager] tablesAtDB];
    self.dbTableNameTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStylePlain];
    self.dbTableNameTableView.delegate = self;
    self.dbTableNameTableView.dataSource = self;
    [self.view addSubview:self.dbTableNameTableView];
}

#pragma mark - Private Methods -

- (BOOL)isSQLiteFile:(NSString *)file {
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:file];
    if (!fileHandle) {
        return NO;
    }
    NSData *data = [fileHandle readDataOfLength:16];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [fileHandle closeFile];
    if ([str isEqual:@"SQLite format 3\0"]) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - UITableViewDelegate, UITableViewDataSource -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableNameArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifer = @"db_table_name";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    cell.textLabel.text = self.tableNameArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *tableName = [self.tableNameArray objectAtIndex:indexPath.row];
    [DKSanboxDBManager shareManager].tableName = tableName;
    
    DKSanboxDBTableViewController *vc = [[DKSanboxDBTableViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - QLPreviewControllerDataSource, QLPreviewControllerDelegate
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller{
    return 1;
}

- (id)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index{
    return [NSURL fileURLWithPath:self.filePath];
}

- (void)previewControllerDidDismiss:(QLPreviewController *)controller {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
