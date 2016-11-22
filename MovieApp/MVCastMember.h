//
//  MVCastMember.h
//  MovieApp
//
//  Created by Clay Jones on 11/21/16.
//  Copyright © 2016 ClayJones. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MVCastMember : NSObject

@property NSInteger castID;
@property NSString *character;
@property NSString *creditID;
@property NSInteger ID;
@property NSString *name;
@property NSInteger order;
@property NSString *profilePath;

-(instancetype) initWithDictionary: (NSDictionary *) dict;

@end
