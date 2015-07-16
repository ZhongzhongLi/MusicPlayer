//
//  ListViewController.m
//  MusicPlayer_lzz1
//
//  Created by qianfeng01 on 15-5-30.
//  Copyright (c) 2015年 李忠. All rights reserved.
//

#import "ListViewController.h"
extern NSInteger listNumber;

@interface ListViewController () <UITableViewDataSource,UITableViewDelegate>

@end

@implementation ListViewController

- (void)dealloc {
    self.listArr = nil;
    self.listTableView = nil;
    [super dealloc];
}

- (instancetype)init {
    if (self = [super init]) {
        self.listArr = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self allInit];
}

- (void)allInit {
    [self dataInit];
    [self createListTableView];
}

- (void)dataInit {
    [self.listTableView reloadData];
}

- (void)createListTableView {
    self.listTableView.dataSource = self;
    self.listTableView.delegate = self;
    [self.listTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"listCell"];
}

#pragma mark - 协议方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listCell"];
    cell.textLabel.text = self.listArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    listNumber = indexPath.row;
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
