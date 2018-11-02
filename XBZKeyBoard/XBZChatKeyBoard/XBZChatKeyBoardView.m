//
//  XBZChatKeyBoardView.m
//  XBZKeyBoard
//
//  Created by BigKing on 2018/10/19.
//  Copyright © 2018年 BigKing. All rights reserved.
//

#import "XBZChatKeyBoardView.h"

@interface XBZChatKeyBoardView () <UITextViewDelegate, XBZChatEmojiViewDelegate, XBZChatMoreViewDelegate>

@property (nonatomic, strong) UIView *topBarView;
@property (nonatomic, strong) UIButton *voiceButton;
@property (nonatomic, strong) UIButton *faceButton;
@property (nonatomic, strong) UIButton *moreButton;
@property (nonatomic, strong) UIButton *recordButton;
@property (nonatomic, strong) XBZKeyBoardTextView *textView;
@property (nonatomic, strong) UIView *bottomView;
//表情 视图
@property (nonatomic, strong) XBZChatEmojiView *emojiView;
//更多 视图
@property (nonatomic, strong) XBZChatMoreView *moreView;

//当前键盘状态
@property (nonatomic, assign) XBZKeyBoardState currentState;
//textView宽度
@property (nonatomic, assign) CGFloat textViewWidth;
//原始frame
@property (nonatomic, assign) CGRect originFrame;
//上一次高度
@property (nonatomic, assign) CGFloat lastHeight;
//当前弹出的键盘高度
@property (nonatomic, assign) CGFloat currentKeyBoardHeight;
//根据translucent来决定是否计算navigationbar高度
@property (nonatomic, assign, readonly) CGFloat navigationBarHeight;
//录音动画视图
@property (nonatomic, strong) XBZVoiceAnimationView *voiceView;

@end

@implementation XBZChatKeyBoardView

- (instancetype)initWithNavigationBarTranslucent:(BOOL)translucent
{
    self = [super init];
    if (self) {
        
        self->_navigationBarHeight = translucent ? 0.f : kNavigationBarHeight;
        self.frame = CGRectMake(0, SCREEN_Height-self.navigationBarHeight-kHomeIndecatorHeight-kToolBarHeight, SCREEN_Width, kToolBarHeight);
        _originFrame = self.frame;
        _lastHeight = self.height;
        self.backgroundColor = [UIColor colorWithRGB:0xfafafa];
        self.layer.borderColor = [UIColor colorWithRGB:0xe0e0e0].CGColor;
        self.layer.borderWidth = 1.f;
        
        _currentState = XBZKeyBoardStateNormal;
        _showFace = YES;
        _showVoice = YES;
        _showMore = YES;
        _textViewWidth = kTextViewWidth;
        
        [self.topBarView addSubview:self.recordButton];
        [self.topBarView addSubview:self.voiceButton];
        [self.topBarView addSubview:self.textView];
        [self.topBarView addSubview:self.faceButton];
        [self.topBarView addSubview:self.moreButton];
        [self addSubview:self.topBarView];
        [self addSubview:self.bottomView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.topBarView.frame = CGRectMake(0, 0, self.width, self.height-(self.bottomView.hidden ? 0:kBottomViewHeight));
    if (self.showVoice) {
        self.voiceButton.frame = CGRectMake(kHorizenSpace, self.topBarView.height-kVerticalSpace-kButtonHeight, kButtonHeight, kButtonHeight);
    }else {
        self.voiceButton.frame = CGRectZero;
    }
    
    if (self.showMore) {
        self.moreButton.frame = CGRectMake(self.width-kHorizenSpace-kButtonHeight, self.topBarView.height-kVerticalSpace-kButtonHeight, kButtonHeight, kButtonHeight);
    }else {
        self.moreButton.frame = CGRectZero;
    }
    
    self.textView.frame = CGRectMake(self.voiceButton.right+kHorizenSpace, kVerticalSpace-2.f, self.textViewWidth, self.topBarView.height-2*(kVerticalSpace-2.f));
    
    if (self.showFace) {
        self.faceButton.frame = CGRectMake(self.textView.right+kHorizenSpace, self.topBarView.height-kVerticalSpace-kButtonHeight, kButtonHeight, kButtonHeight);
    }else {
        self.faceButton.frame = CGRectZero;
    }
    self.recordButton.frame = self.textView.frame;
    
    if (!self.bottomView.hidden) {
        self.bottomView.frame = CGRectMake(0.f, self.topBarView.bottom, self.width, kBottomViewHeight);
        self.emojiView.frame = self.bottomView.bounds;
        self.moreView.frame = self.bottomView.bounds;
    }
    
}

//MARK: - Delegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.currentState = XBZKeyBoardStateKeyBoard;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@""]) {
        /**< 在这里处理删除键的逻辑 */
        [self clickDeleteButton:YES];
        
    }else if ([text isEqualToString:@"\n"]) {
        if ([self.delegate respondsToSelector:@selector(chatKeyBoardViewSendTextMessage:originText:)]) {
            //将文本中的文字类表情替换成图片
        
            [self.delegate chatKeyBoardViewSendTextMessage:[NSString emotionImgsWithString:textView.text] originText:textView.text];
            textView.text = @"";
            CGRect frame = self.originFrame;
            frame.origin.y -= (self.currentKeyBoardHeight - kHomeIndecatorHeight);
            self.lastHeight = kToolBarHeight;
            self.frame = frame;
            [textView setNeedsDisplay];
        }
        
        return NO; //这样才不会出现换行
    }
    
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    
    //获取textView最佳高度
    NSInteger height = ceilf([textView sizeThatFits:CGSizeMake(textView.width, MAXFLOAT)].height);
    CGRect frame = self.frame;
    if (height > kButtonHeight+4.f) {
        if (height > kTextViewMaxHeight) {
            frame.size.height = kTextViewMaxHeight;
            textView.showsVerticalScrollIndicator = YES;
            textView.scrollEnabled = YES;
        }else {
            frame.size.height = height + 2 * kVerticalSpace;
            textView.showsVerticalScrollIndicator = NO;
            textView.scrollEnabled = NO;
        }
        
        frame.origin.y = SCREEN_Height - frame.size.height - self.navigationBarHeight -_currentKeyBoardHeight;
        self.frame = frame;
        self.lastHeight = frame.size.height;
    }else {
        self.frame = CGRectMake(0, SCREEN_Height-self.currentKeyBoardHeight-kToolBarHeight-self.navigationBarHeight, self.width, kToolBarHeight);
        textView.showsVerticalScrollIndicator = NO;
        textView.scrollEnabled = NO;
        self.lastHeight = kToolBarHeight;
    }
}


- (void)chatEmojiViewDidSelectEmojiWithContent:(XBZEmojiModel *)emoji {
    
    if (!emoji.title && !emoji.image) {
        return;
    }
    
    //删除表情图片对应的文字
    if ([emoji.title isEqualToString:@"delete"]) {
        
        [self clickDeleteButton:NO];
        
    }else if (emoji.title) {
        
        self.textView.text = [self.textView.text stringByReplacingCharactersInRange:self.textView.selectedRange withString:emoji.title];
        
    }else if (emoji.image) {
        
        [self clickDeleteButton:NO];
    }
    
    [self.textView setNeedsDisplay];
    [self changeTextViewFrame:self.textView];
}

- (void)clickDeleteButton:(BOOL)isSystem {
    
    if (self.textView.text.length > 0) {
        
        //判断末尾是否是emoji表情
        BOOL isEmoji = [NSString stringFromTrailIsEmoji:self.textView.text];
        
        if (isEmoji && !isSystem) {
            
            self.textView.text = [self.textView.text substringToIndex:self.textView.text.length-2];
            
        }else if ([self.textView.text hasSuffix:@"]"]) { //判断是否是[微笑]类表情
            
            [NSString deleteEmtionString:self.textView isSystem:isSystem];
            
        }else if (!isSystem) {
            
            self.textView.text = [self.textView.text substringToIndex:self.textView.text.length-1];
            
        }
    }
}

- (void)chatEmojiViewDidSelectFaceWithContent:(XBZFaceModel *)model {
    if ([self.delegate respondsToSelector:@selector(chatKeyBoardViewSendPhotoMessage:)]) {
        [self.delegate chatKeyBoardViewSendPhotoMessage:model.image];
    }
}

- (void)changeTextViewFrame:(UITextView *)textView {
    //获取textView最佳高度
    NSInteger height = ceilf([textView sizeThatFits:CGSizeMake(textView.width, MAXFLOAT)].height);
    CGRect frame = self.frame;
    if (height > kButtonHeight) {
        if (height > kTextViewMaxHeight) {
            frame.size.height = kTextViewMaxHeight + 2 * kVerticalSpace + kBottomViewHeight;
            textView.showsVerticalScrollIndicator = YES;
            textView.scrollEnabled = YES;
            [textView scrollToBottomAnimated:YES];
        }else {
            frame.size.height = height + 2 * kVerticalSpace + kBottomViewHeight;
            textView.showsVerticalScrollIndicator = NO;
            textView.scrollEnabled = NO;
        }
        
        frame.origin.y = SCREEN_Height - frame.size.height - self.navigationBarHeight -_currentKeyBoardHeight-kHomeIndecatorHeight;
        self.frame = frame;
        self.lastHeight = frame.size.height-kBottomViewHeight;
    }else {
        self.frame = CGRectMake(0, SCREEN_Height-kBottomViewHeight-kToolBarHeight-self.navigationBarHeight-kHomeIndecatorHeight, self.width, kToolBarHeight+kBottomViewHeight);
        textView.showsVerticalScrollIndicator = NO;
        textView.scrollEnabled = NO;
        self.lastHeight = kToolBarHeight;
    }
}

- (void)chatMoreViewDidSelectItemWithTitle:(NSString *)title index:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(chatKeyBoardViewSelectMoreImteTitle:index:)]) {
        [self.delegate chatKeyBoardViewSelectMoreImteTitle:title index:index];
    }
}

- (void)chatEmojiViewClickSendButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(chatKeyBoardViewSendTextMessage:originText:)]) {
        [self.delegate chatKeyBoardViewSendTextMessage:[NSString emotionImgsWithString:self.textView.text] originText:self.textView.text];
        self.textView.text = @"";
        [self changeTextViewFrame:self.textView];
        [self.textView setNeedsDisplay];
    }
}


//MARK: - Actions

- (void)pressVoiceButton:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.currentState = XBZKeyBoardStateVoice;
    }else {
        self.currentState = XBZKeyBoardStateKeyBoard;
    }
}

- (void)pressFaceButton:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.currentState = XBZKeyBoardStateFace;
        if (![self.bottomView.subviews containsObject:self.emojiView]) {
            [self.bottomView addSubview:self.emojiView];
        }
        if ([self.bottomView.subviews containsObject:self.moreView]) {
            [self.moreView removeFromSuperview];
        }
    }else {
        self.currentState = XBZKeyBoardStateKeyBoard;
    }
}

- (void)pressMoreButton:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.currentState = XBZKeyBoardStateMore;
        if (![self.bottomView.subviews containsObject:self.moreView]) {
            [self.bottomView addSubview:self.moreView];
        }
        if ([self.bottomView.subviews containsObject:self.emojiView]) {
            [self.emojiView removeFromSuperview];
        }
    }else {
        self.currentState = XBZKeyBoardStateKeyBoard;
    }
}

- (void)beginRecordVoice:(UIButton *)sender {
    XBZLog(@"开始录音");
    
    if (![UIApplication.sharedApplication.keyWindow.subviews containsObject:self.voiceView]) {
        [UIApplication.sharedApplication.keyWindow addSubview:self.voiceView];
    }
    self.voiceView.state = XBZVoiceNormal;
    [XBZAudioRecorder.shared startRecord];
    
}

- (void)endRecordVoice:(UIButton *)sender {
    XBZLog(@"结束录音");
    if ([UIApplication.sharedApplication.keyWindow.subviews containsObject:self.voiceView]) {
        self.voiceView.state = XBZVoiceFinished;
        [self.voiceView removeFromSuperview];
    }
    NSDictionary *recordInfo = [XBZAudioRecorder.shared stopRecord];
    
    if ([self.delegate respondsToSelector:@selector(chatKeyBoardViewSendVoiceMessage:)]) {
        [self.delegate chatKeyBoardViewSendVoiceMessage:recordInfo];
    }
}

- (void)cancelRecordVoice:(UIButton *)sender {
    XBZLog(@"取消录音");
    if ([UIApplication.sharedApplication.keyWindow.subviews containsObject:self.voiceView]) {
        self.voiceView.state = XBZVoiceCancel;
        [self.voiceView removeFromSuperview];
    }
    [XBZAudioRecorder.shared cancelRecording];
}

- (void)RemindDragExit:(UIButton *)sender {
    XBZLog(@"将要取消录音");
    
    self.voiceView.state = XBZVoiceWillCancel;
}

- (void)RemindDragEnter:(UIButton *)sender {
    XBZLog(@"继续录音");
    self.voiceView.state = XBZVoiceNormal;
}

//MARK: - NSNotification

- (void)keyboardWillChange:(NSNotification *)noti {
    CGFloat duration = [[noti userInfo][UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGFloat height = [[[noti userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    if(noti.name == UIKeyboardWillHideNotification){
        height = 0.0;
        _currentKeyBoardHeight = 0;
        switch (self.currentState) {
            case XBZKeyBoardStateNormal:
            case XBZKeyBoardStateVoice:
            case XBZKeyBoardStateKeyBoard:
            {
 
                [UIView animateWithDuration:duration animations:^{
                    
                    self.frame = CGRectMake(0, self.originFrame.origin.y-(self.lastHeight-self.originFrame.size.height), self.width, self.lastHeight);
                    
                }];
            }
                break;
            case XBZKeyBoardStateFace:
            case XBZKeyBoardStateMore:
            {
                //显示表情及更多
                [self showBottomViewWithDuration:duration];
            }
                break;
        }
    }else{
        _currentKeyBoardHeight = height;
        [UIView animateWithDuration:duration animations:^{
            
            self.frame = CGRectMake(0, SCREEN_Height-height-self.lastHeight-self.navigationBarHeight, self.width, self.lastHeight);

        }];
    }
}

- (void)hideBottomView {
    if (self.currentState == XBZKeyBoardStateFace ||
        self.currentState == XBZKeyBoardStateMore) {
        self.currentState = XBZKeyBoardStateNormal;
        [self.textView resignFirstResponder];

        [UIView animateWithDuration:0.25 animations:^{
            
            self.frame = CGRectMake(0, self.originFrame.origin.y-(self.lastHeight-self.originFrame.size.height), self.width, self.lastHeight);
        
        }];
    }
    [self.textView resignFirstResponder];
}

//MARK: - Setter

- (void)setShowVoice:(BOOL)showVoice {
    _showVoice = showVoice;
    self.textViewWidth += (kButtonHeight+kHorizenSpace);
    [self layoutSubviews];
    [self layoutIfNeeded];
}

- (void)setShowFace:(BOOL)showFace {
    _showFace = showFace;
    self.textViewWidth += (kButtonHeight+kHorizenSpace);
    [self layoutSubviews];
    [self layoutIfNeeded];
}

- (void)setShowMore:(BOOL)showMore {
    _showMore = showMore;
    self.textViewWidth += (kButtonHeight+kHorizenSpace);
    [self layoutSubviews];
    [self layoutIfNeeded];
}

//修改当前各种控件的状态及视图的frame
- (void)setCurrentState:(XBZKeyBoardState)currentState {
    _currentState = currentState;
    
    switch (currentState) {
        case XBZKeyBoardStateNormal:
        {
            self.voiceButton.selected = NO;
            self.faceButton.selected = NO;
            self.moreButton.selected = NO;
            [self.textView resignFirstResponder];
            self.textView.hidden = NO;
            self.bottomView.hidden = YES;
        }
            break;
        case XBZKeyBoardStateVoice:
        {
            self.voiceButton.selected = YES;
            self.faceButton.selected = NO;
            self.moreButton.selected = NO;
            [self.textView resignFirstResponder];
            self.textView.hidden = YES;
            self.bottomView.hidden = YES;
            if (self.lastHeight >= kToolBarHeight) {
                
                [UIView animateWithDuration:0.25f animations:^{
                    
                    self.frame = CGRectMake(0, self.originFrame.origin.y, self.width, kToolBarHeight);
                    
                } completion:^(BOOL finished) {
                    
                }];
            }
        }
            break;
        case XBZKeyBoardStateFace:
        {
            self.voiceButton.selected = NO;
            self.faceButton.selected = YES;
            self.moreButton.selected = NO;
            [self.textView resignFirstResponder];
            self.textView.hidden = NO;
            self.bottomView.hidden = NO;
            [self showBottomViewWithDuration:0.25f];
        }
            break;
        case XBZKeyBoardStateMore:
        {
            self.voiceButton.selected = NO;
            self.faceButton.selected = NO;
            self.moreButton.selected = YES;
            [self.textView resignFirstResponder];
            self.textView.hidden = NO;
            self.bottomView.hidden = NO;
            [self showBottomViewWithDuration:0.25f];
        }
            break;
        case XBZKeyBoardStateKeyBoard:
        {
            self.voiceButton.selected = NO;
            self.faceButton.selected = NO;
            self.moreButton.selected = NO;
            if (!self.textView.isFirstResponder) {
                [self.textView becomeFirstResponder];
            }
            
            self.textView.hidden = NO;
            self.bottomView.hidden = YES;
        }
            break;
    }
}

- (void)showBottomViewWithDuration:(NSTimeInterval)duration {
    
    [UIView animateWithDuration:duration animations:^{
        
        self.frame = CGRectMake(0, SCREEN_Height-kHomeIndecatorHeight-self.lastHeight-kBottomViewHeight-self.navigationBarHeight, self.width, self.lastHeight+kBottomViewHeight);
        
    }];
}

- (void)setTextViewPlaceHolder:(NSString *)textViewPlaceHolder {
    _textViewPlaceHolder = textViewPlaceHolder;
    
    self.textView.placeHolder = textViewPlaceHolder;
}

//MARK: - Getter

- (UIView *)topBarView {
    if (!_topBarView) {
        _topBarView = [UIView new];
        
    }
    return _topBarView;
}

- (UIButton *)voiceButton {
    if (!_voiceButton) {
        _voiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_voiceButton setImage:[UIImage imageNamed:@"icon_keyboard_voice_nor"] forState:UIControlStateNormal];
        [_voiceButton setImage:[UIImage imageNamed:@"icon_keyboard_keyboard_nor"] forState:UIControlStateSelected];
        [_voiceButton addTarget:self action:@selector(pressVoiceButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _voiceButton;
}

- (UIButton *)faceButton {
    if (!_faceButton) {
        _faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_faceButton setImage:[UIImage imageNamed:@"icon_keyboard_face_nor"] forState:UIControlStateNormal];
        [_faceButton setImage:[UIImage imageNamed:@"icon_keyboard_keyboard_nor"] forState:UIControlStateSelected];
        [_faceButton addTarget:self action:@selector(pressFaceButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _faceButton;
}

- (UIButton *)moreButton {
    if (!_moreButton) {
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreButton setImage:[UIImage imageNamed:@"icon_keyboard_add_nor"] forState:UIControlStateNormal];
        [_moreButton setImage:[UIImage imageNamed:@"icon_keyboard_keyboard_nor"] forState:UIControlStateSelected];
        [_moreButton addTarget:self action:@selector(pressMoreButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreButton;
}

- (UIButton *)recordButton {
    if (!_recordButton) {
        _recordButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _recordButton.bounds = CGRectMake(0, 0, kTextViewWidth, kButtonHeight);
        _recordButton.backgroundColor = [UIColor whiteColor];
        _recordButton.layer.borderWidth = 0.5;
        _recordButton.layer.borderColor = kLineColor.CGColor;
        _recordButton.clipsToBounds = YES;
        _recordButton.layer.cornerRadius = 3;
        _recordButton.userInteractionEnabled = YES;
        _recordButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [_recordButton setTitleColor:[UIColor colorWithRGB:0x646464] forState:UIControlStateNormal];
        [_recordButton setTitle:@"按住 说话" forState:UIControlStateNormal];
        [_recordButton setTitle:@"松开 结束" forState:UIControlStateHighlighted];
        [_recordButton addTarget:self action:@selector(beginRecordVoice:) forControlEvents:UIControlEventTouchDown];
        [_recordButton addTarget:self action:@selector(endRecordVoice:) forControlEvents:UIControlEventTouchUpInside];
        [_recordButton addTarget:self action:@selector(cancelRecordVoice:) forControlEvents:UIControlEventTouchUpOutside | UIControlEventTouchCancel];
        [_recordButton addTarget:self action:@selector(RemindDragExit:) forControlEvents:UIControlEventTouchDragExit];
        [_recordButton addTarget:self action:@selector(RemindDragEnter:) forControlEvents:UIControlEventTouchDragEnter];
    }
    return _recordButton;
}

- (XBZKeyBoardTextView *)textView {
    if (!_textView) {
        _textView = [XBZKeyBoardTextView new];
        _textView.delegate = self;
        _textView.returnKeyType = UIReturnKeySend;
        _textView.placeHolder = @"说点什么吧...";
    }
    return _textView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [UIView new];
        _bottomView.backgroundColor = [UIColor colorWithRGB:0xf5f5f5];
        _bottomView.hidden = YES;
    }
    return _bottomView;
}

- (XBZChatEmojiView *)emojiView {
    if (!_emojiView) {
        _emojiView = [[XBZChatEmojiView alloc] initWithFrame:CGRectMake(0, 0, self.width, kBottomViewHeight)];
        _emojiView.delegate = self;
    }
    return _emojiView;
}

- (XBZChatMoreView *)moreView {
    if (!_moreView) {
        _moreView = [[XBZChatMoreView alloc] initWithFrame:CGRectMake(0, 0, self.width, kBottomViewHeight)];
        _moreView.delegate = self;
    }
    return _moreView;
}

- (XBZVoiceAnimationView *)voiceView {
    if (!_voiceView) {
        _voiceView = [[XBZVoiceAnimationView alloc] initWithFrame:CGRectMake(SCREEN_Width/2.f-160.f/2.f, SCREEN_Height/2.f-180.f/2.f, 160.f, 180.f)];
    }
    return _voiceView;
}

//MARK: - Dealloc

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

@end
