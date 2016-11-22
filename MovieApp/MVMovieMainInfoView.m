//
//  MVMovieMainInfoView.m
//  MovieApp
//
//  Created by Clay Jones on 11/21/16.
//  Copyright © 2016 ClayJones. All rights reserved.
//

#import "MVMovieMainInfoView.h"
#import "MVUtils.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "MVConstants.h"

@implementation MVMovieMainInfoView {
    UILabel *_titleLabel;
    UILabel *_backgroundTitleLabel;
    UILabel *_yearLabel;
    
    UIView *_separator;
    
    UIImageView *_popularityIcon;
    UILabel *_popularityDetailLabel;
    UILabel *_popularityLabel;
    
    UIImageView *_ratingIcon;
    UILabel *_ratingDetailLabel;
    UILabel *_ratingLabel;
    
    UIImageView *_posterImageView;
}

@synthesize movie = _movie;
@synthesize detailMode = _detailMode;

-(void)setMovie:(MVMovie *)movie {
    _movie = movie;
    _titleLabel.text = _movie.title;
    _backgroundTitleLabel.text = [_movie.title uppercaseString];
    
    _yearLabel.text = _movie.releaseDate;
    [_yearLabel sizeToFit];
    
    _popularityLabel.text = [NSString stringWithFormat:@"%.1lf", [[NSDecimalNumber decimalNumberWithDecimal:movie.popularity] doubleValue]];
    [_popularityLabel sizeToFit];
    
    _ratingLabel.text = [NSString stringWithFormat:@"%.0lf%%", [[NSDecimalNumber decimalNumberWithDecimal:movie.voteAverage] doubleValue]*10];
    [_ratingLabel sizeToFit];
    
    NSString *urlString = [NSString stringWithFormat:@"https://image.tmdb.org/t/p/w90%@", movie.posterPath];
    [_posterImageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"missing_poster"]];
}

-(void)setDetailMode:(BOOL)detailMode {
    _detailMode = detailMode;
    [self animateDetailMode];
}

-(void) animateDetailMode { 
    [UIView animateWithDuration:.2 animations:^{
        [self layoutViews];
    }];
}

-(instancetype)init {
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        [self.layer setCornerRadius:5];
        
        _backgroundTitleLabel = [[UILabel alloc] init];
        [_backgroundTitleLabel setTextColor:[UIColor groupTableViewBackgroundColor]];
        _backgroundTitleLabel.numberOfLines = 1;
        _backgroundTitleLabel.lineBreakMode = NSLineBreakByClipping;
        [_backgroundTitleLabel setFont:[UIFont fontWithName:@"AvenirNext-Heavy" size:64]];
        [_backgroundTitleLabel setAlpha:.4];
        [self addSubview:_backgroundTitleLabel];
        
        _posterImageView = [[UIImageView alloc] init];
        [_posterImageView setBackgroundColor:[UIColor grayColor]];
        [_posterImageView.layer setCornerRadius:5];
        [_posterImageView.layer setMasksToBounds:YES];
        [self addSubview:_posterImageView];
        
        _separator = [UIView new];
        [_separator setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        [self addSubview:_separator];
        
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setTextColor:[UIColor darkGrayColor]];
        _titleLabel.numberOfLines = 1;
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [_titleLabel setFont:[UIFont fontWithName:MV_BOLD_FONT_NAME size:14]];
        [self addSubview:_titleLabel];
        
        _yearLabel = [[UILabel alloc] init];
        [_yearLabel setTextColor:[UIColor lightGrayColor]];
        [_yearLabel setFont:[UIFont fontWithName:MV_BOLD_FONT_NAME size:12]];
        [self addSubview:_yearLabel];
        
        _popularityIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"star_icon"]];
        [_popularityIcon sizeToFit];
        _popularityIcon.image = [_popularityIcon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_popularityIcon setTintColor:[MVUtils starColor]];
        [self addSubview:_popularityIcon];
        
        _popularityDetailLabel = [[UILabel alloc] init];
        [_popularityDetailLabel setTextColor:[UIColor lightGrayColor]];
        [_popularityDetailLabel setFont:[UIFont fontWithName:MV_REGULAR_FONT_NAME size:12]];
        [_popularityDetailLabel setText:@"Popularity"];
        [self addSubview:_popularityDetailLabel];
        
        _popularityLabel = [[UILabel alloc] init];
        [_popularityLabel setTextColor:[UIColor darkGrayColor]];
        [_popularityLabel setFont:[UIFont fontWithName:MV_BOLD_FONT_NAME size:16]];
        [self addSubview:_popularityLabel];
        
        _ratingIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"popcorn_icon"]];
        [_ratingIcon sizeToFit];
        [self addSubview:_ratingIcon];
        
        _ratingDetailLabel = [[UILabel alloc] init];
        [_ratingDetailLabel setTextColor:[UIColor lightGrayColor]];
        [_ratingDetailLabel setFont:[UIFont fontWithName:MV_REGULAR_FONT_NAME size:12]];
        [_ratingDetailLabel setText:@"Rating"];
        [self addSubview:_ratingDetailLabel];
        
        _ratingLabel = [[UILabel alloc] init];
        [_ratingLabel setTextColor:[UIColor darkGrayColor]];
        [_ratingLabel setFont:[UIFont fontWithName:MV_BOLD_FONT_NAME size:16]];
        [self addSubview:_ratingLabel];
    }
    return self;
}

-(void) layoutViews {
    [self setBackgroundColor:[UIColor whiteColor]];
    
    CGFloat MARGIN = 14;
    CGFloat PHOTO_MARGIN = 10;

    if (!_detailMode) {
        [_posterImageView setFrame:CGRectMake(PHOTO_MARGIN, PHOTO_MARGIN, POSTER_IMAGE_HEIGHT, MOVIE_INFO_CELL_HEIGHT - PHOTO_MARGIN * 4)];
    } else {
        [_posterImageView setFrame: CGRectMake(- PHOTO_MARGIN * .5, - PHOTO_MARGIN * 1.5, POSTER_IMAGE_HEIGHT + PHOTO_MARGIN * 2, MOVIE_INFO_CELL_HEIGHT + PHOTO_MARGIN * 1)];
    }
    
    [_separator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_posterImageView.mas_right).with.offset(MARGIN);
        make.right.equalTo(self).with.offset(-MARGIN);
        make.centerY.equalTo(self);
        make.height.mas_equalTo(0.5f);
    }];
    
    [_backgroundTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_posterImageView.mas_right).with.offset(2);
        make.right.equalTo(self.mas_right).with.offset(2);
        make.top.equalTo(self).with.offset(0);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_separator);
        make.top.equalTo(self).with.offset(PHOTO_MARGIN * 2);
    }];
    
    [_yearLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_separator);
        make.top.equalTo(_titleLabel.mas_bottom).with.offset(3);
    }];
    
    [_popularityIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_separator);
        make.top.equalTo(_separator.mas_bottom).with.offset(12);
    }];
    
    [_popularityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_popularityIcon.mas_right).with.offset(2);
        make.bottom.equalTo(_popularityIcon).with.offset(2);
    }];
    
    [_popularityDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_popularityIcon).with.offset(2);
        make.top.equalTo(_popularityIcon.mas_bottom).with.offset(5);
    }];
    
    [_ratingIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_popularityDetailLabel.mas_right).with.offset(20);
        make.centerY.equalTo(_popularityIcon);
    }];
    
    [_ratingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_ratingIcon.mas_right).with.offset(2);
        make.centerY.equalTo(_popularityLabel);
    }];
    
    [_ratingDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_ratingIcon).with.offset(10);
        make.centerY.equalTo(_popularityDetailLabel);
    }];
}

@end
