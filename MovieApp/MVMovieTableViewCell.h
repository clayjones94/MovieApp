//
//  MVMovieTableViewCell.h
//  MovieApp
//
//  Created by Clay Jones on 11/20/16.
//  Copyright © 2016 ClayJones. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MVMovie.h"
#import "MVMovieMainInfoView.h"

@interface MVMovieTableViewCell : UITableViewCell

//@property UIImageView *posterImageView;
@property MVMovieMainInfoView *infoView;
@property (nonatomic) MVMovie *movie;

@end
