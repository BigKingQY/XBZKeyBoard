//
//  XBZVoiceAnimationView.m
//  XBZKeyBoard
//
//  Created by BigKing on 2018/10/26.
//  Copyright © 2018年 BigKing. All rights reserved.
//

#import "XBZVoiceAnimationView.h"

@interface XBZVoiceAnimationView ()

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) CAShapeLayer *maskLayer;

@property (nonatomic, assign) NSInteger count;

@end

@implementation XBZVoiceAnimationView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        _iconImageView = [UIImageView new];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        _iconImageView.image = [UIImage imageNamed:@"icon_voice_nor"];
        [self addSubview:_iconImageView];
        
        _imageView = [UIImageView new];
        _imageView.image = [UIImage imageNamed:@"icon_voice_6"];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_imageView];
        
        _maskLayer = [CAShapeLayer layer];
        //默认显示一格的音量动画
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 55, 36.f, 11.f)];
        _maskLayer.path = path.CGPath;
        _maskLayer.fillRule = kCAFillRuleEvenOdd;
        _imageView.layer.mask = _maskLayer;
        
        _cancelImageView = [UIImageView new];
        _cancelImageView.hidden = YES;
        _cancelImageView.image = [UIImage imageNamed:@"icon_voice_cancel"];
        _cancelImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_cancelImageView];
        
        _stateLabel = [UILabel new];
        _stateLabel.textColor = [UIColor whiteColor];
        _stateLabel.font = [UIFont systemFontOfSize:15];
        _stateLabel.textAlignment = NSTextAlignmentCenter;
        _stateLabel.text = @"手指上滑，取消发送";
        _stateLabel.layer.cornerRadius = 3.f;
        [self addSubview:_stateLabel];
        
        _timeLabel = [UILabel new];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font = [UIFont systemFontOfSize:14];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.text = @"00:00:00";
        [self addSubview:_timeLabel];
        
        self.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.8];
        self.layer.cornerRadius = 5.f;
        
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(changeMaskView:) name:kXBZAudioRecorderNotification object:nil];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.iconImageView.frame = CGRectMake(self.width/2.f-34.f-12.f, 20.f, 34.f, 66.f);
    self.imageView.frame = CGRectMake(self.width/2.f+12.f, 20.f, 26.f, 66.f);
    self.cancelImageView.frame = CGRectMake(self.iconImageView.left, 20.f, self.iconImageView.width+self.imageView.width+24, 66.f);
    self.timeLabel.frame = CGRectMake(0, self.iconImageView.bottom+20.f, self.width, 20.f);
    self.stateLabel.frame = CGRectMake(6.f, self.timeLabel.bottom+12.f, self.width-12.f, 24.f);
}

- (void)changeMaskView:(NSNotification *)noti {
    
    //vol的范围是0~100
    NSInteger vol = [noti.userInfo[@"voiceLevel"] integerValue];
    
    //将音量分成6份，100 / 6 = 16.6，取整
    CGFloat delta = (vol / 16) * 11.f;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 55.f - delta, 36.f, 11.f + delta)];
    self.maskLayer.path = path.CGPath;
    self.imageView.layer.mask = self.maskLayer;
    
    self.count++;
    
    //每两次为1s，通知0.5s收到一次
    if (self.count % 2 == 0) {
        
        //此处-28800是因为多了8个小时，仅仅只使用日期后面的时分秒，前面的日期不管，方便计时
        NSTimeInterval second = self.count / 2.f - 28800;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:second];
        NSDateFormatter *formatter = [NSDateFormatter new];
        formatter.dateFormat = @"HH:mm:ss";
        self.timeLabel.text = [formatter stringFromDate:date];
    }
}

- (void)setState:(XBZVoiceState)state {
    _state = state;
    
    switch (state) {
        case XBZVoiceNormal:
            self.iconImageView.hidden = NO;
            self.imageView.hidden = NO;
            self.timeLabel.hidden = NO;
            self.cancelImageView.hidden = YES;
            self.stateLabel.text = @"手指上滑，取消发送";
            self.stateLabel.backgroundColor = [UIColor clearColor];
            break;
        case XBZVoiceWillCancel:
            self.iconImageView.hidden = YES;
            self.imageView.hidden = YES;
            self.timeLabel.hidden = YES;
            self.cancelImageView.hidden = NO;
            self.stateLabel.text = @"松开手指，取消发送";
            self.stateLabel.backgroundColor = [UIColor redColor];
            break;
        case XBZVoiceCancel:
            self.iconImageView.hidden = YES;
            self.imageView.hidden = YES;
            self.timeLabel.hidden = YES;
            self.timeLabel.text = @"00:00:00";
            self.cancelImageView.hidden = NO;
            self.stateLabel.text = @"松开手指，取消发送";
            self.stateLabel.backgroundColor = [UIColor redColor];
            self.count = 0;
            break;
        case XBZVoiceFinished:
            self.iconImageView.hidden = NO;
            self.imageView.hidden = NO;
            self.timeLabel.hidden = NO;
            self.timeLabel.text = @"00:00:00";
            self.cancelImageView.hidden = YES;
            self.stateLabel.text = @"手指上滑，取消发送";
            self.stateLabel.backgroundColor = [UIColor clearColor];
            self.count = 0;
            break;
    }
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

@end
