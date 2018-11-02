//
//  XBZEmojiCollectionViewCell.h
//  XBZKeyBoard
//
//  Created by BigKing on 2018/10/22.
//  Copyright © 2018年 BigKing. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString *const kXBZEmojiCollectionViewCellId;

@class XBZEmojiModel;

NS_ASSUME_NONNULL_BEGIN

@interface XBZEmojiCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) XBZEmojiModel *emojiModel;
@property (nonatomic, strong) XBZFaceModel *faceModel;

@end

NS_ASSUME_NONNULL_END
