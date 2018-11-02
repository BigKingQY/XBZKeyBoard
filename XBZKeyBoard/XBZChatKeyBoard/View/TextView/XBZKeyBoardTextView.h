//
//  XBZKeyBoardTextView.h
//  XBZKeyBoard
//
//  Created by BigKing on 2018/10/19.
//  Copyright © 2018年 BigKing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^XBZTextViewHeightCallBack)(CGFloat height);

@interface XBZKeyBoardTextView : UITextView

@property (nonatomic, copy) NSString *placeHolder;

@property (nonatomic, strong) UIColor *placeHolderColor;

@end

NS_ASSUME_NONNULL_END
