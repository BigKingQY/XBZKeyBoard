//
//  XBZEmojiModel.h
//  XBZKeyBoard
//
//  Created by BigKing on 2018/10/22.
//  Copyright © 2018年 BigKing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, XBZChatEmojiType) {
    XBZChatEmojiSmall, //小图表情 7 * 3
    XBZChatEmojiBig    //大图表情 4 * 2
};

//大表情
@interface XBZFaceModel : NSObject

@property (nonatomic, copy) NSString *image;

@end

//emoji表情，包含🙂&[微笑]
@interface XBZEmojiModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *image;

@end

//表情组模型
@interface XBZGroupEmojiModel : NSObject

@property (nonatomic, copy) NSString *groupImage;
@property (nonatomic, strong) NSArray<XBZEmojiModel *> *emojis;
@property (nonatomic, strong) NSArray<XBZFaceModel *> *faces;
@property (nonatomic, assign) XBZChatEmojiType type;
@property (nonatomic, assign) NSInteger totalPages;

/**
 创建文字类的小表情

 @param plist 文件名
 @param image 组图片名
 @return 模型对象
 */
+ (instancetype)initEmojiWithPlist:(NSString *)plist image:(NSString *)image;


/**
 创建图片类的小表情

 @param fileName 文件名前缀
 @param image 组图片名
 @return 模型对象
 */
+ (instancetype)initEmojiWithPlist:(NSString *)plist fileName:(NSString *)fileName image:(NSString *)image;


/**
 创建图片类大表情

 @param name 文件名前缀
 @param count 表情数量
 @param image 组图片名
 @return 模型对象
 */
+ (instancetype)initFaceWithFileName:(nullable NSString *)name count:(NSInteger)count image:(NSString *)image;

@end

NS_ASSUME_NONNULL_END
