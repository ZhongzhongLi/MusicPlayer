//
//  MusicViewController.h
//  MusicPlayer_lzz1
//
//  Created by qianfeng01 on 15-5-28.
//  Copyright (c) 2015年 李忠. All rights reserved.
//

#import <UIKit/UIKit.h>
NSInteger listNumber;

@interface MusicViewController : UIViewController

@property (assign, nonatomic) NSInteger songSum;
@property (assign, nonatomic) NSInteger n;
@property (assign, nonatomic) BOOL isSingleCircle;
@property (assign, nonatomic) BOOL isTableCircle;

@property (retain, nonatomic) IBOutlet UIButton *start;
@property (retain, nonatomic) IBOutlet UIButton *pause;
@property (retain, nonatomic) IBOutlet UIButton *stop;
@property (retain, nonatomic) IBOutlet UIButton *last;
@property (retain, nonatomic) IBOutlet UIButton *next;
@property (retain, nonatomic) IBOutlet UISlider *slider;
@property (retain, nonatomic) IBOutlet UIButton *singleCircle;
@property (retain, nonatomic) IBOutlet UIButton *tableCircle;
@property (retain, nonatomic) IBOutlet UILabel *playerTimer;
@property (retain, nonatomic) IBOutlet UILabel *songInfo;
@property (retain, nonatomic) NSMutableArray *lrcArr;
@property (retain, nonatomic) IBOutlet UISlider *volume;
@property (retain, nonatomic) IBOutlet UIButton *listMenu;
- (IBAction)listMenuClick:(id)sender;


- (IBAction)startClick:(id)sender;
- (IBAction)pauseClick:(id)sender;
- (IBAction)stopClick:(id)sender;
- (IBAction)lastClick:(id)sender;
- (IBAction)nextClick:(id)sender;
- (IBAction)singleClick:(id)sender;
- (IBAction)tableClick:(id)sender;
- (IBAction)sliderClick:(id)sender;
- (IBAction)volumeClick:(id)sender;


@end
