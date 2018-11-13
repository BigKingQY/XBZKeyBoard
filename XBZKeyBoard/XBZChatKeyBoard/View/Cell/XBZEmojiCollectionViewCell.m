//
//  XBZEmojiCollectionViewCell.m
//  XBZKeyBoard
//
//  Created by BigKing on 2018/10/22.
//  Copyright © 2018年 BigKing. All rights reserved.
//

#import "XBZEmojiCollectionViewCell.h"

NSString *const kXBZEmojiCollectionViewCellId = @"kXBZEmojiCollectionViewCellId";

@interface XBZEmojiCollectionViewCell ()

@end

@implementation XBZEmojiCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.titleLabel.font = [UIFont systemFontOfSize:15];
        _button.backgroundColor = [UIColor colorWithRGB:0xf5f5f5];
        _button.userInteractionEnabled = NO;
        [self.contentView addSubview:_button];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.button.frame = self.contentView.bounds;
}

- (void)setEmojiModel:(XBZEmojiModel *)emojiModel {
    _emojiModel = emojiModel;
    
    if (emojiModel.title && !emojiModel.image) {
        [self.button setTitle:emojiModel.title forState:UIControlStateNormal];
        [self.button setImage:nil forState:UIControlStateNormal];
    }else if (emojiModel.image) {
        [self.button setImage:[UIImage imageNamed:emojiModel.image] forState:UIControlStateNormal];
        [self.button setTitle:@"" forState:UIControlStateNormal];
    }else {
        [self.button setTitle:@"" forState:UIControlStateNormal];
        [self.button setImage:nil forState:UIControlStateNormal];
    }
}

- (void)setFaceModel:(XBZFaceModel *)faceModel {
    _faceModel = faceModel;

    [self.button setImage:[UIImage imageNamed:faceModel.image] forState:UIControlStateNormal];
    [self.button setTitle:@"" forState:UIControlStateNormal];
}

@end
