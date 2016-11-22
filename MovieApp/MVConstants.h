//
//  MVConstants.h
//  MovieApp
//
//  Created by Clay Jones on 11/20/16.
//  Copyright © 2016 ClayJones. All rights reserved.
//

#ifndef MVConstants_h
#define MVConstants_h

#define MOVIE_INFO_CELL_HEIGHT ((int)150)
#define DROP_DOWN_MENU_WIDTH ((int)150)
#define DROP_DOWN_MENU_HEIGHT ((int)44)
#define POSTER_IMAGE_HEIGHT ((int)80)

static NSString *const MV_BOLD_FONT_NAME = @"Avenir-Heavy";
static NSString *const MV_REGULAR_FONT_NAME = @"Avenir-Book";

typedef enum : NSUInteger {
    NOW_PLAYING,
    POPULAR,
    TOP_RATED,
    UPCOMING,
    
    MVListTypeCount
} MVMovieListType;

#endif /* MVConstants_h */
