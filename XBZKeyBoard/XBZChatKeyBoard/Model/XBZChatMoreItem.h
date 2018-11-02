//
//  XBZChatMoreItem.h
//  XBZKeyBoard
//
//  Created by BigKing on 2018/10/25.
//  Copyright © 2018年 BigKing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XBZChatMoreItem : NSObject

@property (nonatomic, copy) NSString *normalImage;
@property (nonatomic, copy) NSString *highlightedImage;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger font;

+ (instancetype)initWithNormalImage:(NSString *)normalImage highlightedImage:(nullable NSString *)highlightedImage title:(NSString *)title font:(NSInteger)font;

@end

NS_ASSUME_NONNULL_END
