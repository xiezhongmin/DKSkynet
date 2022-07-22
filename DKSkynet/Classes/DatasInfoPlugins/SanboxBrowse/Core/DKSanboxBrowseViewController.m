//
//  DKSanboxBrowseViewController.m
//  DKSkynet
//
//  Created by admin on 2022/7/15.
//

#import "DKSanboxBrowseViewController.h"
#import <DKKit/DKKit.h>
#import "DKSandboxBrowseModel.h"
#import "DKSanboxBrowseCell.h"
#import "UIImage+DKSanbox.h"
#import "DKSanboxBrowseDetailViewController.h"

typedef NS_ENUM(NSUInteger, DKSanboxBrowseNavigationItemType) {
    DKSanboxBrowseNavigationItemTypeNone = 0,
    DKSanboxBrowseNavigationItemTypeClose,
    DKSanboxBrowseNavigationItemTypeBack,
    DKSanboxBrowseNavigationItemTypeCopy,
};

@interface DKSanboxBrowseViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray <DKSandboxBrowseModel *> *dataSource;
@property (nonatomic, copy) NSString *rootPath;
@property (nonatomic, strong) DKSandboxBrowseModel *currentDirModel;
@property (nonatomic) dispatch_queue_t browseQueue;

@end

@implementation DKSanboxBrowseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initData];
    [self buildUI];
}

- (void)initData
{
    dispatch_queue_attr_t attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_DEFAULT, 0);
    self.browseQueue = dispatch_queue_create("com.duke.sanboxbrowse.queue", attr);
    self.dataSource = @[];
    self.rootPath = NSHomeDirectory();
}

- (void)buildUI
{
    self.title = @"沙盒浏览器";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] init];
        tableView.dataSource = self;
        tableView.delegate = self;
        CGFloat posY = DK_STATUS_BAR_HEIGHT + DK_NAV_BAR_HEIGHT;
        tableView.frame = CGRectMake(0, posY, self.view.width, self.view.height - posY);
        [tableView registerClass:DKSanboxBrowseCell.class forCellReuseIdentifier:kDKSanboxBrowseCellIdentifier];
        [self.view addSubview:tableView];
        tableView;
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadPath:self.currentDirModel.path];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:22], NSForegroundColorAttributeName:[UIColor blackColor]}];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //
    [self.navigationController.navigationBar setTitleTextAttributes:nil];
}

- (void)loadPath:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *targetPath = filePath;
    DKSandboxBrowseModel *model = [[DKSandboxBrowseModel alloc] init];
    if (!targetPath || [targetPath isEqualToString:_rootPath]) {
        targetPath = _rootPath;
        model.name = @"根目录";
        model.type = DKSandboxBrowseFileTypeRoot;
        [self setLeftBarButtonItem:DKSanboxBrowseNavigationItemTypeClose];
        [self setRightBarButtonItem:DKSanboxBrowseNavigationItemTypeNone];
    } else {
        model.name = @"返回上一级";
        model.type = DKSandboxBrowseFileTypeBack;
        [self setLeftBarButtonItem:DKSanboxBrowseNavigationItemTypeBack];
        [self setRightBarButtonItem:DKSanboxBrowseNavigationItemTypeNone];
    }
    
    model.path = filePath;
    _currentDirModel = model;
    
    // 该目录下面的内容信息
    dispatch_async(_browseQueue, ^{
        NSMutableArray *files = @[].mutableCopy;
        NSError *error = nil;
        NSArray *paths = [fileManager contentsOfDirectoryAtPath:targetPath error:&error];
        for (NSString *path in paths) {
            BOOL isDir = false;
            NSString *fullPath = [targetPath stringByAppendingPathComponent:path];
            [fileManager fileExistsAtPath:fullPath isDirectory:&isDir];
            
            DKSandboxBrowseModel *model = [[DKSandboxBrowseModel alloc] init];
            model.path = fullPath;
            model.type = isDir? DKSandboxBrowseFileTypeDirectory : DKSandboxBrowseFileTypeFile;
            model.name = path;
            
            [files addObject:model];
        }
        
        // 按名称排序, 并保持文件夹在上
        self.dataSource = [files sortedArrayUsingComparator:^NSComparisonResult(DKSandboxBrowseModel * _Nonnull obj1, DKSandboxBrowseModel * _Nonnull obj2) {
            BOOL isObj1Directory = (obj1.type == DKSandboxBrowseFileTypeDirectory);
            BOOL isObj2Directory = (obj2.type == DKSandboxBrowseFileTypeDirectory);
            // 都是目录 或 都不是目录
            BOOL isSameType = ((isObj1Directory && isObj2Directory) || (!isObj1Directory && !isObj2Directory));
            
            if (isSameType) { // 都是目录 或 都不是目录
                // 按名称排序
                return [obj1.name.lowercaseString compare:obj2.name.lowercaseString];
            }
            
            // 以下是一个为目录, 一个不为目录的情况
            if (isObj1Directory) { // obj1是目录
                // 升序，保持文件夹在上
                return NSOrderedAscending;
            }
            
            // obj2是目录，降序
            return NSOrderedDescending;
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

// MAEK: - NavBarButtonItem -

- (void)setLeftBarButtonItem:(DKSanboxBrowseNavigationItemType)type
{
    if (type == DKSanboxBrowseNavigationItemTypeClose) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage dk_xcassetImageNamed:@"dk_sanbox_close"] style:UIBarButtonItemStylePlain target:self action:@selector(closeClickAction:)];
    } else if (type == DKSanboxBrowseNavigationItemTypeBack) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage dk_xcassetImageNamed:@"dk_sanbox_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backClickAction:)];
    }
}

- (void)setRightBarButtonItem:(DKSanboxBrowseNavigationItemType)type
{
    if (type == DKSanboxBrowseNavigationItemTypeNone) {
        self.navigationItem.rightBarButtonItem = nil;
    } else if (type == DKSanboxBrowseNavigationItemTypeCopy) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(copyClickAction:)];
    }
}

#pragma mark - Action -

- (void)closeClickAction:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)backClickAction:(UIBarButtonItem *)sender
{
    [self loadPath:[_currentDirModel.path stringByDeletingLastPathComponent]];
}

- (void)copyClickAction:(UIBarButtonItem *)sender
{
    
}

#pragma mark - Getter -

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DKSanboxBrowseCell *cell = [tableView dequeueReusableCellWithIdentifier:kDKSanboxBrowseCellIdentifier forIndexPath:indexPath];
    DKSandboxBrowseModel *model = self.dataSource[indexPath.row];
    [cell renderUIWithData:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [DKSanboxBrowseCell preferredCellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DKSandboxBrowseModel *model = self.dataSource[indexPath.row];
    if (model.type == DKSandboxBrowseFileTypeFile) {
        [self handleFileWithPath:model.path];
    } else if (model.type == DKSandboxBrowseFileTypeDirectory) {
        [self loadPath:model.path];
    }
}

- (void)handleFileWithPath:(NSString *)filePath
{
    DKSanboxBrowseDetailViewController *detalVc = [[DKSanboxBrowseDetailViewController alloc] init];
    detalVc.filePath = filePath;
    [self.navigationController pushViewController:detalVc animated:YES];
}

// MARK: - Edit

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    DKSandboxBrowseModel *model = self.dataSource[indexPath.row];
    [self deleteBySandboxModel:model];
}

- (void)deleteBySandboxModel:(DKSandboxBrowseModel *)model
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:model.path error:nil];
    [self loadPath:_currentDirModel.path];
}

@end
