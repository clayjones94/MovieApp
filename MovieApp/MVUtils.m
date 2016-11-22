//
//  MVUtils.m
//  MovieApp
//
//  Created by Clay Jones on 11/20/16.
//  Copyright © 2016 ClayJones. All rights reserved.
//

#import "MVUtils.h"

@implementation MVUtils

+(UIColor *)mainColor {
    return [UIColor colorWithRed:(251.0f/256.f)
                           green:(146.0f/256.f)
                            blue:(98.0f/256.f)
                           alpha:(1.0f)];
}

+(UIColor *)starColor {
    return [UIColor colorWithRed:(255.0f/256.f)
                           green:(205.0f/256.f)
                            blue:(0.0f/256.f)
                           alpha:(1.0f)];
}

+(UIColor *)clockColor {
    return [UIColor colorWithRed:(0.0f/256.f)
                           green:(118.0f/256.f)
                            blue:(255.0f/256.f)
                           alpha:(1.0f)];
}

+(NSString *) stringForListType: (MVMovieListType) listType {
    NSString *title = @"";
    if (listType == NOW_PLAYING) {
        title = @"NOW PLAYING";
    } else if (listType == POPULAR) {
        title = @"POPULAR";
    } else if (listType == TOP_RATED) {
        title = @"TOP RATED";
    } else if (listType == UPCOMING) {
        title = @"UPCOMING";
    }
    return title;
}

@end
