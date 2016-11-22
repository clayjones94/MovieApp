//
//  MVMovieCastView.h
//  MovieApp
//
//  Created by Clay Jones on 11/21/16.
//  Copyright © 2016 ClayJones. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MVCastMember.h"
#import "MVMovie.h"

@interface MVMovieCastView : UIView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) MVMovie *movie;

@end
