//
//  XBZChatEmojiView.h
//  XBZKeyBoard
//
//  Created by BigKing on 2018/10/19.
//  Copyright © 2018年 BigKing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XBZEmojiModel;

@protocol XBZChatEmojiViewDelegate <NSObject>

@required

- (void)chatEmojiViewDidSelectEmojiWithContent:(XBZEmojiModel *)content;

- (void)chatEmojiViewDidSelectFaceWithContent:(XBZFaceModel *)content;

- (void)chatEmojiViewClickSendButton:(UIButton *)sender;

@end

@interface XBZChatEmojiBottomView : UIView

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *sendButton;

@end

@interface XBZChatEmojiView : UIView

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) XBZChatEmojiBottomView *bottomView;
@property (nonatomic, weak) id<XBZChatEmojiViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
