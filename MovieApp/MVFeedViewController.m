//
//  MVFeedViewController.m
//  MovieApp
//
//  Created by Clay Jones on 11/20/16.
//  Copyright © 2016 ClayJones. All rights reserved.
//

#import "MVFeedViewController.h"
#import "MVDatabase.h"
#import "MVContentManager.h"
#import "MVConstants.h"
#import "MVMovieTableViewCell.h"
#import "MVUtils.h"
#import <Masonry/Masonry.h>
#import "MVMovie.h"
#import "MVMovieDetailViewController.h"
#import "MVMovieMainInfoView.h"

@implementation MVFeedViewController {
    UITableView *_tableView;
    MKDropdownMenu *_dropdownMenu;
    NSArray<MVMovie *> *_movies;
    MVContentManager *_contentManager;
    MVMovieListType _listType;
    NSInteger _currentPage;
    UIRefreshControl *_refreshControl;
}

-(void)viewDidLoad {
    [self.navigationController setNavigationBarHidden:YES];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self initVariables];
    [self drawBackgroundView];
    [self loadMovies];
    [self layoutViews];
}

-(void) initVariables {
    _listType = NOW_PLAYING;
    _currentPage = 1;
    _contentManager = [MVContentManager sharedManager];
}

-(void) loadMovies {
    [_contentManager loadMoviesForListType:_listType forPage:_currentPage withCompletionBlock:^(BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!success) {
                [self displayFailureAlert];
            }
            _movies = [_contentManager getMovies];
            [_tableView reloadData];
            [_refreshControl endRefreshing];
        });
    }];
}

#pragma mark - View Layout

//Draws the background design
-(void) drawBackgroundView {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UIBezierPath* path = [[UIBezierPath alloc]init];
    [path moveToPoint:CGPointMake(0.0, 0.0)];
    [path addLineToPoint:CGPointMake(0.0,self.view.frame.size.height * .25)];
    [path addLineToPoint:CGPointMake(self.view.frame.size.width, self.view.frame.size.height * .18)];
    [path addLineToPoint:CGPointMake(self.view.frame.size.width, 0)];
    [path closePath];
    
    CAShapeLayer *shapeView = [[CAShapeLayer alloc] init];
    [shapeView setPath:path.CGPath];
    [shapeView setFillColor:[MVUtils mainColor].CGColor];
    [[self.view layer] addSublayer:shapeView];
}

-(void) layoutViews {
    
    //layout dropdownmenu
    
    _dropdownMenu = [[MKDropdownMenu alloc] init];
    [_dropdownMenu setDelegate:self];
    [_dropdownMenu setDataSource:self];
    [_dropdownMenu setTintColor:[UIColor whiteColor]];
    [_dropdownMenu setRowSeparatorColor:[UIColor clearColor]];
    [self.view addSubview:_dropdownMenu];
    
    [_dropdownMenu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.equalTo(self.view);
        make.width.mas_equalTo(DROP_DOWN_MENU_WIDTH);
        make.height.mas_equalTo(DROP_DOWN_MENU_HEIGHT);
    }];
    
    //layout tableview
    
    _tableView = [[UITableView alloc] init];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(_dropdownMenu.mas_bottom);
    }];
    
    //add refresh controller
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = _tableView;
    
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self action:@selector(loadMovies) forControlEvents:UIControlEventValueChanged];
    tableViewController.refreshControl = _refreshControl;
}

#pragma mark - TableView Protocols

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"MOVIE_CELL_IDENTIFIER";
    MVMovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MVMovieTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    MVMovie *movie = [_movies objectAtIndex:indexPath.row];
    
    cell.movie = movie;
    
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ( _movies.count > 0) {
        _tableView.backgroundView = nil;
        return 1;
    }
    
    UILabel *noDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _tableView.bounds.size.width, _tableView.bounds.size.height)];
    noDataLabel.text = @"No Movies were Found";
    noDataLabel.textColor = [UIColor blackColor];
    [noDataLabel setFont:[UIFont fontWithName:MV_REGULAR_FONT_NAME size:16]];
    noDataLabel.textAlignment = NSTextAlignmentCenter;
    _tableView.backgroundView = noDataLabel;
    
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _movies.count;
}

//Fetch next page of movies if reached bottom
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [tableView numberOfRowsInSection:0] - 1) {
        _currentPage ++;
        [self loadMovies];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return MOVIE_INFO_CELL_HEIGHT;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MVMovieTableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
    
    //Retrieve the location of the cell's main subview on the controllers window
    CGRect rectOfCellInTableView = [tableView rectForRowAtIndexPath: indexPath];
    CGRect rectOfBackgroundInTableView = CGRectMake(rectOfCellInTableView.origin.x + cell.infoView.frame.origin.x, rectOfCellInTableView.origin.y + cell.infoView.frame.origin.y, cell.infoView.frame.size.width, cell.infoView.frame.size.height);
    CGRect rectOfCellInSuperview = [tableView convertRect: rectOfBackgroundInTableView toView: tableView.superview];
    
    //Take screenshot of the background to give animation effect
    UIGraphicsBeginImageContext(self.view.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.view.layer renderInContext:context];
    UIImage *screenShot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    MVMovieDetailViewController *vc = [MVMovieDetailViewController new];
    [vc setMovie:[_movies objectAtIndex: indexPath.row]];
    [self.navigationController pushViewController:vc animated:NO];
    [vc animatePresentationWithStartRect:rectOfCellInSuperview withBackgroundImage: screenShot];
}

#pragma mark - DropDown Protocols

- (NSInteger)numberOfComponentsInDropdownMenu:(MKDropdownMenu *)dropdownMenu {
    return 1;
}

- (NSInteger)dropdownMenu:(MKDropdownMenu *)dropdownMenu numberOfRowsInComponent:(NSInteger)component {
    return MVListTypeCount;
}

-(NSAttributedString *)dropdownMenu:(MKDropdownMenu *)dropdownMenu attributedTitleForComponent:(NSInteger)component {
    NSString *title = [MVUtils stringForListType:_listType];
    NSDictionary *attrDict = @{
                               NSFontAttributeName : [UIFont fontWithName:MV_REGULAR_FONT_NAME size:16.0],
                               NSForegroundColorAttributeName : [UIColor whiteColor]
                               };
    return [[NSAttributedString alloc] initWithString:title attributes:attrDict];
}

-(NSAttributedString *)dropdownMenu:(MKDropdownMenu *)dropdownMenu attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *title = [MVUtils stringForListType:row];
    NSDictionary *attrDict = @{
                               NSFontAttributeName : [UIFont fontWithName:MV_REGULAR_FONT_NAME size:16.0],
                               NSForegroundColorAttributeName : [MVUtils mainColor]
                               };
    return [[NSAttributedString alloc] initWithString:title attributes:attrDict];
}

-(void)dropdownMenu:(MKDropdownMenu *)dropdownMenu didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if(_listType != row){
        _listType = row;
        _currentPage = 1;
        _tableView.contentOffset = CGPointMake(0, 0 - _tableView.contentInset.top);
        [self loadMovies];
        [dropdownMenu reloadAllComponents];
    }
}

#pragma mark - Failure Alerts

-(void) displayFailureAlert {
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Uh Oh"
                                  message:@"We experienced some issues fetching your movies."
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* tryAgain = [UIAlertAction
                         actionWithTitle:@"Try Again"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             [self loadMovies];
                             
                         }];
    
    UIAlertAction* cancel = [UIAlertAction
                               actionWithTitle:@"Cancel"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action)
                               {
                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                   
                               }];
    
    [alert addAction:tryAgain];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
