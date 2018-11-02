//
//  XBZChatKeyBoardView.h
//  XBZKeyBoard
//
//  Created by BigKing on 2018/10/19.
//  Copyright © 2018年 BigKing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XBZChatEmojiView.h"
#import "XBZChatMoreView.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, XBZKeyBoardState) {
    XBZKeyBoardStateNormal,         //初始状态
    XBZKeyBoardStateVoice,          //录音状态
    XBZKeyBoardStateFace,           //表情状态
    XBZKeyBoardStateMore,           //更多状态
    XBZKeyBoardStateKeyBoard,       //系统键盘弹起状态
};

@protocol XBZChatKeyBoardViewDelegate <NSObject>

//发送文本，考虑到表情（🙂&[微笑]）上传时需要将原文传给服务器，展示的时候才是显示转换后的文字
- (void)chatKeyBoardViewSendTextMessage:(NSMutableAttributedString *)text originText:(NSString *)originText;

//发送大表情图片
- (void)chatKeyBoardViewSendPhotoMessage:(NSString *)photo;

//发送录音，这里是完整的音频路径
- (void)chatKeyBoardViewSendVoiceMessage:(NSDictionary *)voiceInfo;

//点击更多
- (void)chatKeyBoardViewSelectMoreImteTitle:(NSString *)title index:(NSInteger)index;

@end

@class XBZChatEmojiView;

@interface XBZChatKeyBoardView : UIView

@property (nonatomic, weak) id<XBZChatKeyBoardViewDelegate> delegate;

//是否使用录音，默认显示
@property (nonatomic, assign) BOOL showVoice;
//是否使用表情，默认显示
@property (nonatomic, assign) BOOL showFace;
//是否使用更多，默认显示
@property (nonatomic, assign) BOOL showMore;

//textViewPlaceHolder
@property (nonatomic, copy) NSString *textViewPlaceHolder;

//不准用~
- (instancetype)init NS_UNAVAILABLE;
//就是不准用~
+ (instancetype)new NS_UNAVAILABLE;
//硬是不准用~
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

/**
 初始化方法

 @param translucent navigationBar的truanslucent属性，如果没有navigationBar设置为YES
 @return 当前对象
 */
- (instancetype)initWithNavigationBarTranslucent:(BOOL)translucent;

//收起键盘
- (void)hideBottomView;

@end

NS_ASSUME_NONNULL_END
