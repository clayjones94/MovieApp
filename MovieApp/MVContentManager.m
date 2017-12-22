//
//  MVContentManager.m
//  MovieApp
//
//  Created by Clay Jones on 11/20/16.
//  Copyright © 2016 ClayJones. All rights reserved.
//

#import "MVContentManager.h"
#import "MVDatabase.h"
#import "MVMovie.h"

@implementation MVContentManager {
    NSMutableArray<MVMovie *> *_movies;
}

+ (MVContentManager *)sharedManager {
    static MVContentManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (id)init {
    if (self == [super init]) {
        _movies = [NSMutableArray new];
    }
    return self;
}

-(NSArray *) getMovies {
    return _movies;
}

-(void) loadMoviesForID: (NSString *)movieID withCompletionBlock: (void(^)(BOOL success, MVMovie *movie)) block {
    [MVDatabase loadMovie: movieID withBlock:^(NSDictionary *data, BOOL success) {
        if (success) {
            MVMovie *movie = [[MVMovie alloc] initWithDictionary:data];
            block(success, movie);
        }
        block(success, nil);
    }];
}

-(void) loadMoviesForListType: (MVMovieListType)listType forPage: (NSInteger)page withCompletionBlock: (void(^)(BOOL success)) block {
    if (page == 1) {
        _movies = [NSMutableArray new];
    }
    [MVDatabase loadMoviesForListType: listType forPage:page withBlock:^(NSDictionary *data, BOOL success) {
        if (success) {
            NSArray *results = [data objectForKey:@"results"];
            for (NSInteger i = 0; i < results.count; i ++) {
                MVMovie *movie = [[MVMovie alloc] initWithDictionary:[results objectAtIndex:i]];
                [_movies addObject:movie];
            }
        }
        block(success);
    }];
}

-(void) loadCastForMovie: (MVMovie *)movie withCompletionBlock: (void(^)(NSArray<MVCastMember *> * cast,BOOL success)) block {
    [MVDatabase loadCastForMovie:movie withBlock:^(NSDictionary *data, BOOL success) {
        NSMutableArray<MVCastMember *> *cast = [NSMutableArray new];
        if (success) {
            NSArray *results = [data objectForKey:@"cast"];
            for (NSInteger i = 0; i < results.count; i ++) {
                MVCastMember *member = [[MVCastMember alloc] initWithDictionary:[results objectAtIndex:i]];
                [cast addObject:member];
            }
        }
        block(cast, success);
    }];
}

-(void) loadTrailerForMovie: (MVMovie *)movie withCompletionBlock: (void(^)(NSString *youtubeID,BOOL success)) block {
    [MVDatabase loadTrailerForMovie:movie withBlock:^(NSDictionary *data, BOOL success) {
        NSString *youtubeID = @"";
        NSArray *results = [data objectForKey:@"results"];
        if (success) {
            for (NSInteger i = 0; i < results.count; i ++) {
                NSDictionary *video = [results objectAtIndex:i];
                if ([[video objectForKey:@"site"] isEqualToString:@"YouTube"]) {
                    youtubeID = [video objectForKey:@"key"];
                }
            }
        }
        block(youtubeID, success);
    }];
}

@end
