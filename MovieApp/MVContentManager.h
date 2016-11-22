//
//  MVContentManager.h
//  MovieApp
//
//  Created by Clay Jones on 11/20/16.
//  Copyright © 2016 ClayJones. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MVConstants.h"
#import "MVCastMember.h"
#import "MVMovie.h"

@interface MVContentManager : NSObject

+ (MVContentManager *)sharedManager;

-(NSArray *) getMovies;
-(void) loadMoviesForListType: (MVMovieListType)listType forPage: (NSInteger)page withCompletionBlock: (void(^)(BOOL success)) block;
-(void) loadCastForMovie: (MVMovie *)movie withCompletionBlock: (void(^)(NSArray<MVCastMember *> * cast,BOOL success)) block;
-(void) loadTrailerForMovie: (MVMovie *)movie withCompletionBlock: (void(^)(NSString *youtubeID,BOOL success)) block;

@end
