//
//  ViewController.m
//  XBZKeyBoard_Demo
//
//  Created by BigKing on 2018/10/30.
//  Copyright © 2018 BigKing. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController () <XBZChatKeyBoardViewDelegate>

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) UIButton *button2;

@property (nonatomic, strong) AVAudioPlayer *player;

@property (nonatomic, copy) NSString *currentVoicePath;

@property (nonatomic, strong) XBZChatKeyBoardView *keyBoardView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"聊天界面";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.label];
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.button];
    [self.view addSubview:self.button2];
    
    self.keyBoardView = [[XBZChatKeyBoardView alloc] initWithNavigationBarTranslucent:NO];
    self.keyBoardView.delegate = self;
    [self.view addSubview:self.keyBoardView];
}


//MARK: - XBZChatKeyBoardViewDelegate

- (void)chatKeyBoardViewSendTextMessage:(NSMutableAttributedString *)text originText:(NSString *)originText {
    NSLog(@"textMessage:%@", text);
    self.label.attributedText = text;
}

- (void)chatKeyBoardViewSendPhotoMessage:(NSString *)photo {
    NSLog(@"photoMessage:%@", photo);
    self.imageView.image = [UIImage imageNamed:photo];
}

- (void)chatKeyBoardViewSendVoiceMessage:(NSString *)voicePath {
    NSLog(@"voiceMessage:%@", voicePath);
    self.button.enabled = YES;
    self.currentVoicePath = voicePath;
}

- (void)chatKeyBoardViewSelectMoreImteTitle:(NSString *)title index:(NSInteger)index{
    NSLog(@"moreTitle:%@, index:%ld", title, index);
    self.label.text = [NSString stringWithFormat:@"点击了<%@>, 序号<%ld>", title, index];
}

//MARK: - Actions

- (void)clickButton:(UIButton *)sender {

    [XBZAudioRecorder.shared playLocalRecordWithURL:self.currentVoicePath];
}

- (void)hideKeyboardView:(UIButton *)sender {
    [self.keyBoardView hideBottomView];
}

//MARK: - Touches

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.keyBoardView hideBottomView];
}

//MARK: - Getter

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(20.f, 20.f, self.view.width-40.f, 60.f)];
        _label.backgroundColor = [UIColor redColor];
        _label.textColor = [UIColor whiteColor];
        _label.numberOfLines = 0;
    }
    return _label;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100.f, self.label.bottom+20.f, self.view.width-200.f, 150)];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.backgroundColor = [UIColor lightGrayColor];
    }
    return _imageView;
}

- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake(20.f, self.imageView.bottom+20.f, (self.view.width-40.f-20)/2.f, 36.f);
        [_button setTitle:@"播放录音" forState:UIControlStateNormal];
        _button.backgroundColor = [UIColor colorWithRGB:0x2693fa];
        [_button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        _button.enabled = NO;
    }
    return _button;
}

- (UIButton *)button2 {
    if (!_button2) {
        _button2 = [UIButton buttonWithType:UIButtonTypeCustom];
        _button2.frame = CGRectMake(20.f + self.button.right, self.imageView.bottom+20.f, self.button.width, self.button.height);
        [_button2 setTitle:@"收起键盘" forState:UIControlStateNormal];
        _button2.backgroundColor = [UIColor colorWithRGB:0x2693fa];
        [_button2 addTarget:self action:@selector(hideKeyboardView:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button2;
}

@end
