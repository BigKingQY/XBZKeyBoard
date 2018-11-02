//
//  XBZChatMoreView.m
//  XBZKeyBoard
//
//  Created by BigKing on 2018/10/25.
//  Copyright © 2018年 BigKing. All rights reserved.
//

#import "XBZChatMoreView.h"

@interface XBZChatMoreView () <UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate>

@end

@implementation XBZChatMoreView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        XBZEmojiFlowLayout *layout = [XBZEmojiFlowLayout new];
        layout.itemSize = CGSizeMake(frame.size.width / kBigEmojiCol, (frame.size.height-kPageControlHeight) / kBigEmojiRow);
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
        NSInteger page = (int)ceilf(XBZChatKeyBoardManager.sharedManager.moreItems.count / 8.f);
        _collectionView.contentSize = CGSizeMake(page * self.width, self.height-kPageControlHeight);
        [_collectionView registerClass:[XBZChatMoreCollectionViewCell class] forCellWithReuseIdentifier:kXBZChatMoreCollectionViewCellId];
        [self addSubview:_collectionView];
        
        _pageControl = [UIPageControl new];
        _pageControl.currentPageIndicatorTintColor = [UIColor darkGrayColor];
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        _pageControl.userInteractionEnabled = NO;
        _pageControl.numberOfPages = page;
        _pageControl.currentPage = 0;
        [self addSubview:_pageControl];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.collectionView.frame = CGRectMake(0, 0, self.width, self.height-kPageControlHeight);
    self.pageControl.frame = CGRectMake(0, self.collectionView.bottom, self.width, kPageControlHeight);
    
}

//MARK: - Delegate & DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return XBZChatKeyBoardManager.sharedManager.moreItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XBZChatMoreCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kXBZChatMoreCollectionViewCellId forIndexPath:indexPath];
    cell.moreItem = XBZChatKeyBoardManager.sharedManager.moreItems[indexPath.row];
    [cell.button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    cell.button.tag = indexPath.row;
    
    return cell;
}

//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
//    
//    if ([self.delegate respondsToSelector:@selector(chatMoreViewDidSelectItemAtIndexPath:)]) {
//        [self.delegate chatMoreViewDidSelectItemAtIndexPath:indexPath];
//    }
//}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.pageControl.currentPage = (int)(scrollView.contentOffset.x / self.width);
}

- (void)clickButton:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(chatMoreViewDidSelectItemWithTitle:index:)]) {
        [self.delegate chatMoreViewDidSelectItemWithTitle:sender.titleLabel.text index:sender.tag];
    }
    
}


@end
