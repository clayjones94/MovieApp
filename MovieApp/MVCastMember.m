//
//  MVCastMember.m
//  MovieApp
//
//  Created by Clay Jones on 11/21/16.
//  Copyright © 2016 ClayJones. All rights reserved.
//

#import "MVCastMember.h"

@implementation MVCastMember

@synthesize castID = _castID;
@synthesize character = _character;
@synthesize creditID = _creditID;
@synthesize ID = _ID;
@synthesize name = _name;
@synthesize order = _order;
@synthesize profilePath = _profilePath;

-(instancetype) initWithDictionary: (NSDictionary *) dict {
    self = [super init];
    if (self) {
        _castID = [[dict objectForKey:@"cast_id"]integerValue];
        _character = [dict objectForKey:@"character"];
        _creditID = [dict objectForKey:@"credit_id"];
        _ID = [[dict objectForKey:@"id"] integerValue];
        _name = [dict objectForKey:@"name"];
        _order = [[dict objectForKey:@"order"] integerValue];
        _profilePath = [dict objectForKey:@"profile_path"];
    }
    return self;
}

@end
