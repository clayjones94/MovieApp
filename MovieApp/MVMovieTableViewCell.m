//
//  MVMovieTableViewCell.m
//  MovieApp
//
//  Created by Clay Jones on 11/20/16.
//  Copyright © 2016 ClayJones. All rights reserved.
//

#import "MVMovieTableViewCell.h"
#import <Masonry/Masonry.h>
#import "MVUtils.h"
#import "MVConstants.h"

@implementation MVMovieTableViewCell {

}

@synthesize movie = _movie;
@synthesize infoView = _infoView;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        
        _infoView = [[MVMovieMainInfoView alloc] init];
        
        [self addSubview:_infoView];
    }
    return self;
}


-(void)setMovie:(MVMovie *)movie {
    _movie = movie;
    [_infoView setMovie:movie];
}

-(void) layoutSubviews {
    [_infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(CELL_SPACING/2);
        make.bottom.equalTo(self).with.offset(-(CELL_SPACING/2));
        make.left.equalTo(self).with.offset(CELL_SPACING);
        make.right.equalTo(self).with.offset(-CELL_SPACING);
    }];

    [_infoView layoutViews];
}

@end
