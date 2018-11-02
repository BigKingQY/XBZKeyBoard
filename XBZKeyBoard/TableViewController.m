//
//  TableViewController.m
//  XBZKeyBoard_Demo
//
//  Created by BigKing on 2018/11/1.
//  Copyright © 2018 BigKing. All rights reserved.
//

#import "TableViewController.h"
#import "Masonry.h"

@interface TableViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, XBZChatKeyBoardViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) XBZChatKeyBoardView *keyBoardView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"加一" style:UIBarButtonItemStylePlain target:self action:@selector(clickAdd:)];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"减一" style:UIBarButtonItemStylePlain target:self action:@selector(clickSub:)];
    self.navigationItem.rightBarButtonItems = @[item1, item2];
    self.title = @"聊天界面";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.keyBoardView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.keyBoardView.mas_top);
    }];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self.tableView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}

//MARK: - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentSize"]) {
        CGSize size = [change[NSKeyValueChangeNewKey] CGSizeValue];
        if (size.height > self.tableView.height) {
            [self.tableView scrollToBottomAnimated:YES];
        }
    }
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

//MARK: - Delegate & DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    if ([self.dataArray[indexPath.row] isKindOfClass:[NSString class]]) {
       cell.textLabel.text = self.dataArray[indexPath.row];
    }else {
        cell.textLabel.attributedText = self.dataArray[indexPath.row];
    }
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"第%ld行", indexPath.row+1];
    
    return cell;
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.keyBoardView hideBottomView];
}


//MARK: - XBZChatKeyBoardViewDelegate

- (void)chatKeyBoardViewSelectMoreImteTitle:(NSString *)title index:(NSInteger)index {
    
}


- (void)chatKeyBoardViewSendPhotoMessage:(nonnull NSString *)photo {
    
}


- (void)chatKeyBoardViewSendTextMessage:(nonnull NSMutableAttributedString *)text originText:(nonnull NSString *)originText {
    [self.dataArray addObject:text];
    [self.tableView reloadData];
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    
}


- (void)chatKeyBoardViewSendVoiceMessage:(nonnull NSString *)voicePath {
    
}


//MARK: - Actions

- (void)tap:(UITapGestureRecognizer *)tap {
    [self.keyBoardView hideBottomView];
}

- (void)clickAdd:(UIBarButtonItem *)item {
    [self.dataArray addObject:@"Test"];
    [self.tableView reloadData];
}

- (void)clickSub:(UIBarButtonItem *)item {
    [self.dataArray removeLastObject];
    [self.tableView reloadData];
}

//MARK: - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor colorWithRGB:0xf5f5f5];
        [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
        [_tableView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
    }
    return _tableView;
}

- (XBZChatKeyBoardView *)keyBoardView {
    if (!_keyBoardView) {
        _keyBoardView = [[XBZChatKeyBoardView alloc] initWithNavigationBarTranslucent:NO];
        _keyBoardView.delegate = self;
        _keyBoardView.tableView = self.tableView;
    }
    return _keyBoardView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray =[NSMutableArray array];
    }
    return _dataArray;
}


@end
