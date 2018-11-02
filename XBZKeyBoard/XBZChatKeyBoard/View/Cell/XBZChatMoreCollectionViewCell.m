//
//  XBZChatMoreCollectionViewCell.m
//  XBZKeyBoard
//
//  Created by BigKing on 2018/10/25.
//  Copyright © 2018年 BigKing. All rights reserved.
//

#import "XBZChatMoreCollectionViewCell.h"

NSString *const kXBZChatMoreCollectionViewCellId = @"kXBZChatMoreCollectionViewCellId";

@implementation XBZChatMoreCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        _button = [UIButton new];
        [self.contentView addSubview:_button];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.button.frame = self.contentView.bounds;
    [self.button layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:kVerticalSpace];
}

- (void)setMoreItem:(XBZChatMoreItem *)moreItem {
    _moreItem = moreItem;
    
    [self.button setImage:[UIImage imageNamed:moreItem.normalImage] forState:UIControlStateNormal];
    [self.button setImage:[UIImage imageNamed:moreItem.highlightedImage] forState:UIControlStateHighlighted];
    [self.button setTitleColor:[UIColor colorWithRGB:0x333333] forState:UIControlStateNormal];
    [self.button setTitleColor:[UIColor colorWithRGB:0x666666] forState:UIControlStateHighlighted];
    [self.button setTitle:moreItem.title forState:UIControlStateNormal];
    self.button.titleLabel.font = [UIFont systemFontOfSize:moreItem.font];
}


@end
