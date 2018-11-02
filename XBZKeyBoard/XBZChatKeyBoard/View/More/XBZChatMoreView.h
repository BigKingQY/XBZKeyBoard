//
//  XBZChatMoreView.h
//  XBZKeyBoard
//
//  Created by BigKing on 2018/10/25.
//  Copyright © 2018年 BigKing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol XBZChatMoreViewDelegate <NSObject>

- (void)chatMoreViewDidSelectItemWithTitle:(NSString *)title index:(NSInteger)index;

@end

@interface XBZChatMoreView : UIView

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, weak) id<XBZChatMoreViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
