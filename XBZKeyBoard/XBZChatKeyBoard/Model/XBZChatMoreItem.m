//
//  XBZChatMoreItem.m
//  XBZKeyBoard
//
//  Created by BigKing on 2018/10/25.
//  Copyright © 2018年 BigKing. All rights reserved.
//

#import "XBZChatMoreItem.h"

@implementation XBZChatMoreItem

+ (instancetype)initWithNormalImage:(NSString *)normalImage highlightedImage:(nullable NSString *)highlightedImage title:(NSString *)title font:(NSInteger)font {
    
    XBZChatMoreItem *item = [XBZChatMoreItem new];
    item.normalImage = normalImage;
    item.highlightedImage = highlightedImage;
    item.title = title;
    item.font = font;
    
    return item;
}

@end
