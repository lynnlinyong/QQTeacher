//
//  RecordAudio.h
//  JuuJuu
//
//  Created by xiaoguang huang on 11-12-19.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import "amrFileCodec.h"

typedef enum voiceLevel
{
   MUTE_LEVEL=0,
   SMALL_LEVEL,
   MID_LEVEL,
   HIGHT_LEVEL
}VoiceLevel;

@protocol RecordAudioDelegate <NSObject>
//0 播放 1 播放完成 2出错
-(void)RecordStatus:(int)status;
@end

@interface RecordAudio : NSObject <AVAudioRecorderDelegate,AVAudioPlayerDelegate>
{
    //Variables setup for access in the class:
	NSURL * recordedTmpFile;
	AVAudioRecorder * recorder;
	NSError * error;
    AVAudioPlayer * avPlayer;
    NSTimer  *timer_;
    float cntTime;
}

@property (nonatomic,assign)id<RecordAudioDelegate> delegate;

- (NSURL *) stopRecord ;
- (void) startRecord;

-(void) play:(NSData*) data;
-(void) stopPlay;
+(NSTimeInterval) getAudioTime:(NSData *) data;
- (void) playMP3:(NSData *) data;
+ (void) playVoice:(NSData *)data;
@end
