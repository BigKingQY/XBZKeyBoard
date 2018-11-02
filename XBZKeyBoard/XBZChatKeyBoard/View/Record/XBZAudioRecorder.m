//
//  XBZAudioRecorder.m
//  XBZKeyBoard
//
//  Created by BigKing on 2018/10/29.
//  Copyright © 2018年 BigKing. All rights reserved.
//

#import "XBZAudioRecorder.h"
#import <AVFoundation/AVFoundation.h>

#define kFilePath (NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES).firstObject)

NSString *const kXBZAudioRecorderNotification = @"kXBZAudioRecorderNotification";

@interface XBZAudioRecorder ()

@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, copy) NSString *tempFilePath;
@property (nonatomic, assign) CGFloat duration;

@property (nonatomic, strong) NSTimer *timer;

@end

static XBZAudioRecorder *_audioRecorder;

@implementation XBZAudioRecorder

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_audioRecorder) {
            _audioRecorder = [[self alloc] init];
        }
    });
    return _audioRecorder;
}

- (BOOL)startRecord {
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession setActive:YES error:nil];
    
    NSMutableDictionary *recordSettings = [[NSMutableDictionary alloc] initWithCapacity:10];
    [recordSettings setObject:[NSNumber numberWithInt: kAudioFormatLinearPCM] forKey: AVFormatIDKey];//ID
    
    [recordSettings setObject:[NSNumber numberWithFloat:11025.0] forKey: AVSampleRateKey];//采样率必须要设为11025才能使转化成mp3格式后不会失真
    
    [recordSettings setObject:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];//通道的数目,1单声道,2立体声
    
    [recordSettings setObject:[NSNumber numberWithInt: AVAudioQualityMin] forKey:AVEncoderAudioQualityKey];

    self.timer = [NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(voiceLevel:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
    if (![NSFileManager.defaultManager fileExistsAtPath:self.filePath]) {
        [NSFileManager.defaultManager createDirectoryAtPath:self.filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    self.tempFilePath = [NSString stringWithFormat:@"%@/%d", self.filePath, (int)[[NSDate date] timeIntervalSince1970]];
    
    NSURL *url = [NSURL fileURLWithPath:self.tempFilePath];
    NSError *error = nil;
    
    self.recorder = [[AVAudioRecorder alloc] initWithURL:url settings:recordSettings error:&error];
    
    if (self.recorder.prepareToRecord) {
        self.recorder.meteringEnabled = YES;
        return [self.recorder record];
    }else {
        NSLog(@"%@", error.userInfo);
        return NO;
    }
}

- (NSDictionary *)stopRecord {
    
    [self.timer invalidate];
    self.timer = nil;
    
    [self.recorder stop];
    [self audioPCMtoMP3WithPath:self.tempFilePath];
    
    
    return @{@"path":[self.tempFilePath stringByAppendingString:@".mp3"],
             @"duration":@(self.duration)};
}

- (BOOL)isRecording {
    return self.recorder.isRecording;
}

- (void)cancelRecording {
    
    [self.timer invalidate];
    self.timer = nil;
    
    [self.recorder stop];
    
    [NSFileManager.defaultManager removeItemAtPath:self.tempFilePath error:nil];
}

- (void)playRecordWithURL:(NSString *)url {
    
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:url]];
    self.player = [[AVPlayer alloc] initWithPlayerItem:item];
    [self.player play];
}

- (void)playLocalRecordWithURL:(NSString *)url {
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:url] error:nil];
    self.audioPlayer.volume = 1;
    [self.audioPlayer prepareToPlay];
    [self.audioPlayer play];
}

- (BOOL)deleteRecordWithURL:(NSString *)url {
    if ([NSFileManager.defaultManager fileExistsAtPath:url]) {
        NSError *error = nil;
        [NSFileManager.defaultManager removeItemAtPath:url error:&error];
        if (error) {
            XBZLog(@"%@", error.userInfo);
            return NO;
        }else {
            return YES;
        }
    }
    return NO;
}


//MARK: - Actions

- (void)voiceLevel:(NSTimer *)timer {
    [self.recorder updateMeters];
    
    float   level;                // The linear 0.0 .. 1.0 value we need.
    float   minDecibels = -80.0f; // Or use -60dB, which I measured in a silent room.
    float   decibels    = [self.recorder averagePowerForChannel:0];
    
    if (decibels < minDecibels) {
        level = 0.0f;
    } else if (decibels >= 0.0f) {
        level = 1.0f;
    } else {
        float   root            = 2.0f;
        float   minAmp          = powf(10.0f, 0.05f * minDecibels);
        float   inverseAmpRange = 1.0f / (1.0f - minAmp);
        float   amp             = powf(10.0f, 0.05f * decibels);
        float   adjAmp          = (amp - minAmp) * inverseAmpRange;
        
        level = powf(adjAmp, 1.0f / root);
    }
    /* level 范围[0 ~ 1], 转为[0 ~100] 之间 */
    dispatch_async(dispatch_get_main_queue(), ^{
//        self->_currentVoiceLevel = (int)(level * 100);
        [NSNotificationCenter.defaultCenter postNotificationName:kXBZAudioRecorderNotification object:nil userInfo:@{@"voiceLevel":@((int)(level * 100))}];
    });
}


//MARK: - Methods

- (void)audioPCMtoMP3WithPath:(NSString *)recordcafPath{
    
    NSString *cafFilePath = recordcafPath;
    NSString *recordmp3Path = [NSString stringWithFormat:@"%@.mp3", recordcafPath];
    
    NSFileManager* fileManager=[NSFileManager defaultManager];
    
    if([fileManager removeItemAtPath:recordmp3Path error:nil
        ]) {
        NSLog(@"删除");
    }
    
    @try {
        
        int read, write;
        FILE *pcm = fopen([cafFilePath cStringUsingEncoding:
                           1], "rb");  //source 被转换的音频文件位置
        
        fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
        
        FILE *mp3 = fopen([recordmp3Path cStringUsingEncoding:1], "wb");  //output 输出生成的Mp3文件位置
        
        const int PCM_SIZE = 8192;
        
        const int MP3_SIZE = 8192;
        
        short int pcm_buffer[PCM_SIZE*2];
        
        unsigned char
        mp3_buffer[MP3_SIZE];
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 11025.0);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            fwrite(mp3_buffer, write, 1, mp3);
        }
        while (read != 0);
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    } @catch (NSException *exception) {
        NSLog(@"%@" ,[exception description]);
    } @finally {
//        NSLog(@"recordmp3Path  = %@", recordmp3Path);
        AVURLAsset* audioAsset =[AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:recordmp3Path] options:nil];
        CMTime audioDuration = audioAsset.duration;
        float audioDurationSeconds = CMTimeGetSeconds(audioDuration);
        self.duration = audioDurationSeconds;
//        XBZLog(@"audioDurationSeconds-->>%f", audioDurationSeconds);
        //删除之前的caf
        [NSFileManager.defaultManager removeItemAtPath:recordcafPath error:nil];
        
    }
}



//MARK: - Getter

- (NSString *)filePath {
    if (!_filePath) {
        _filePath = [NSString stringWithFormat:@"%@/audio/record", kFilePath];
    }
    return _filePath;
}

@end
