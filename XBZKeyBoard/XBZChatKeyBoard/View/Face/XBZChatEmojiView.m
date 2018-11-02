//
//  XBZChatEmojiView.m
//  XBZKeyBoard
//
//  Created by BigKing on 2018/10/19.
//  Copyright © 2018年 BigKing. All rights reserved.
//

#import "XBZChatEmojiView.h"

@implementation XBZChatEmojiBottomView

- (instancetype)init {
    if (self = [super init]) {
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRGB:0x26b8f2]] forState:UIControlStateNormal];
        [_sendButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRGB:0xf8f8f8]] forState:UIControlStateDisabled];
        [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sendButton setTitleColor:[UIColor colorWithRGB:0x666666] forState:UIControlStateDisabled];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        _sendButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:_sendButton];
        
        _scrollView = [UIScrollView new];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.scrollEnabled = YES;
    
        [self addSubview:_scrollView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.sendButton.frame = CGRectMake(self.width-kSendButtonWidth, 0, kSendButtonWidth, self.height);
    self.scrollView.frame = CGRectMake(0, 0, self.sendButton.left, self.height);
}

@end


@interface XBZChatEmojiView () <UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate>

//当前表情组的总页数
@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation XBZChatEmojiView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {

        XBZEmojiFlowLayout *layout = [XBZEmojiFlowLayout new];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.bounces = YES;
        _collectionView.backgroundColor = [UIColor colorWithRGB:0xf5f5f5];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[XBZEmojiCollectionViewCell class] forCellWithReuseIdentifier:kXBZEmojiCollectionViewCellId];
        [self addSubview:_collectionView];
        
        _pageControl = [UIPageControl new];
        _pageControl.currentPageIndicatorTintColor = [UIColor darkGrayColor];
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        _pageControl.userInteractionEnabled = NO;
        
        _pageControl.numberOfPages = XBZChatKeyBoardManager.sharedManager.groupEmojis[0].totalPages;
        
        [self addSubview:_pageControl];
        
        _bottomView = [XBZChatEmojiBottomView new];
        _bottomView.backgroundColor = [UIColor colorWithRGB:0xfafafa];
        [_bottomView.sendButton addTarget:self action:@selector(clickSendButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_bottomView];
        
        NSArray<XBZGroupEmojiModel *> *groupArray = XBZChatKeyBoardManager.sharedManager.groupEmojis;
        for (int i = 0; i < groupArray.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(i*kEmojiGroupButtonWidth, 0, kEmojiGroupButtonWidth, kEmojiGroupButtonHeight);
            [button setImage:[UIImage imageNamed:XBZChatKeyBoardManager.sharedManager.groupEmojis[i].groupImage] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRGB:0xfafafa]] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRGB:0xf5f5f5]] forState:UIControlStateSelected];
            [button addTarget:self action:@selector(clickGroupButton:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = i;
            if (i == 0) {
                button.selected = YES;
            }
            [_bottomView.scrollView addSubview:button];
            
        }
        _bottomView.scrollView.contentSize = CGSizeMake(groupArray.count*kEmojiGroupButtonWidth, kEmojiBottomHeight);
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.collectionView.frame = CGRectMake(0, 0, self.width, self.height-kPageControlHeight-kEmojiBottomHeight);
    self.pageControl.frame = CGRectMake(0, self.collectionView.bottom, self.width, kPageControlHeight);
    self.bottomView.frame = CGRectMake(0, self.pageControl.bottom, self.width, kEmojiBottomHeight);
}

//MARK: - Delegate & DataSource

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (XBZChatKeyBoardManager.sharedManager.groupEmojis[indexPath.section].type == XBZChatEmojiBig) {
        
        return CGSizeMake(SCREEN_Width / kBigEmojiCol, (kBottomViewHeight-kPageControlHeight-kEmojiBottomHeight) / kBigEmojiRow);
    }else {
        return CGSizeMake(SCREEN_Width / kSmallEmojiCol, (kBottomViewHeight-kPageControlHeight-kEmojiBottomHeight) / kSmallEmojiRow);
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return XBZChatKeyBoardManager.sharedManager.groupEmojis.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (XBZChatKeyBoardManager.sharedManager.groupEmojis[section].type == XBZChatEmojiBig) {
        return XBZChatKeyBoardManager.sharedManager.groupEmojis[section].faces.count;
    }
    NSInteger count = XBZChatKeyBoardManager.sharedManager.groupEmojis[section].emojis.count;
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XBZEmojiCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kXBZEmojiCollectionViewCellId forIndexPath:indexPath];
    
    if (XBZChatKeyBoardManager.sharedManager.groupEmojis[indexPath.section].type == XBZChatEmojiSmall) {
        cell.emojiModel = XBZChatKeyBoardManager.sharedManager.groupEmojis[indexPath.section].emojis[indexPath.row];
    }else {
        cell.faceModel = XBZChatKeyBoardManager.sharedManager.groupEmojis[indexPath.section].faces[indexPath.row];
    }
    

    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (XBZChatKeyBoardManager.sharedManager.groupEmojis[_currentIndex].type == XBZChatEmojiSmall) {
        if ([self.delegate respondsToSelector:@selector(chatEmojiViewDidSelectEmojiWithContent:)]) {
            [self.delegate chatEmojiViewDidSelectEmojiWithContent:XBZChatKeyBoardManager.sharedManager.groupEmojis[_currentIndex].emojis[indexPath.row]];
        }
    }else {
        
        if ([self.delegate respondsToSelector:@selector(chatEmojiViewDidSelectFaceWithContent:)]) {
            [self.delegate chatEmojiViewDidSelectFaceWithContent:XBZChatKeyBoardManager.sharedManager.groupEmojis[_currentIndex].faces[indexPath.row]];
        }
    }
    
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat x = scrollView.contentOffset.x;

    CGFloat totalX = 0.f;
    for (int i = 0; i < XBZChatKeyBoardManager.sharedManager.groupEmojis.count; i++) {
        XBZGroupEmojiModel *groupModel = XBZChatKeyBoardManager.sharedManager.groupEmojis[i];
        totalX += groupModel.totalPages * self.width;
        if (x < totalX) {
            for (UIView *subView in self.bottomView.scrollView.subviews) {
                if ([subView isKindOfClass:[UIButton class]]) {
                    UIButton *btn = (UIButton *)subView;
                    if (btn.tag == i) {
                        [self contentOffsetChangedWithButton:btn];
                        break;
                    }
                }
            }
            break;
        }
    }
}


//MARK: - Actions

- (void)clickSendButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(chatEmojiViewClickSendButton:)]) {
        [self.delegate chatEmojiViewClickSendButton:sender];
    }
}

//点击表情组按钮
- (void)clickGroupButton:(UIButton *)sender {
    
    if (!sender.selected) {
        sender.selected = !sender.selected;
    }else {
        return; //当按钮为选中时，不进行下面的操作
    }
    [self buttonStateChanged:sender];
    
    CGFloat x = 0.f;
    if (sender.tag != 0) {
        for (int i = 0; i < sender.tag; i++) {
            XBZGroupEmojiModel *groupModel = XBZChatKeyBoardManager.sharedManager.groupEmojis[i];
            x += (groupModel.totalPages * self.width);
        }
    }
    
    [self.collectionView setContentOffset:CGPointMake(x, self.collectionView.contentOffset.y) animated:NO];
    NSInteger totalPages = XBZChatKeyBoardManager.sharedManager.groupEmojis[sender.tag].totalPages;
    NSInteger page = 0;
    
    self.pageControl.numberOfPages = totalPages == 1 ? 0:totalPages;
    self.pageControl.currentPage = page;
}


//scorllview contentoffset变化
- (void)contentOffsetChangedWithButton:(UIButton *)sender {
    
    if (!sender.selected) {
        sender.selected = !sender.selected;
    }
    [self buttonStateChanged:sender];
    
    CGFloat x = 0.f;
    if (sender.tag != 0) {
        for (int i = 0; i < sender.tag; i++) {
            XBZGroupEmojiModel *groupModel = XBZChatKeyBoardManager.sharedManager.groupEmojis[i];
            x += (groupModel.totalPages * self.width);
        }
    }
    
    [self.collectionView setContentOffset:CGPointMake(self.collectionView.contentOffset.x, self.collectionView.contentOffset.y) animated:YES];
    NSInteger totalPages = XBZChatKeyBoardManager.sharedManager.groupEmojis[sender.tag].totalPages;
    NSInteger page = (self.collectionView.contentOffset.x - x) / self.width;
    
    self.pageControl.numberOfPages = totalPages == 1 ? 0:totalPages;
    self.pageControl.currentPage = page;

}

//按钮发生变化，点击或者滚动时
- (void)buttonStateChanged:(UIButton *)sender {
    _currentIndex = sender.tag;
    
    for (UIView *subView in self.bottomView.scrollView.subviews) {
        
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)subView;
            if (![button isEqual:sender]) {
                button.selected = NO;
            }
        }
    }
}


@end
