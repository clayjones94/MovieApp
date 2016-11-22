//
//  MVMovie.m
//  MovieApp
//
//  Created by Clay Jones on 11/20/16.
//  Copyright © 2016 ClayJones. All rights reserved.
//

#import "MVMovie.h"

@implementation MVMovie

@synthesize adult = _adult;
@synthesize backdropPath = _backdropPath;
@synthesize belongsToCollection = _belongsToCollection;
@synthesize budget = _budget;
@synthesize genres = _genres;
@synthesize homepage = _homepage;
@synthesize movieID = _movieID;
@synthesize imdbID = _imdbID;
@synthesize originalLanguage = _originalLanguage;
@synthesize originalTitle = _originalTitle;
@synthesize overview = _overview;
@synthesize popularity = _popularity;
@synthesize posterPath = _posterPath;
@synthesize productionCompanies = _productionCompanies;
@synthesize productionCountries = _productionCountries;
@synthesize releaseDate = _releaseDate;
@synthesize revenue = _revenue;
@synthesize runtime = _runtime;
@synthesize spokenLanguages = _spokenLanguages;
@synthesize status = _status;
@synthesize tagline = _tagline;
@synthesize title = _title;
@synthesize video = _video;
@synthesize voteAverage = _voteAverage;
@synthesize voteCount = _voteCount;

-(instancetype) initWithDictionary: (NSDictionary *) dict {
    self = [super init];
    if (self) {
        _adult = [dict objectForKey:@"adult"];
        _backdropPath = [dict objectForKey:@"backdrop_path"];
        _belongsToCollection = [dict objectForKey:@"belongs_to_collection"];
        _budget = [[dict objectForKey:@"budget"] integerValue];
        _genres = [dict objectForKey:@"genres"];
        _homepage = [dict objectForKey:@"homepage"];
        _movieID = [[dict objectForKey:@"id"] integerValue];
        _imdbID = [dict objectForKey:@"imdb_db"];
        _originalLanguage = [dict objectForKey:@"original_language"];
        _originalTitle = [dict objectForKey:@"original_title"];
        _overview = [dict objectForKey:@"adult"];
        _popularity = [[dict objectForKey:@"popularity"] decimalValue];
        _posterPath = [dict objectForKey:@"poster_path"];
        _productionCompanies = [dict objectForKey:@"production_companies"];
        _productionCountries = [dict objectForKey:@"production_countries"];
        _releaseDate = [[dict objectForKey:@"release_date"] substringToIndex:4];
        _revenue = [[dict objectForKey:@"revenue"] integerValue];
        _runtime = [[dict objectForKey:@"runtime"] integerValue];
        _spokenLanguages = [dict objectForKey:@"spoken_languages"];
        _status = [dict objectForKey:@"status"];
        _tagline = [dict objectForKey:@"tagline"];
        _title = [dict objectForKey:@"title"];
        _video = [dict objectForKey:@"video"];
        _voteAverage = [[dict objectForKey:@"vote_average"] decimalValue];
        _voteCount = [[dict objectForKey:@"vote_count"] integerValue];
    }
    return self;
}

@end
