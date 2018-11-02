//
//  XBZChatKeyBoardManager.h
//  XBZKeyBoard
//
//  Created by BigKing on 2018/10/19.
//  Copyright © 2018年 BigKing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XBZEmojiModel.h"
#import "XBZChatMoreItem.h"
#import "XBZChatKeyBoardView.h"

NS_ASSUME_NONNULL_BEGIN

@class XBZEmojiModel;

@interface XBZChatKeyBoardManager : NSObject

@property (nonatomic, strong, readonly) NSArray<XBZGroupEmojiModel *> *groupEmojis;
@property (nonatomic, strong, readonly) NSArray<XBZChatMoreItem *> *moreItems;

//单例对象
+ (instancetype)sharedManager;

//销毁单例对象
- (void)tearDown;

//配置表情
- (void)configEmojisData:(NSArray<XBZGroupEmojiModel *> *)emojis;

//配置更多
- (void)configMoreItems:(NSArray<XBZChatMoreItem *> *)moreItems;

@end

NS_ASSUME_NONNULL_END
