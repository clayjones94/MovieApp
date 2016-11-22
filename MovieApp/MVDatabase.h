//
//  MVDatabase.h
//  MovieApp
//
//  Created by Clay Jones on 11/20/16.
//  Copyright © 2016 ClayJones. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MVConstants.h"
#import "MVMovie.h"

@interface MVDatabase : NSObject

+ (void)loadMoviesForListType: (MVMovieListType) listType forPage: (NSInteger) pageNumber withBlock:(void(^)(NSDictionary *data, BOOL success))block;
+ (void)loadCastForMovie:(MVMovie *) movie withBlock:(void(^)(NSDictionary *data, BOOL success))block;
+ (void)loadTrailerForMovie:(MVMovie *) movie withBlock:(void(^)(NSDictionary *data, BOOL success))block;

@end
