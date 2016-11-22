//
//  MVMovie.h
//  MovieApp
//
//  Created by Clay Jones on 11/20/16.
//  Copyright © 2016 ClayJones. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MVMovie : NSObject

@property BOOL adult;
@property NSString *backdropPath;
@property NSDictionary *belongsToCollection;
@property NSInteger budget;
@property NSArray *genres;
@property NSString *homepage;
@property NSInteger movieID;
@property NSString *imdbID;
@property NSString *originalLanguage;
@property NSString *originalTitle;
@property NSString *overview;
@property NSDecimal popularity;
@property NSString *posterPath;
@property NSArray *productionCompanies;
@property NSArray *productionCountries;
@property NSString *releaseDate;
@property NSInteger revenue;
@property NSInteger runtime;
@property NSArray *spokenLanguages;
@property NSString *status;
@property NSString *tagline;
@property NSString *title;
@property BOOL video;
@property NSDecimal voteAverage;
@property NSInteger voteCount;

-(instancetype) initWithDictionary: (NSDictionary *) dict;

@end
