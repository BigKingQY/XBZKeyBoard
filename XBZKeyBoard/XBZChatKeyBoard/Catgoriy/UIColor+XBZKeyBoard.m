//
//  UIColor+XBZ.m
//  XBZKeyBoard
//
//  Created by BigKing on 2018/10/30.
//  Copyright © 2018 BigKing. All rights reserved.
//

#import "UIColor+XBZKeyBoard.h"

@implementation UIColor (XBZKeyBoard)

+ (UIColor *)colorWithRGB:(uint32_t)rgbValue {
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16) / 255.0f
                           green:((rgbValue & 0xFF00) >> 8) / 255.0f
                            blue:(rgbValue & 0xFF) / 255.0f
                           alpha:1];
}

@end
