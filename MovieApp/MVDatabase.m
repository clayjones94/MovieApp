//
//  MVDatabase.m
//  MovieApp
//
//  Created by Clay Jones on 11/20/16.
//  Copyright © 2016 ClayJones. All rights reserved.
//

#import "MVDatabase.h"

@implementation MVDatabase

static NSString *const API_URL = @"https://api.themoviedb.org/3/";
static NSString *const API_KEY = @"4b11d1d4fb29804b66cf3646f2727c93";

+ (void)loadMoviesForListType: (MVMovieListType) listType forPage: (NSInteger) pageNumber withBlock:(void(^)(NSDictionary *data, BOOL success))block{
    NSString *url;
    if (listType == NOW_PLAYING) {
        url = [NSString stringWithFormat:@"movie/now_playing"];
    } else if (listType == POPULAR) {
        url = [NSString stringWithFormat:@"movie/popular"];
    } else if (listType == TOP_RATED) {
        url = [NSString stringWithFormat:@"movie/top_rated"];
    } else if (listType == UPCOMING) {
        url = [NSString stringWithFormat:@"movie/upcoming"];
    }
    [self makeGETRequestToEndpoint:url withBodyData:@{@"page":[NSNumber numberWithInteger: pageNumber], @"sort_by":@"popularity.desc", @"language":@"en-US"} withBlock:block];
}

+ (void)loadCastForMovie:(MVMovie *) movie withBlock:(void(^)(NSDictionary *data, BOOL success))block{
    NSString *url = [NSString stringWithFormat:@"movie/%@/credits", [NSNumber numberWithInteger: movie.movieID]];

    [self makeGETRequestToEndpoint:url withBodyData:@{} withBlock:block];
}

+ (void)loadTrailerForMovie:(MVMovie *) movie withBlock:(void(^)(NSDictionary *data, BOOL success))block{
    NSString *url = [NSString stringWithFormat:@"movie/%@/videos", [NSNumber numberWithInteger: movie.movieID]];
    
    [self makeGETRequestToEndpoint:url withBodyData:@{} withBlock:block];
}

+ (void)makeGETRequestToEndpoint:(NSString *)endpoint withBodyData:(NSDictionary *)data withBlock:(void (^)(NSDictionary *data, BOOL success))block {
    NSString *queryString = [self encodeDictionary:data];
    NSString *completeURL;
    if (queryString.length > 0) {
        completeURL = [NSString stringWithFormat: @"%@%@?api_key=%@&%@",API_URL, endpoint, API_KEY, queryString];
    } else {
        completeURL = [NSString stringWithFormat: @"%@%@?api_key=%@",API_URL, endpoint, API_KEY];
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:completeURL]];
    request.HTTPMethod = @"GET";
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!data) {
            block(@{}, NO);
            return;
        }
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                             options:kNilOptions
                                                               error:&error];
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        if (error || [httpResponse statusCode] != 200) {
            block(json, NO);
        } else {
            block(json, YES);
        }
    }];
    
    [task resume];
}

+ (NSString*)encodeDictionary:(NSDictionary*)dictionary {
    NSMutableArray *parts = [[NSMutableArray alloc] init];
    for (NSString *key in dictionary) {
        NSString *encodedValue;
        if ([[dictionary objectForKey:key] isKindOfClass:[NSString class]]) {
            encodedValue = [[dictionary objectForKey:key] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        } else {
            encodedValue = [[NSString stringWithFormat:@"%@",[dictionary objectForKey:key]] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        }
        NSString *encodedKey = [key stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSString *part = [NSString stringWithFormat: @"%@=%@", encodedKey, encodedValue];
        [parts addObject:part];
    }
    NSString *encodedDictionary = [parts componentsJoinedByString:@"&"];
    return encodedDictionary;
}

@end
