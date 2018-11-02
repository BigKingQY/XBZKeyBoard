//
//  XBZVoiceAnimationView.h
//  XBZKeyBoard
//
//  Created by BigKing on 2018/10/26.
//  Copyright © 2018年 BigKing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, XBZVoiceState) {
    XBZVoiceNormal,
    XBZVoiceWillCancel,
    XBZVoiceCancel,
    XBZVoiceFinished
};

@interface XBZVoiceAnimationView : UIView

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *cancelImageView;
@property (nonatomic, strong) UILabel *stateLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, assign) XBZVoiceState state;

@end

NS_ASSUME_NONNULL_END
