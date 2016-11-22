//
//  MVUtils.h
//  MovieApp
//
//  Created by Clay Jones on 11/20/16.
//  Copyright © 2016 ClayJones. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MVConstants.h"

@interface MVUtils : NSObject

+(UIColor *)mainColor;
+(UIColor *)starColor;
+(UIColor *)clockColor;

+(NSString *) stringForListType: (MVMovieListType) listType;

@end
