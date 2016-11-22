//
//  MVMovieCastView.m
//  MovieApp
//
//  Created by Clay Jones on 11/21/16.
//  Copyright © 2016 ClayJones. All rights reserved.
//

#import "MVMovieCastView.h"
#import "MVContentManager.h"
#import "MVCastMemberTableViewCell.h"
#import <Masonry/Masonry.h>

@implementation MVMovieCastView {
    UITableView *_tableView;
    NSArray <MVCastMember *> *_cast;
    UIRefreshControl *_refreshControl;
}

@synthesize movie = _movie;

-(void)setMovie:(MVMovie *)movie {
    _movie = movie;
    [self loadCast];
}

#pragma mark - Database calls

-(void) loadCast {
    [[MVContentManager sharedManager] loadCastForMovie:_movie withCompletionBlock:^(NSArray<MVCastMember *> *cast, BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                _cast = cast;
            }
            [_tableView reloadData];
            [_refreshControl endRefreshing];
        });
    }];
}

#pragma mark - View Layout

-(instancetype)init {
    self = [super init];
    if (self) {
        _tableView = [[UITableView alloc] initWithFrame:self.frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView setContentInset:UIEdgeInsetsMake(20, 0, 0, 0)];
        [self addSubview:_tableView];
        
        //add refresh controller
        UITableViewController *tableViewController = [[UITableViewController alloc] init];
        tableViewController.tableView = _tableView;
        
        _refreshControl = [[UIRefreshControl alloc] init];
        [_refreshControl addTarget:self action:@selector(loadCast) forControlEvents:UIControlEventValueChanged];
        tableViewController.refreshControl = _refreshControl;
    }
    return self;
}

-(void)layoutSubviews {
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self);
    }];
}

#pragma mark - TableView Protocols

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"MV_CAST_CELL";
    MVCastMemberTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MVCastMemberTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    cell.castMember = [_cast objectAtIndex:indexPath.row];
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_cast.count > 0) {
        _tableView.backgroundView = nil;
        return 1;
    }
    
    UILabel *noDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _tableView.bounds.size.width, _tableView.bounds.size.height)];
    noDataLabel.text = [NSString stringWithFormat: @"No Cast Members were found.\rPlease pull down to refresh."];
    [noDataLabel setFont:[UIFont fontWithName:MV_REGULAR_FONT_NAME size:16]];
    noDataLabel.textColor = [UIColor blackColor];
    noDataLabel.textAlignment = NSTextAlignmentCenter;
    noDataLabel.lineBreakMode = NSLineBreakByWordWrapping;
    noDataLabel.numberOfLines = 2;
    _tableView.backgroundView = noDataLabel;
    
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _cast.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

@end
