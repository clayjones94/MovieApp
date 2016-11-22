//
//  MVMovieDetailViewController.h
//  MovieApp
//
//  Created by Clay Jones on 11/21/16.
//  Copyright © 2016 ClayJones. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MVMovie.h"

@interface MVMovieDetailViewController : UIViewController

@property MVMovie *movie;

-(void) animatePresentationWithStartRect: (CGRect) rect withBackgroundImage:(UIImage *) backgroundImage;

@end
