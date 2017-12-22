//
//  MVMovieDetailViewController.m
//  MovieApp
//
//  Created by Clay Jones on 11/21/16.
//  Copyright © 2016 ClayJones. All rights reserved.
//

#import "MVMovieDetailViewController.h"
#import "MVMovieMainInfoView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <Masonry/Masonry.h>
#import <ChameleonFramework/Chameleon.h>
#import <HMSegmentedControl/HMSegmentedControl.h>
#import "MVUtils.h"
#import "MVMovieCastView.h"
#import <youtube-ios-player-helper/YTPlayerView.h>
#import "MVContentManager.h"
#import <Branch.h>


@implementation MVMovieDetailViewController {
    MVMovieMainInfoView *_mainView;
    UIImageView *_backdropImageView;
    HMSegmentedControl *_segControl;
    MVMovieCastView *_castView;
    UIView *_infoView;
    YTPlayerView *_trailerView;
    MVContentManager *_contentManager;
    CGRect _tableViewCellLocation;
    UIImageView *_tableViewbBackgroundView;
    UIButton *backButton;
    UIButton *shareButton;
}

@synthesize movie = _movie;

#pragma mark - View Layout

-(void)viewDidLoad {
    _contentManager = [MVContentManager sharedManager];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self layoutViews];
}

-(void) layoutViews {
    [self layoutBackdropView];
    [self layoutBackbutton];
    [self layoutSharebutton];
    [self layoutSegmentedControl];
}

-(void) layoutBackdropView {
    
    //Add background image
    _backdropImageView = [[UIImageView alloc] init];
    [_backdropImageView setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:_backdropImageView];
    
    NSString *urlString = [NSString stringWithFormat:@"https://image.tmdb.org/t/p/w500%@", _movie.backdropPath];
    [_backdropImageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:nil];
    
    [_backdropImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(200);
    }];
    
    //Add gradient overlay
    UIView *gradientView = [[UIView alloc] init];
    UIColor *gradientColor = [UIColor colorWithGradientStyle:UIGradientStyleTopToBottom withFrame:CGRectMake(0, 0, self.view.frame.size.width, 200) andColors:@[[UIColor clearColor], [UIColor whiteColor]]];
    [gradientView setBackgroundColor:gradientColor];
    [_backdropImageView addSubview:gradientView];
    
    [gradientView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.right.equalTo(_backdropImageView);
    }];
}

-(void) layoutBackbutton {
    backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"back_button_icon"] forState:UIControlStateNormal];
    [backButton sizeToFit];
    [backButton addTarget:self action:@selector(dismissViewWithAnimationToTableView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.view).with.offset(15);
    }];
}

-(void) layoutSharebutton {
    shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareButton setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [shareButton sizeToFit];
    [shareButton addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareButton];
    
    [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(15);
        make.right.equalTo(self.view).with.offset(-15);
    }];
}

-(void) share {
    BranchUniversalObject *buo = [[BranchUniversalObject alloc] initWithTitle:self.movie.title];
    buo.imageUrl = [NSString stringWithFormat:@"https://image.tmdb.org/t/p/w500%@", _movie.backdropPath];
    [buo setCanonicalIdentifier:[NSString stringWithFormat:@"%ld", _movie.movieID]];
    [buo showShareSheetWithShareText:@"Check out this movie!" completion:^(NSString * _Nullable activityType, BOOL completed) {
        
    }];
}

-(void) layoutSegmentedControl {
    _segControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"Cast", @"Trailer"]];
    [_segControl setBackgroundColor:[UIColor clearColor]];
    [_segControl addTarget:self action:@selector(segmentedControlChangedValue) forControlEvents:UIControlEventValueChanged];
    NSDictionary *titleTextAttr = @{
                                    NSFontAttributeName:[UIFont fontWithName:MV_REGULAR_FONT_NAME size:15],
                                    NSForegroundColorAttributeName: [UIColor lightGrayColor]
                                    };
    NSDictionary *selectedTitleTextAttr = @{
                                            NSFontAttributeName:[UIFont fontWithName:MV_BOLD_FONT_NAME size:15],
                                            NSForegroundColorAttributeName:[UIColor darkGrayColor]
                                            };
    
    _segControl.titleTextAttributes = titleTextAttr;
    _segControl.selectedTitleTextAttributes = selectedTitleTextAttr;
    _segControl.selectionIndicatorColor = [MVUtils mainColor];
    _segControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    _segControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    _segControl.selectionIndicatorHeight = 2.0f;
    _segControl.selectionIndicatorEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    _segControl.borderType = HMSegmentedControlBorderTypeBottom;
    _segControl.borderWidth = 0.5f;
    _segControl.borderColor = [UIColor lightGrayColor];
    [self.view addSubview:_segControl];
    [_segControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_centerY).with.offset(30);
        make.right.left.equalTo(self.view);
        make.height.mas_equalTo(25);
    }];
    
    [self layoutCastView];
}

-(void) segmentedControlChangedValue {
    if(_segControl.selectedSegmentIndex == 0) {
        [self layoutCastView];
    } else if(_segControl.selectedSegmentIndex == 1) {
        [self layoutTrailerView];
    }
}

-(void)layoutCastView {
    if (_trailerView && _trailerView.superview) [_trailerView removeFromSuperview];
    if (!_castView) {
        _castView = [[MVMovieCastView alloc] init];
        _castView.movie = _movie;
        [self.view addSubview:_castView];
    }
    if(!_castView.superview) [self.view addSubview:_castView];
    [_castView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(_segControl.mas_bottom);
    }];
}

-(void)layoutTrailerView {
    if (_castView && _castView.superview) [_castView removeFromSuperview];
    if (!_trailerView) {
        _trailerView = [[YTPlayerView alloc] init];
        [_contentManager loadTrailerForMovie:_movie withCompletionBlock:^(NSString *youtubeID, BOOL success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_trailerView loadWithVideoId:youtubeID];
            });
        }];
        [self.view addSubview:_trailerView];
    }
    if(!_trailerView.superview) [self.view addSubview:_trailerView];
    [_trailerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(_segControl.mas_bottom);
    }];
}

#pragma mark - Animation Presentation/Dismissal

-(void) animatePresentationWithStartRect: (CGRect) rect withBackgroundImage:(UIImage *) backgroundImage{
    _tableViewbBackgroundView = [[UIImageView alloc] initWithImage:backgroundImage];
    [self.view addSubview:_tableViewbBackgroundView];
    
    if (rect.size.width == 0 || rect.size.height == 0) {
        rect = CGRectMake(CELL_SPACING, -100, self.view.frame.size.width - CELL_SPACING * 2, MOVIE_INFO_CELL_HEIGHT - CELL_SPACING);
    }
    
    _tableViewCellLocation = rect;
    
    _mainView = [[MVMovieMainInfoView alloc] init];
    [_mainView.layer setShadowColor:[UIColor lightGrayColor].CGColor];
    [_mainView.layer setShadowOpacity:0.4];
    [_mainView.layer setShadowRadius:3.0];
    [_mainView.layer setShadowOffset:CGSizeMake(0.0, 10.0)];
    [_mainView setMovie:_movie];
    [_mainView setFrame:rect];
    [_mainView layoutViews];
    [_mainView setDetailMode:YES];
    [self.view addSubview:_mainView];
    
    CGRect destinationRect = CGRectMake(rect.origin.x, MOVIE_INFO_CELL_HEIGHT, rect.size.width, rect.size.height);
    
    [backButton setEnabled:NO];
    
    [UIView animateWithDuration:.3 animations:^{
        [_mainView setFrame:destinationRect];
        [_tableViewbBackgroundView setAlpha:0];
    } completion:^(BOOL finished) {
        [_tableViewbBackgroundView removeFromSuperview];
        [backButton setEnabled:YES];
    }];
}

-(void) dismissViewWithAnimationToTableView {
    [self.view addSubview:_tableViewbBackgroundView];
    [_tableViewbBackgroundView setAlpha:0.0];
    [self.view bringSubviewToFront:_mainView];
    [backButton setEnabled:NO];
    [_mainView setDetailMode:NO];
    
    [UIView animateWithDuration:.3 animations:^{
        [_mainView setFrame:_tableViewCellLocation];
        [_tableViewbBackgroundView setAlpha:1.0];
    } completion:^(BOOL finished) {
        [backButton setEnabled:YES];
        [self.navigationController popViewControllerAnimated:NO];
    }];
}


@end
