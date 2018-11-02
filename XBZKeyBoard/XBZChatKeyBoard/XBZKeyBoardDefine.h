//
//  XBZKeyBoardDefine.h
//  XBZKeyBoard
//
//  Created by BigKing on 2018/10/19.
//  Copyright © 2018年 BigKing. All rights reserved.
//

#ifndef XBZKeyBoardDefine_h
#define XBZKeyBoardDefine_h

#ifdef DEBUG
#define XBZLog(...) NSLog(@"%s 第%d行 \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#else
#define XBZLog(...)
#endif

#ifndef SCREEN_Height
#define SCREEN_Height [[UIScreen mainScreen] bounds].size.height
#endif

#ifndef SCREEN_Width
#define SCREEN_Width  [[UIScreen mainScreen] bounds].size.width
#endif

#define kDefaultTableHeaderView [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 0.01f)]

#define kStatusBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height)
#define kIsIPhoneX (kStatusBarHeight == 20.f ? NO : YES)
#define kNavigationBarHeight (kIsIPhoneX ? 88.f : 64.f)
#define kTabBarHeight (kIsIPhoneX ? 83.f : 49.f)
#define kHomeIndecatorHeight (kIsIPhoneX ? 34.f : 0.f)

#define kToolBarHeight           49.f //工具条高度
#define kButtonHeight            30.f //按钮高度
#define kHorizenSpace            10.f //水平间隔
#define kVerticalSpace           9.5f //垂直间隔
#define kBottomViewHeight        260.f //底部视图高度
#define kTextViewWidth           (SCREEN_Width-(5*kHorizenSpace)-(3*kButtonHeight)) //输入框宽度
#define kTextViewMaxHeight        100.f //输入框最大高度
#define kLineColor  [UIColor colorWithRGB:0xc8c8c8] //边框色

#define kSmallEmojiRow            3 //表情行数
#define kSmallEmojiCol            7 //表情列数

#define kBigEmojiRow              2 //表情行数
#define kBigEmojiCol              4 //表情列数

#define kSendButtonWidth          60.f
#define kPageControlHeight        10.f
#define kEmojiBottomHeight        40.f

#define kEmojiGroupButtonWidth    50.f
#define kEmojiGroupButtonHeight   40.f

#define kMoreItemWidth            80.f
#define kMoreItemHeight           80.f

#import "UIView+XBZKeyBoard.h"
#import "UIButton+XBZKeyBoard.h"
#import "UIColor+XBZKeyBoard.h"
#import "NSString+XBZKeyBoard.h"
#import "UIImage+XBZKeyBoard.h"
#import "UIScrollView+XBZKeyBoard.h"

#import "XBZEmojiModel.h"
#import "XBZChatMoreItem.h"
#import "XBZChatKeyBoardManager.h"
#import "XBZKeyBoardTextView.h"
#import "XBZChatMoreView.h"
#import "XBZVoiceAnimationView.h"
#import "XBZAudioRecorder.h"
#import "lame.h"
#import "XBZChatMoreCollectionViewCell.h"
#import "XBZEmojiCollectionViewCell.h"
#import "XBZEmojiFlowLayout.h"



#endif /* XBZKeyBoardDefine_h */
