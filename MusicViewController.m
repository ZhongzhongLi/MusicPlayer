//
//  MusicViewController.m
//  MusicPlayer_lzz1
//
//  Created by qianfeng01 on 15-5-28.
//  Copyright (c) 2015年 李忠. All rights reserved.
//

#import "MusicViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "QFLrcParser.h"
#import "ListViewController.h"
/*define**************************************/
#define kScreenSize [UIScreen mainScreen].bounds.size
/*********************************************/
@interface MusicViewController () <AVAudioPlayerDelegate,UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) AVAudioPlayer *player;
@property (strong, nonatomic) QFLrcParser *parser;
@property (strong, nonatomic) NSTimer *timer;
//@property (assign, nonatomic) NSInteger n;
//@property (assign, nonatomic) NSInteger songSum;
@property (strong, nonatomic) NSMutableArray *songAndLrcArr;
@property (strong, nonatomic) NSMutableArray *songPathArr;
@property (strong, nonatomic) NSMutableArray *lrcPathArr;
@property (strong, nonatomic) UITableView *tableView;
/*********************************************/
@property (assign, nonatomic) NSInteger indexLrc;
/*********************************************/

@end

@implementation MusicViewController

- (void)dealloc {
    [_start release];
    [_pause release];
    [_stop release];
    [_last release];
    [_next release];
    [_slider release];
    self.timer = nil;
    self.player = nil;
    self.parser = nil;
    self.songAndLrcArr = nil;
    self.songPathArr = nil;
    self.lrcPathArr = nil;
    [_singleCircle release];
    [_tableCircle release];
    [_playerTimer release];
    [_songInfo release];
    self.tableView = nil;
    self.lrcArr = nil;
    [_volume release];
    [_listMenu release];
    [super dealloc];
}

- (void)awakeFromNib {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self allInit];
}

- (void)allInit {
    [self createSongArr];
    [self playModeInit];
    [self createTimer];
    [self createTableView];
}

- (void)playModeInit {
    _n = 0;
    self.songSum = self.songAndLrcArr.count;
    self.isSingleCircle = false;
    self.isTableCircle = true;
}

- (void)createSongArr {
    self.songPathArr = [[NSMutableArray alloc] init];
    self.lrcPathArr = [[NSMutableArray alloc] init];
    self.songAndLrcArr = [@[@"北京北京",@"春天里",@"蓝莲花",@"像梦一样自由",@"小苹果"] mutableCopy];
    for (NSInteger i=0; i<self.songAndLrcArr.count; i++) {
        [self.songPathArr addObject:[[NSBundle mainBundle] pathForResource:self.songAndLrcArr[i] ofType:@"mp3"]];
        [self.lrcPathArr addObject:[[NSBundle mainBundle] pathForResource:self.songAndLrcArr[i] ofType:@"lrc"]];
    }
}

- (void)createParser:(NSString *)lrc {
    if (self.parser) {
        self.parser = nil;
    }
    self.parser = [[QFLrcParser alloc] initWithFile:lrc];
/*********************************************/
    self.lrcArr = self.parser.allLrcItems;//tableView的数据源
    //在计时器响应函数中更新数据;
    [self.tableView reloadData];
/*********************************************/
}

#pragma mark - 定时器

- (void)createTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(uptimerClick:) userInfo:nil repeats:YES];
    [self.timer setFireDate:[NSDate distantFuture]];
}

- (void)uptimerClick:(NSTimer *)timer {
    //playerTimer
    self.playerTimer.text = [self changeToTime];
    //progress slider
    self.slider.value = self.player.currentTime/self.player.duration;
    //lrc
    [self updateTableView];
    //songInfo
    self.songInfo.text = [self.parser.title stringByAppendingFormat:@"-(%@)",self.parser.author];
    //由列表界面穿过来的值进行操作
    [self playerWithListView];
}


- (void)updateTableView {
    LrcAndIndex st = [self.parser getLrcByTime:self.player.currentTime];
    self.indexLrc = st.index;
    [self.tableView reloadData]; //必须得更新因为字体需要变化!`
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.indexLrc inSection:0];
    //为了在跳歌的时候,tableView在最后一行,会动画跳转到第一句话,所以不让下一首的歌词的第一句话发生动画效果
    [self.tableView selectRowAtIndexPath:indexPath animated:(!self.indexLrc ? NO: YES) scrollPosition:UITableViewScrollPositionMiddle];
}

//playerTimer时间的设置
- (NSString *)changeToTime {
    NSInteger time = (NSInteger)(self.player.duration-self.player.currentTime);
    NSInteger minute = time/60;
    NSInteger second = time%60;
    return [NSString stringWithFormat:@"%.2ld:%.2ld",minute,second];
}

- (void)createAvAudio:(NSString *)song {
    NSLog(@"%@",song);
    if (self.player) {
        [self.player stop];
        self.player = nil;
    }
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:song] error:nil];
    self.player.delegate = self;
    [self.player prepareToPlay];
    [self.player play];
/*********************************************/
    self.player.volume = self.volume.value;
/*********************************************/
}

#pragma mark - AvAudioPlayer协议

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if (self.isSingleCircle) {
        [self createParser:self.lrcPathArr[_n]];
        [self createAvAudio:self.songPathArr[_n]];
    } else if (self.isTableCircle) {
         _n = (_n==self.songSum) ? 0: _n+1;
        [self synchronizeWithNAndListNumber];
        [self createParser:self.lrcPathArr[_n]];
        [self createAvAudio:self.songPathArr[_n]];
    }
}

#pragma mark - 各类按钮的触发

- (IBAction)listMenuClick:(id)sender {
    ListViewController *listViewController = [[ListViewController alloc] init];
    listViewController.listArr = self.songAndLrcArr;
    [self presentViewController:listViewController animated:YES completion:nil];
    [listViewController release];
}

- (IBAction)startClick:(id)sender {
    if (self.parser) {
        [self.player play];
    } else {
        [self createParser:self.lrcPathArr[_n]];
        [self createAvAudio:self.songPathArr[_n]];
    }
    [self.timer setFireDate:[NSDate distantPast]];
}

- (IBAction)pauseClick:(id)sender {
    [self.player pause];
}

- (IBAction)stopClick:(id)sender {
    [self.player stop];
}

- (IBAction)lastClick:(id)sender {
    if (--_n == -1) {
        _n = 0;
    }
    [self synchronizeWithNAndListNumber];
    NSLog(@"%@",self.songPathArr[_n]);
    [self createParser:self.lrcPathArr[_n]];
    [self createAvAudio:self.songPathArr[_n]];
}

- (IBAction)nextClick:(id)sender {
    if (++_n == _songSum) {
        _n = 0;
    }
    [self synchronizeWithNAndListNumber];
    NSLog(@"%@",self.songPathArr[_n]);
    [self createParser:self.lrcPathArr[_n]];
    [self createAvAudio:self.songPathArr[_n]];
}

- (IBAction)singleClick:(id)sender {
    self.isTableCircle = NO;
    self.isSingleCircle = YES;
}

- (IBAction)tableClick:(id)sender {
    self.isSingleCircle = NO;
    self.isTableCircle = YES;
}

- (IBAction)sliderClick:(id)sender {
    self.player.currentTime = self.player.duration*self.slider.value;
}

- (IBAction)volumeClick:(id)sender {
    self.player.volume = self.volume.value;
}

#pragma mark - 创建tableView

- (void)createTableView {
    [self lrcArrInit];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(30, 30, kScreenSize.width-60, 200) style:UITableViewStylePlain];
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"LrcCell" bundle:nil] forCellReuseIdentifier:@"lrcCell"];
    [self.view addSubview:self.tableView];
}

- (void)lrcArrInit {
    self.lrcArr = [[NSMutableArray alloc] init];
}

#pragma mark - UITableView协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.lrcArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"lrcCell"];
    //被选中后cell没有颜色;/***********************************/
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    /********************************************************/
    cell.textLabel.text = ((QFLrcItem *)self.lrcArr[indexPath.row]).lrc;
    cell.textLabel.textColor = [UIColor clearColor];
    if (indexPath.row == self.indexLrc) {
        cell.textLabel.textColor = [UIColor redColor];
    } else {
        cell.textLabel.textColor = [UIColor blackColor];
    }
    return cell;
}

#pragma mark - 有列表界面传来的消息决定播放那首歌

- (void)synchronizeWithNAndListNumber {
    listNumber = _n;
}

- (void)playerWithListView {
    if (_n != listNumber) {
        _n = listNumber;
        [self createAvAudio:self.songPathArr[_n]];
        [self createParser:self.lrcArr[_n]];
    }
}








@end
