//
//  XBZChatMoreCollectionViewCell.h
//  XBZKeyBoard
//
//  Created by BigKing on 2018/10/25.
//  Copyright © 2018年 BigKing. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString *const kXBZChatMoreCollectionViewCellId;

NS_ASSUME_NONNULL_BEGIN

@class XBZChatMoreItem;

@interface XBZChatMoreCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) XBZChatMoreItem *moreItem;

@end

NS_ASSUME_NONNULL_END
