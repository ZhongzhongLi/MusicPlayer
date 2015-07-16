//
//  ListViewController.h
//  MusicPlayer_lzz1
//
//  Created by qianfeng01 on 15-5-30.
//  Copyright (c) 2015年 李忠. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListViewController : UIViewController
@property (retain, nonatomic) IBOutlet UITableView *listTableView;
@property (nonatomic, strong) NSMutableArray *listArr;

@end
