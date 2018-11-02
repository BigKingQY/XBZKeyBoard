//
//  NSString+XBZKeyBoard.h
//  XBZKeyBoard
//
//  Created by BigKing on 2018/10/30.
//  Copyright © 2018 BigKing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (XBZKeyBoard)

//判断字符串的尾部是否是emoji表情
+ (BOOL)stringFromTrailIsEmoji:(NSString *)string;

//判断字符串里面是否包含emoji表情
+ (BOOL)stringContainsEmoji:(NSString *)string;

//删除[微笑]类的标签，判断是否为系统删除按钮
+ (void)deleteEmtionString:(UITextView *)textView isSystem:(BOOL)isSystem;

//将文字里面的包含的[微笑]类表情转换成attributedString返回
+ (NSMutableAttributedString *)emotionImgsWithString:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
