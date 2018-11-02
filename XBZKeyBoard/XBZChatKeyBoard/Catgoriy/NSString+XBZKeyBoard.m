//
//  NSString+XBZKeyBoard.m
//  XBZKeyBoard
//
//  Created by BigKing on 2018/10/30.
//  Copyright © 2018 BigKing. All rights reserved.
//

#import "NSString+XBZKeyBoard.h"

@implementation NSString (XBZKeyBoard)

+ (BOOL)stringFromTrailIsEmoji:(NSString *)string {
    NSMutableArray *arr = [NSMutableArray array];
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        
        [arr addObject:substring];
    }];
    
    NSString *strin = [arr lastObject];
    if (strin.length ==2) {
        return YES;
    }
    return NO;
}

+ (BOOL)stringContainsEmoji:(NSString *)string {
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}

//输入视图删除 [微笑] 这类字符串  直接一次性删除，此处对系统键盘的删除做区别
+ (void)deleteEmtionString:(UITextView *)textView isSystem:(BOOL)isSystem {
    
    NSString *souceText = textView.text;
    NSRange range = textView.selectedRange;
    if (range.location == NSNotFound) {
        range.location = textView.text.length;
    }
    if (range.length > 0) {
        [textView deleteBackward];
        return;
    }else{
        
        //正则匹配要替换的文字的范围
        NSString * pattern = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
        NSError *error = nil;
        NSRegularExpression * re = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
        if (!re) {
            NSLog(@"%@", [error localizedDescription]);
        }
        //通过正则表达式来匹配字符串
        NSArray *resultArray = [re matchesInString:souceText options:0 range:NSMakeRange(0, souceText.length)];
        
        NSTextCheckingResult *checkingResult = resultArray.lastObject;
        
        for (XBZGroupEmojiModel *groupModel in XBZChatKeyBoardManager.sharedManager.groupEmojis) {
            if (groupModel.type != XBZChatEmojiSmall) {
                continue;
            }
            
            for (XBZEmojiModel *model in groupModel.emojis) {
                if ([model.title containsString:@"["]) {
                    if ([souceText hasSuffix:@"]"]) {
                        
                        if ([[souceText substringWithRange:checkingResult.range] isEqualToString:model.title]) {
                            
                            NSLog(@"faceName %@", model.title);
                            
                            if (isSystem) {
                                NSString *newText = [souceText substringToIndex:souceText.length - checkingResult.range.length + 1];
                                textView.text = newText;
                                return;
                            }
                            
                            NSString *newText = [souceText substringToIndex:souceText.length - checkingResult.range.length];
                            textView.text = newText;
                            return;
                            
                        }
                        
                    }else {
                        [textView deleteBackward];
                        return;
                    }
                }
            }
        }
    }
}

//将字符串中所有的表情字符串转换成图片 并返回可变字符串
+ (NSMutableAttributedString *)emotionImgsWithString:(NSString *)string {
    
    NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc]initWithString:string];
    
    
    //正则匹配要替换的文字的范围
    NSString * pattern = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    NSError *error = nil;
    NSRegularExpression * re = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    if (!re) {
        NSLog(@"%@", [error localizedDescription]);
    }
    
    //遍历字符串,获得所有的匹配字符串
    NSArray *resultArray = [re matchesInString:string options:0 range:NSMakeRange(0, string.length)];
    
    if (resultArray.count == 0) {
        return attStr;
    }
    
    for (NSInteger i = resultArray.count-1; i >= 0; i--) {
        
        NSTextCheckingResult *checkingResult = resultArray[i];
        
        for (XBZGroupEmojiModel *groupModel in XBZChatKeyBoardManager.sharedManager.groupEmojis) {
            if (groupModel.type != XBZChatEmojiSmall) {
                continue;
            }
            
            for (int i = 0; i < groupModel.emojis.count; i++) {
                XBZEmojiModel *model = groupModel.emojis[i];
                if (model.title && model.image && ![model.title isEqualToString:@"delete"]) {
                    
                    NSString *faceName = model.title;
                    
                    
                    //截取闭区间的字符串
                    if ([[string substringWithRange:checkingResult.range] isEqualToString:faceName]){
                        
                        NSTextAttachment * textAttachment = [[NSTextAttachment alloc]init];
                        textAttachment.image = [UIImage imageNamed:model.image];
                        textAttachment.bounds = CGRectMake(0, -3, 24, 24);
                        NSAttributedString * imageStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
                        
                        NSMutableAttributedString *mstr = [[NSMutableAttributedString alloc]initWithAttributedString:imageStr];
                        [mstr addAttribute:NSBaselineOffsetAttributeName value:@(-3.6) range:NSMakeRange(0, mstr.length)];
                        
                        NSMutableParagraphStyle *paragraphString = [[NSMutableParagraphStyle alloc] init];
                        [paragraphString setLineSpacing:5];
                        [mstr addAttribute:NSParagraphStyleAttributeName value:paragraphString range:NSMakeRange(0, mstr.length)];
                        
                        [attStr replaceCharactersInRange:checkingResult.range withAttributedString:mstr];
                        [attStr addAttribute:NSParagraphStyleAttributeName value:paragraphString range:NSMakeRange(0, attStr.length)];
                        
                    }
                }
            }
        }
    }
    
    return attStr;
}

@end
